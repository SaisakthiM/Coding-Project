#!/usr/bin/env python3
"""Match handwritten student names against UG CONSORTIUM.xlsx and download mark statements.

Install:
    python -m pip install openpyxl rapidfuzz playwright
    python -m playwright install chromium

Example (report only):
    python download_mark_statements.py --excel "UG CONSORTIUM.xlsx" --out "mark_statements"

Download high-confidence matches:
    python download_mark_statements.py --excel "UG CONSORTIUM.xlsx" --out "mark_statements" --download --headed

Also download review/duplicate matches after verifying their APP NO values:
    python download_mark_statements.py --excel "UG CONSORTIUM.xlsx" --out "mark_statements" --download --headed --include-review

The script ignores handwritten numbers and uses the Excel APP NO column.
It regenerates matched_students.csv each run. --include-review allows rows below
threshold and duplicate-APP-NO rows into the download queue; inspect the report first.
"""

from __future__ import annotations

import argparse
import csv
import re
import sys
import time
from pathlib import Path
from typing import Any

from openpyxl import load_workbook
from rapidfuzz import fuzz, process
from playwright.sync_api import sync_playwright, TimeoutError as PlaywrightTimeoutError

URL = "http://209.38.124.171:3000/mark-statement-ug.html"

# Names transcribed from the two provided photographs.
LIST_NAMES = [
    "C Saravana Kumar", "Sanjay C", "Sudharshan G T", "Sanjay V",
    "P Prakash", "Rakesh M", "Sivabalaji G", "Saifudeen Z", "Tharunika S",
    "Roopakt Raj", "Priyadharshini B S", "Ruthika R", "Swaminathan B",
    "Sriram P", "Soumiya S", "Tamil Arasi R", "Srija B", "Reena C",
    "Varshini N", "Sruthi S", "Shruthi J", "S Yershini", "Rekha N",
    "Rethika J", "Steffi Grace G", "Thusanthini A", "Trinita Barbara M",
    "Srischnya Angel V", "Sajana H", "Srinivasan M", "Saran K",
    "T R Sanjay", "Sham Sundar V", "Rejinath B", "Sanjay Mukundhan S",
    "Yashivanth K", "Sarvesh V", "Tharun Karthik I", "Tamil Arasan S",
]


def norm(value: Any) -> str:
    value = "" if value is None else str(value)
    value = value.upper().replace("&", " AND ")
    return re.sub(r"[^A-Z0-9]+", " ", value).strip()


def safe_name(value: str) -> str:
    value = re.sub(r'[<>:"/\\|?*\x00-\x1f]', "_", value).strip(" .")
    return re.sub(r"\s+", " ", value) or "Unknown Student"


def read_consortium(path: Path) -> list[dict[str, str]]:
    wb = load_workbook(path, read_only=True, data_only=True)
    try:
        ws = wb["UG"] if "UG" in wb.sheetnames else wb[wb.sheetnames[0]]
        header_row = None
        headers: list[str] = []
        for row_num, row in enumerate(ws.iter_rows(min_row=1, max_row=15, values_only=True), 1):
            vals = [norm(x) for x in row]
            if "STUDENT NAME" in vals and "APP NO" in vals:
                header_row, headers = row_num, vals
                break
        if not header_row:
            raise ValueError("Could not find a header row containing STUDENT NAME and APP NO")

        name_idx, app_idx = headers.index("STUDENT NAME"), headers.index("APP NO")
        records = []
        for row in ws.iter_rows(min_row=header_row + 1, values_only=True):
            if name_idx >= len(row) or not row[name_idx]:
                continue
            name = str(row[name_idx]).strip()
            app_no = row[app_idx] if app_idx < len(row) else None
            if app_no is None or str(app_no).strip() == "":
                continue
            records.append({
                "excel_name": name,
                "app_no": str(app_no).strip().removesuffix(".0"),
            })
        return records
    finally:
        wb.close()


def match_names(names, records, threshold: int):
    # Keep the first record for each normalized name, as in the original script.
    choices = {r["excel_name"]: r for r in records}
    choice_norms = {norm(n): n for n in choices}
    norm_choices = list(choice_norms.keys())
    result = []

    for source_name in names:
        key = norm(source_name)
        if key in choice_norms:
            matched, score = choice_norms[key], 100
        else:
            best = process.extractOne(key, norm_choices, scorer=fuzz.ratio)
            if best:
                candidate_norm, score, _ = best
                matched = choice_norms[candidate_norm]
            else:
                matched, score = "", 0

        if matched and score >= threshold:
            rec = choices[matched]
            result.append({
                "list_name": source_name, "excel_name": rec["excel_name"],
                "app_no": rec["app_no"], "score": score, "status": "MATCHED",
            })
        else:
            result.append({
                "list_name": source_name, "excel_name": matched,
                "app_no": choices[matched]["app_no"] if matched else "",
                "score": score, "status": "REVIEW / UNMATCHED",
            })

    # Flag repeated APP NO values rather than silently treating them as unique students.
    seen = set()
    for row in result:
        if row["status"] == "MATCHED":
            if row["app_no"] in seen:
                row["status"] = "DUPLICATE APP NO - REVIEW"
            else:
                seen.add(row["app_no"])
    return result


def write_csv(path: Path, rows):
    fields = ["list_name", "excel_name", "app_no", "score", "status"]
    with path.open("w", newline="", encoding="utf-8-sig") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)


def locate_app_input(page, explicit_selector: str | None):
    if explicit_selector:
        loc = page.locator(explicit_selector).first
        loc.wait_for(state="visible", timeout=8000)
        return loc

    inputs = page.locator("input:visible")
    candidates = []
    for i in range(inputs.count()):
        item = inputs.nth(i)
        typ = (item.get_attribute("type") or "text").lower()
        if typ in {"hidden", "submit", "button", "checkbox", "radio", "file"}:
            continue
        description = " ".join(filter(None, [
            item.get_attribute("name"), item.get_attribute("id"),
            item.get_attribute("placeholder"), item.get_attribute("aria-label"),
        ])).lower()
        score = 0
        if any(k in description for k in ("app", "application", "register", "registration", "roll", "number", "no")):
            score += 5
        if typ in {"text", "number", "tel", "search"}:
            score += 1
        candidates.append((score, item, description))

    if not candidates:
        raise RuntimeError("No visible text-like input was found. Inspect the page and set --input-selector.")
    candidates.sort(key=lambda x: x[0], reverse=True)
    if len(candidates) > 1 and candidates[0][0] == candidates[1][0]:
        details = [d or "(no id/name/placeholder)" for _, _, d in candidates]
        raise RuntimeError("Could not safely identify the application-number input. Inputs: " + "; ".join(details) + ". Set --input-selector.")
    return candidates[0][1]


def submit_and_save(page, app_no: str, dest: Path, input_selector: str | None, submit_selector: str | None):
    field = locate_app_input(page, input_selector)
    field.fill(app_no)

    if submit_selector:
        submit = page.locator(submit_selector).first
    else:
        buttons = page.locator("button:visible, input[type=submit]:visible, input[type=button]:visible")
        best = None
        for i in range(buttons.count()):
            b = buttons.nth(i)
            label = " ".join(filter(None, [
                b.inner_text() if b.evaluate("el => el.tagName.toLowerCase() === 'button'") else "",
                b.get_attribute("value"), b.get_attribute("aria-label"),
            ])).lower()
            score = 1 if label.strip() else 0
            if any(k in label for k in ("search", "submit", "view", "download", "get", "proceed", "show")):
                score += 5
            if best is None or score > best[0]:
                best = (score, b)
        if not best or best[0] == 0:
            raise RuntimeError("Could not identify a submit/search button. Set --submit-selector.")
        submit = best[1]

    dest.mkdir(parents=True, exist_ok=True)
    before = set(dest.iterdir())
    try:
        with page.expect_download(timeout=15000) as download_info:
            submit.click()
        download = download_info.value
        filename = safe_name(download.suggested_filename or f"{app_no}.pdf")
        target = dest / filename
        if target.exists():
            target = dest / f"{app_no}_{filename}"
        download.save_as(target)
        return f"DOWNLOADED: {target.name}"
    except PlaywrightTimeoutError:
        # Some sites open the PDF inline rather than triggering a browser download.
        page.wait_for_timeout(2500)
        new_files = set(dest.iterdir()) - before
        if new_files:
            return "CHECK OUTPUT: " + ", ".join(p.name for p in new_files)
        text = " ".join(page.locator("body").inner_text().split())[:350]
        raise RuntimeError("No browser download was triggered. Page says: " + text)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--excel", type=Path, default=Path("UG CONSORTIUM.xlsx"))
    parser.add_argument("--out", type=Path, default=Path("mark_statements"))
    parser.add_argument("--url", default=URL)
    parser.add_argument("--threshold", type=int, default=90, help="Fuzzy name match threshold (0-100); higher is safer")
    parser.add_argument("--headed", action="store_true", help="Show the browser window")
    parser.add_argument("--input-selector", help="CSS selector for the application-number field, if auto-detection fails")
    parser.add_argument("--submit-selector", help="CSS selector for the search/submit button, if auto-detection fails")
    parser.add_argument("--download", action="store_true", help="Actually download statements; without this flag only create the matching report")
    parser.add_argument(
        "--include-review", action="store_true",
        help="Also download REVIEW / UNMATCHED and DUPLICATE APP NO - REVIEW rows (verify APP NOs first)",
    )
    parser.add_argument("--pause", type=float, default=1.0, help="Seconds to wait between requests")
    args = parser.parse_args()

    if not args.excel.exists():
        sys.exit(f"Excel file not found: {args.excel.resolve()}")
    if not 0 <= args.threshold <= 100:
        sys.exit("--threshold must be between 0 and 100")

    records = read_consortium(args.excel)
    rows = match_names(LIST_NAMES, records, args.threshold)
    args.out.mkdir(parents=True, exist_ok=True)
    report = args.out / "matched_students.csv"
    write_csv(report, rows)

    eligible_statuses = {"MATCHED"}
    if args.include_review:
        eligible_statuses.update({"REVIEW / UNMATCHED", "DUPLICATE APP NO - REVIEW"})
    selected = [r for r in rows if r["status"] in eligible_statuses and r["app_no"]]
    not_selected = [r for r in rows if r not in selected]

    print(f"Consortium records read: {len(records)}")
    print(f"Selected for download: {len(selected)} | Not selected: {len(not_selected)}")
    print(f"Report: {report.resolve()}")
    for row in not_selected:
        print(f"REVIEW: {row['list_name']} -> {row['excel_name']!r} (APP NO {row['app_no']!r}, score {row['score']})")

    if not args.download:
        print("Report-only mode. Rerun with --download to fetch files.")
        return
    if args.include_review:
        print("WARNING: --include-review includes low-confidence and duplicate-APP-NO rows. Verify mappings before distribution.")

    # Skip application numbers already represented by a PDF in the output tree.
    existing_app_nos = set()
    for pdf in args.out.rglob("*.pdf"):
        match = re.search(r"(?:UG_Mark_Statement_)?(\d{5,})", pdf.name)
        if match:
            existing_app_nos.add(match.group(1))

    queue = [r for r in selected if r["app_no"] not in existing_app_nos]
    skipped_existing = len(selected) - len(queue)
    if skipped_existing:
        print(f"Skipping {skipped_existing} selected rows whose APP NO appears in an existing PDF filename.")
    if not queue:
        print("Nothing new to download.")
        return

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=not args.headed)
        context = browser.new_context(accept_downloads=True)
        page = context.new_page()
        try:
            try:
                page.goto(args.url, wait_until="domcontentloaded", timeout=20000)
            except Exception as e:
                sys.exit(f"Could not open {args.url}: {e}\nCheck that the server is running and reachable, then retry.")

            print("Page opened. Starting downloads; failed records will be written to download_log.csv.")
            log_rows = []
            for idx, row in enumerate(queue, 1):
                student_dir = args.out / safe_name(row["excel_name"])
                try:
                    if idx > 1:
                        page.goto(args.url, wait_until="domcontentloaded", timeout=20000)
                    status = submit_and_save(page, row["app_no"], student_dir, args.input_selector, args.submit_selector)
                    print(f"[{idx}/{len(queue)}] {row['list_name']} -> {row['excel_name']} (APP NO {row['app_no']}): {status}")
                    log_rows.append({"list_name": row["list_name"], "student": row["excel_name"], "app_no": row["app_no"], "score": row["score"], "status": status})
                except Exception as e:
                    msg = str(e)
                    print(f"[{idx}/{len(queue)}] FAILED {row['list_name']} -> {row['excel_name']} ({row['app_no']}): {msg}")
                    log_rows.append({"list_name": row["list_name"], "student": row["excel_name"], "app_no": row["app_no"], "score": row["score"], "status": "FAILED: " + msg})
                time.sleep(max(0, args.pause))
            with (args.out / "download_log.csv").open("w", newline="", encoding="utf-8-sig") as f:
                writer = csv.DictWriter(f, fieldnames=["list_name", "student", "app_no", "score", "status"])
                writer.writeheader()
                writer.writerows(log_rows)
        finally:
            context.close()
            browser.close()
    print(f"Finished. Output folder: {args.out.resolve()}")


if __name__ == "__main__":
    main()
