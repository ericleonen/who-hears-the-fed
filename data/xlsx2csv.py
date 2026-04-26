import pandas as pd
from pathlib import Path
 
FILES = [
    "data/raw/FRBNY-SCE-Public-Microdata-Complete-13-16.xlsx",
    "data/raw/FRBNY-SCE-Public-Microdata-Complete-17-19.xlsx",
    "data/raw/frbny-sce-public-microdata-latest.xlsx",
]
 
for f in FILES:
    path = Path(f)
    if not path.exists():
        print(f"Skipping (not found): {path}")
        continue
 
    out = path.with_suffix(".csv")
    print(f"Converting {path.name} -> {out.name} ...")
    df = pd.read_excel(path, sheet_name="Data", skiprows=1)
    df.to_csv(out, index=False)
    print(f"  Done. {len(df):,} rows, {len(df.columns)} columns.")
 
print("All done.")
