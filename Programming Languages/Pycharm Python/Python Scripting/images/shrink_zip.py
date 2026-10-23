#!/usr/bin/env python3
"""
Compress EACH image in a ZIP to under a per-image size limit (default 20 KB), then re-zip.

Usage:
    python shrink_zip.py input.zip output.zip
    python shrink_zip.py input.zip output.zip --max-kb 20 --format jpeg --min-quality 30

Requires: pip install pillow

Per image: keeps full resolution if possible, lowers quality down to --min-quality,
then shrinks the dimensions step by step until it fits. Images already under the
limit are copied untouched.
"""
import argparse
import io
import sys
import zipfile
from pathlib import PurePosixPath

from PIL import Image, ImageOps

IMG_EXTS = {".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp", ".tif", ".tiff"}


def to_rgb(im):
    if im.mode in ("RGBA", "LA") or (im.mode == "P" and "transparency" in im.info):
        im = im.convert("RGBA")
        bg = Image.new("RGB", im.size, (255, 255, 255))
        bg.paste(im, mask=im.split()[-1])
        return bg
    return im.convert("RGB")


def encode(im, fmt, quality):
    buf = io.BytesIO()
    if fmt == "webp":
        im.save(buf, "WEBP", quality=quality, method=6)
    else:
        im.save(buf, "JPEG", quality=quality, optimize=True, progressive=True)
    return buf.getvalue()


def compress(im, fmt, limit, min_q, max_q=90):
    """Return smallest-change encoding that fits under limit."""
    im = to_rgb(ImageOps.exif_transpose(im))
    scale = 1.0
    w0, h0 = im.size
    while True:
        w, h = max(1, int(w0 * scale)), max(1, int(h0 * scale))
        cur = im if scale == 1.0 else im.resize((w, h), Image.LANCZOS)
        # does the lowest allowed quality fit at this size?
        if len(encode(cur, fmt, min_q)) <= limit:
            lo, hi, best = min_q, max_q, None
            while lo <= hi:  # find highest quality that fits
                mid = (lo + hi) // 2
                data = encode(cur, fmt, mid)
                if len(data) <= limit:
                    best, lo = data, mid + 1
                else:
                    hi = mid - 1
            return best, (w, h)
        if w <= 8 or h <= 8:  # give up shrinking, return smallest possible
            return encode(cur, fmt, 1), (w, h)
        scale *= 0.9


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("input")
    ap.add_argument("output")
    ap.add_argument("--max-kb", type=float, default=20, help="max size PER IMAGE")
    ap.add_argument("--format", choices=["jpeg", "webp"], default="jpeg")
    ap.add_argument("--min-quality", type=int, default=30)
    args = ap.parse_args()

    limit = int(args.max_kb * 1024)
    ext = ".jpg" if args.format == "jpeg" else ".webp"
    used = set()

    with zipfile.ZipFile(args.input) as zin, \
         zipfile.ZipFile(args.output, "w", zipfile.ZIP_STORED) as zout:
        for info in zin.infolist():
            if info.is_dir() or PurePosixPath(info.filename).name.startswith("."):
                continue
            p = PurePosixPath(info.filename)
            raw = zin.read(info)

            if p.suffix.lower() not in IMG_EXTS:
                zout.writestr(info.filename, raw)  # non-image: copy as-is
                used.add(info.filename)
                continue

            if len(raw) <= limit:  # already small enough
                zout.writestr(info.filename, raw)
                used.add(info.filename)
                print(f"{info.filename}: {len(raw)/1024:.1f} KB (unchanged)")
                continue

            try:
                im = Image.open(io.BytesIO(raw))
                im.load()
            except Exception as e:
                print(f"skip {info.filename}: {e}", file=sys.stderr)
                continue

            data, size = compress(im, args.format, limit, args.min_quality)
            name = str(p.with_suffix(ext))
            k = 1
            while name in used:  # avoid a.png / a.jpg collisions
                name = str(p.with_suffix("")) + f"_{k}{ext}"
                k += 1
            used.add(name)
            zout.writestr(name, data)
            flag = "" if len(data) <= limit else "  (STILL OVER LIMIT)"
            print(f"{info.filename} -> {name}: {len(raw)/1024:.0f} KB -> "
                  f"{len(data)/1024:.1f} KB at {size[0]}x{size[1]}{flag}")

    print(f"Done -> {args.output}")


if __name__ == "__main__":
    main()