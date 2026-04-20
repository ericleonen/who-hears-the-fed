# Cleans raw monetary policy surprises data into a dataset of two columns: date
# and hawkish_surprise (binary).

library(readxl)
library(here)
library(dplyr)
library(readr)

MPS_RAW_DATA_PATH <- here("data", "raw", "monetary-policy-surprises-data.xlsx")
MPS_CLEAN_DATA_PATH <- here("data", "clean", "mps.csv")

mps_raw <- read_xlsx(MPS_RAW_DATA_PATH, sheet = "FOMC (update 2023)")

# A hawkish surprise is a positive monetary surprise.
mps_clean <- mps_raw |>
  select(Date, MPS) |>
  rename(date = Date, hawkish_surprise = MPS) |>
  mutate(hawkish_surprise = as.integer(hawkish_surprise > 0))

write_csv(mps_clean, MPS_CLEAN_DATA_PATH)
