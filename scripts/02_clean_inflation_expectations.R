# Cleans raw consumer expectations data into a dataset of following columns:
# - date: Date, year and month of survey
# - user: string, unique participant identifier
# - pi_1yr: numeric, inflation estimate over the next 12 months
# - pi_2yr: numeric, inflation estimate over the next 12-24 months
# - emp: integer, 0 = not in labor force, 1 = unemployed, 2 = employed
# - emp_self: integer, 0 = has employer, 1 = self-employed
# - female: integer, 0 or 1
# - hispanic: integer, 0 or 1
# - white: integer, 0 or 1
# - black: integer, 0 or 1
# - native: integer, 0 or 1
# - pacific: integer, 0 or 1
# - education: string
# - married: integer, 0 or 1
# - state: string
# - home: integer, own or rent or NA
# - income: string, household income range

library(here)
library(dplyr)
library(readr)

SCE_RAW_DATA_PATHS <- c(here("data", "raw",
                             "FRBNY-SCE-Public-Microdata-Complete-13-16.csv"),
                        here("data", "raw",
                             "FRBNY-SCE-Public-Microdata-Complete-17-19.csv"),
                        here("data", "raw",
                             "frbny-sce-public-microdata-latest.csv"))
SCE_CLEAN_DATA_PATH <- here("data", "clean", "sce.csv")

for (path in SCE_RAW_DATA_PATHS) {
  if (!file.exists(path)) {
    stop("Inflation expectations data not found at: ", path)
  } 
}

COLS <- list(date = "date",
             user = "userid",
             pi_1yr = "Q8v2part2", pi_2yr = "Q9bv2part2",
             emp_full = "Q10_1", emp_part = "Q10_2", emp_self = "Q12new",
             emp_not = "Q10_3", emp_off = "Q10_4",
             age = "_AGE_CAT", gender = "Q33", hispanic = "Q34",
             white = "Q35_1", black = "Q35_2", native = "Q35_3",
             asian = "Q35_4", pacific = "Q35_5",
             education = "_EDU_CAT", married = "Q38",
             state = "_STATE", home = "Q43", income = "_HH_INC_CAT")

sce_raw <- lapply(SCE_RAW_DATA_PATHS, function(path) {
  read_csv(path, col_types = cols(.default = "c")) |>
    select(any_of(unlist(COLS)))
}) |>
  bind_rows()

STATIC_FIELDS <- c("female", "hispanic", "white", "black", "native", "asian",
                   "pacific", "education", "state", "income")

fill_first <- function(x) {
  first_val <- x[!is.na(x)][1]
  ifelse(is.na(x), first_val, x)
}

sce_clean <- sce_raw |>
  mutate(date = as.Date(paste0(date, "01"), format = "%Y%m%d"),
         pi_1yr = as.numeric(pi_1yr),
         pi_2yr = as.numeric(pi_2yr),
         emp = ifelse(emp_full == "1" | emp_part == "1", 2,
                      ifelse(emp_not == "1" | emp_off == "1", 1,
                             0)),
         emp_self = as.integer(emp_self),
         female = recode_values(gender,
                                "1.0" ~ 1,
                                "2.0" ~ 0),
         hispanic = as.integer(hispanic),
         white = as.integer(white),
         black = as.integer(black),
         native = as.integer(native),
         asian = as.integer(asian),
         pacific = as.integer(pacific),
         married = as.integer(married),
         home = recode_values(home,
                              "1" ~ "own",
                              "2" ~ "rent"),
         .keep = "unused") |>
  arrange(user, date) |>
  group_by(user) |>
  mutate(across(all_of(STATIC_FIELDS), fill_first)) |>
  ungroup()

write_csv(sce_clean, SCE_CLEAN_DATA_PATH)
