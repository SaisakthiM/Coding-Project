"""
ERP Sheet Generator
Reads: 
  1. CSE C BIODATA FORM 2026 (Responses).xlsx
  2. CSE C STUDENTS DETAILS 2026 (Responses).xlsx
  3. erp.xlsx (template)
  4. ERP Details (Responses).xlsx
Output:
  ERP_Filled.xlsx  - Consolidated ERP sheet
  MISSING_REPORT.xlsx - Report of missing data
"""

import pandas as pd
import numpy as np
from datetime import datetime
import re

# ============================================================
# CONFIG - Update these paths to your actual file locations
# ============================================================
BIODATA_FILE   = "CSE C BIODATA FORM 2026 (Responses).xlsx"
DETAILS_FILE   = "CSE C STUDENTS DETAILS 2026 (Responses).xlsx"
ERP_TEMPLATE   = "erp.xlsx"
ERP_DETAILS    = "ERP Details (Responses).xlsx"
OUTPUT_FILE    = "ERP_Filled.xlsx"
MISSING_FILE   = "MISSING_REPORT.xlsx"


# ============================================================
# HELPER FUNCTIONS
# ============================================================
def clean_str(val):
    """Return clean string, treating NaN/None/NIL as empty."""
    if pd.isna(val):
        return ""
    s = str(val).strip()
    if s.lower() in ("nan", "none", "nil", "null", "-", "nill", "n/a", "na"):
        return ""
    return s


def parse_date(val):
    """Try to normalise date to DD-MM-YYYY."""
    if pd.isna(val) or val == "":
        return ""
    try:
        if isinstance(val, datetime):
            return val.strftime("%d-%m-%Y")
        s = str(val).strip()
        for fmt in ("%Y-%m-%d %H:%M:%S", "%Y-%m-%d", "%d-%m-%Y",
                    "%d/%m/%Y", "%d.%m.%Y", "%d %m %Y"):
            try:
                return datetime.strptime(s, fmt).strftime("%d-%m-%Y")
            except ValueError:
                continue
        return s
    except Exception:
        return str(val)


def clean_phone(val):
    """Normalise phone numbers - remove .0, spaces, +91."""
    s = clean_str(val)
    if not s:
        return ""
    s = s.replace(" ", "").replace("+91", "").replace("-", "")
    if s.endswith(".0"):
        s = s[:-2]
    return s


def merge_records(biodata_row, details_row, erp_row):
    """
    Merge one student's data from up to 3 source rows.
    Priority: ERP Details > Student Details > Biodata
    """
    def get(src, key, default=""):
        if src is None:
            return default
        v = src.get(key, default)
        return v

    def first_nonempty(*vals):
        for v in vals:
            s = clean_str(v)
            if s:
                return s
        return ""

    b = biodata_row if biodata_row is not None else {}
    d = details_row if details_row is not None else {}
    e = erp_row if erp_row is not None else {}

    return {
        "Roll Number":   first_nonempty(d.get("ROLL NUMBER (eg., 26AIDS111)"),
                                        b.get("ROLL NUMBER"),
                                        e.get("ROLL NUMBER (eg., 26AIDS111)")),
        "Student Name":  first_nonempty(d.get("STUDENT NAME: (e.g., G JAGADEESAN or JAGASEESAN G)"),
                                        b.get("STUDENT NAME"),
                                        e.get("STUDENT NAME: (e.g., G JAGADEESAN or JAGASEESAN G)")),
        "Admission Date": first_nonempty(parse_date(d.get("ADMISSION DATE")),
                                         parse_date(b.get("Timestamp")),
                                         parse_date(e.get("ADMISSION DATE"))),
        "Batch":         first_nonempty(d.get("BATCH"), "2026-2030"),
        "Programme":     first_nonempty(d.get("BRANCH"), "B.E."),
        "Section":       first_nonempty(d.get("DEPARTMENT & SECTION"), "CSE - C"),
        "Semester":      first_nonempty(d.get("SEMESTER"), "1"),
        "Student Category": first_nonempty(d.get("STUDENT CATEGORY"),
                                           e.get("STUDENT CATEGORY"),
                                           b.get("CATEGORY")),
        "Admission Type": first_nonempty(d.get("ADMISSION MODE"),
                                         b.get("ADMISSION MODE")),
        "Residential Type": first_nonempty(d.get("RESIDENTIAL TYPE"),
                                           e.get("HOSTEL OR DAYSCHOLAR"),
                                           b.get("HOSTELLER (H) / DAY SCHOLAR (DS)")),
        "Gender":        first_nonempty(d.get("GENDER"), b.get("GENDER"), e.get("GENDER")),
        "Date of Birth": first_nonempty(parse_date(d.get("DATE OF BIRTH")),
                                        parse_date(b.get("DATE OF BIRTH")),
                                        parse_date(e.get("DATE OF BIRTH"))),
        "Nationality":   first_nonempty(d.get("NATIONALITY"), e.get("NATIONALITY"), "INDIAN"),
        "Religion":      first_nonempty(d.get("RELIGION"), b.get("RELIGION"), e.get("RELIGION")),
        "Community":     first_nonempty(d.get("COMMUNITY"), b.get("COMMUNITY"),
                                        e.get("COMMUNITY")),
        "Caste":         first_nonempty(d.get("CASTE"), b.get("CASTE"), e.get("CASTE")),
        "Address":       first_nonempty(d.get("COMMUNICATION ADDRESS"),
                                        b.get("RESIDENTIAL ADDRESS"),
                                        e.get("COMMUNICATION ADDRESS")),
        "Native Place":  first_nonempty(d.get("NATIVE PLACE"), b.get("NATIVE PLACE"),
                                        e.get("NATIVE PLACE")),
        "City":          first_nonempty(d.get("CITY/TOWN"), d.get("CITY"),
                                        b.get("CITY"), e.get("CITY")),
        "Pin Code":      first_nonempty(d.get("PINCODE"), b.get("PIN CODE"),
                                        e.get("CITY PIN CODE")),
        "Phone":         first_nonempty(b.get("LANDLINE (WITH STD/ISD CODE)")),
        "Student Mobile": first_nonempty(clean_phone(d.get("MOBILE NUMBER")),
                                         clean_phone(b.get("STUDENT MOBILE NUMBER")),
                                         clean_phone(e.get("MOBILE NUMBER"))),
        "Father Mobile": first_nonempty(clean_phone(d.get("FATHER MOBILE NO.")),
                                        clean_phone(b.get("FATHER'S MOBILE NUMBER")),
                                        clean_phone(e.get("FATHER MOBILE NO."))),
        "Father Name":   first_nonempty(d.get("FATHER NAME"), b.get("FATHER'S NAME"),
                                        e.get("FATHER NAME")),
        "Father Occupation": first_nonempty(d.get("FATHER OCCUPATION"),
                                            b.get("FATHER'S OCCUPATION"),
                                            e.get("FATHER OCCUPATION")),
        "Mother Name":   first_nonempty(d.get("MOTHER'S NAME"), b.get("MOTHER'S NAME"),
                                        e.get("MOTHER'S NAME")),
        "Blood Group":   first_nonempty(d.get("BLOOD GROUP"), b.get("BLOOD GROUP"),
                                        e.get("BLOOD GROUP")),
        "HSC-Institution": first_nonempty(d.get("NAME OF THE SCHOOL STUDIED (From 6th to 12th)"),
                                          b.get("SCHOOL NAME"),
                                          e.get("HSC-INSTITUTION")),
        "HSC-Marks Obtained": first_nonempty(d.get("TOTAL MARKS OBTAINED IN 12TH"),
                                             b.get("MARKS SCORED IN HSC"),
                                             e.get("HSC-MARKS OBTAINED")),
        "HSC-Mark Sheet No.": first_nonempty(d.get("12TH MARKSHEET NUMBER"),
                                             e.get("HSC-MARK SHEET NO.")),
        "HSC-Year of Passing": first_nonempty(d.get("YEAR OF PASSING (12TH)"),
                                              e.get("HSC-YEAR OF PASSING"), "2026"),
        "Father Income": first_nonempty(d.get("FATHER'S ANNUAL INCOME"),
                                        e.get("FATHER INCOME")),
        "First Graduate": first_nonempty(d.get("FIRST GRADUATE"), b.get("FIRST GRADUATE"),
                                         e.get("FIRST GRADUATE")),
        "Mother Tongue": first_nonempty(d.get("MOTHER TONGUE"), e.get("MOTHER TONGUE")),
        "Part1 Subject": first_nonempty(d.get("LANGUAGE IN 12TH"),
                                        e.get("PART1 SUBJECT")),
        "ID Mark1":      first_nonempty(d.get("IDENTIFICATION MARK"),
                                        b.get("IDENTIFICATION MARK"),
                                        e.get("IDENTIFICATION MARK 1")),
        "ID Mark2":      first_nonempty(e.get("IDENTIFICATION MARK 2")),
        "Aadhar No":     first_nonempty(clean_phone(d.get("AADHAR NO. (eg., 123456789123) (No Space)")),
                                        clean_phone(b.get("AADHAR CARD NUMBER")),
                                        clean_phone(e.get("AADHAR NO. (eg., 123456789123) (No Space)"))),
        "Bank Name":     first_nonempty(d.get("BANK NAME"), e.get("BANK NAME")),
        "IFSC Code":     first_nonempty(d.get("IFSC CODE"), e.get("IFSC CODE")),
        "MICR Code":     first_nonempty(e.get("MICR CODE")),
        "Bank A/C No":   first_nonempty(d.get("BANK ACCOUNT NUMBER"), e.get("BANK A/C NO")),
        "UMIS No":       first_nonempty(e.get("UMIS NO")),
        "Email":         first_nonempty(d.get("E-MAIL ID"), b.get("STUDENT E-MAIL"),
                                        e.get("E-MAIL ID")),
    }


# ============================================================
# LOAD FILES
# ============================================================
print("Loading files...")

bio = pd.read_excel(BIODATA_FILE, sheet_name="Form Responses 1")
det = pd.read_excel(DETAILS_FILE, sheet_name="Form Responses 1")
erp_det = pd.read_excel(ERP_DETAILS, sheet_name="Form Responses 1")

# Normalise column names (strip whitespace)
for df in (bio, det, erp_det):
    df.columns = [str(c).strip() for c in df.columns]

# Build lookup by roll number
def build_lookup(df, roll_col):
    lookup = {}
    for _, row in df.iterrows():
        roll = clean_str(row.get(roll_col, ""))
        if roll:
            lookup[roll.upper()] = row.to_dict()
    return lookup

bio_lookup = build_lookup(bio, "ROLL NUMBER")
det_lookup = build_lookup(det, "ROLL NUMBER (eg., 26AIDS111)")
erp_lookup = build_lookup(erp_det, "ROLL NUMBER (eg., 26AIDS111)")

# Collect all unique roll numbers
all_rolls = set()
for lk in (bio_lookup, det_lookup, erp_lookup):
    all_rolls.update(lk.keys())

# Sort by roll number
all_rolls = sorted(all_rolls)

print(f"Found {len(all_rolls)} unique students")
print(f"  In Biodata:     {len(bio_lookup)}")
print(f"  In Details:     {len(det_lookup)}")
print(f"  In ERP Details: {len(erp_lookup)}")


# ============================================================
# BUILD ERP ROWS
# ============================================================
erp_columns = [
    "S. No.", "Application No.", "Roll Number", "Student Name", "Register No",
    "Admission No", "Admission Date", "Batch", "Programme", "Section",
    "Semester", "Student Category", "Admission Type", "Residential Type",
    "Gender", "Date of Birth", "Nationality", "Religion", "Community", "Caste",
    "Address", "Native Place", "City", "Pin Code", "Phone", "Student Mobile",
    "Father Mobile", "Father Name", "Father Occupation", "Mother Name",
    "Blood Group", "HSC-Institution", "HSC-Marks Obtained", "HSC-Mark Sheet No.",
    "HSC-Year of Passing", "Father Income", "First Graduate", "Mother Tongue",
    "Part1 Subject", "ID Mark1", "ID Mark2", "Aadhar No", "Bank Name",
    "IFSC Code", "MICR Code", "Bank A/C No", "UMIS No", "Email"
]

rows = []
missing_rows = []

for idx, roll in enumerate(all_rolls, start=1):
    b = bio_lookup.get(roll)
    d = det_lookup.get(roll)
    e = erp_lookup.get(roll)

    # If student is NOT in ERP Details file -> leave row blank
    if e is None:
        rows.append({col: "" for col in erp_columns})
        missing_rows.append({
            "Roll Number": roll,
            "Student Name": (d or b or {}).get("STUDENT NAME: (e.g., G JAGADEESAN or JAGASEESAN G)",
                              (b or {}).get("STUDENT NAME", "")),
            "In Biodata": "YES" if b else "NO",
            "In Student Details": "YES" if d else "NO",
            "In ERP Details": "NO",
            "Reason": "Student has not submitted ERP Details form"
        })
        continue

    merged = merge_records(b, d, e)

    row = {
        "S. No.": idx,
        "Application No.": "",
        "Roll Number": merged["Roll Number"],
        "Student Name": merged["Student Name"],
        "Register No": merged["Roll Number"],   # same as roll
        "Admission No": merged["Roll Number"],  # same as roll
        "Admission Date": merged["Admission Date"],
        "Batch": merged["Batch"],
        "Programme": merged["Programme"],
        "Section": merged["Section"],
        "Semester": merged["Semester"],
        "Student Category": merged["Student Category"],
        "Admission Type": merged["Admission Type"],
        "Residential Type": merged["Residential Type"],
        "Gender": merged["Gender"],
        "Date of Birth": merged["Date of Birth"],
        "Nationality": merged["Nationality"],
        "Religion": merged["Religion"],
        "Community": merged["Community"],
        "Caste": merged["Caste"],
        "Address": merged["Address"],
        "Native Place": merged["Native Place"],
        "City": merged["City"],
        "Pin Code": merged["Pin Code"],
        "Phone": merged["Phone"],
        "Student Mobile": merged["Student Mobile"],
        "Father Mobile": merged["Father Mobile"],
        "Father Name": merged["Father Name"],
        "Father Occupation": merged["Father Occupation"],
        "Mother Name": merged["Mother Name"],
        "Blood Group": merged["Blood Group"],
        "HSC-Institution": merged["HSC-Institution"],
        "HSC-Marks Obtained": merged["HSC-Marks Obtained"],
        "HSC-Mark Sheet No.": merged["HSC-Mark Sheet No."],
        "HSC-Year of Passing": merged["HSC-Year of Passing"],
        "Father Income": merged["Father Income"],
        "First Graduate": merged["First Graduate"],
        "Mother Tongue": merged["Mother Tongue"],
        "Part1 Subject": merged["Part1 Subject"],
        "ID Mark1": merged["ID Mark1"],
        "ID Mark2": merged["ID Mark2"],
        "Aadhar No": merged["Aadhar No"],
        "Bank Name": merged["Bank Name"],
        "IFSC Code": merged["IFSC Code"],
        "MICR Code": merged["MICR Code"],
        "Bank A/C No": merged["Bank A/C No"],
        "UMIS No": merged["UMIS No"],
        "Email": merged["Email"],
    }
    rows.append(row)


# ============================================================
# WRITE OUTPUT
# ============================================================
df_out = pd.DataFrame(rows, columns=erp_columns)

with pd.ExcelWriter(OUTPUT_FILE, engine="openpyxl") as writer:
    df_out.to_excel(writer, sheet_name="studentlist", index=False)

print(f"\n✅ Wrote {OUTPUT_FILE} with {len(df_out)} rows")
print(f"   Filled rows:  {sum(1 for r in rows if r.get('Roll Number'))}")
print(f"   Blank rows:   {sum(1 for r in rows if not r.get('Roll Number'))}")


# ============================================================
# WRITE MISSING REPORT
# ============================================================
if missing_rows:
    df_miss = pd.DataFrame(missing_rows)
    with pd.ExcelWriter(MISSING_FILE, engine="openpyxl") as writer:
        df_miss.to_excel(writer, sheet_name="Missing Students", index=False)
    print(f"✅ Wrote {MISSING_FILE} with {len(df_miss)} missing students")
else:
    print("✅ No missing students — all rolls have ERP Details")


# ============================================================
# FIELD-LEVEL MISSING REPORT
# ============================================================
print("\n--- Field-level completeness (filled rows only) ---")
filled = [r for r in rows if r.get("Roll Number")]
for col in erp_columns:
    if col in ("S. No.", "Roll Number", "Register No", "Admission No",
               "Batch", "Programme", "Section", "Semester"):
        continue
    missing = sum(1 for r in filled if not clean_str(r.get(col, "")))
    pct = 100 * missing / len(filled) if filled else 0
    if missing > 0:
        print(f"  {col:30s}: {missing:3d} missing ({pct:5.1f}%)")