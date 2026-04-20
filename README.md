# Who Hears the Fed?
A Study of the Effect of Monetary Policy Surprises on Household Inflation Expectations

## Abstract

*In progress.*

## Data Sources

- **Bauer-Swanson (2023) Monetary Policy Surprise Series:** download from [Michael Bauer's faculty website](https://www.michaeldbauer.com/publication/mps/) into `data/raw/`
- **NY Fed Survey of Consumer Expectations (SCE):** download main module microdata from [NY Fed SCE page](https://www.newyorkfed.org/microeconomics/sce) (_Complete Microdata 2013-2016_, _Complete Microdata 2017-2019_, and _Latest Microdata_) into `data/raw/`

## Replication

This project uses `renv` for package management. To restore the exact package environment:
```r
install.packages("renv")
renv::restore()
```

Run all scripts in order from the project root:

```bash
Rscript scripts/01_clean_monetary_policy_surprises.R
Rscript scripts/02_clean_inflations_expectations.R
Rscript scripts/03_merge_datasets.R
Rscript scripts/04_descriptive.R
Rscript scripts/05_main_analysis.R
Rscript scripts/06_robustness.R
```

## Results

*In progress.*

## Author

*Eric Leonen* — *University of Washington*, *2026*
