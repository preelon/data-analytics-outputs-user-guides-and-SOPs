# this script is prepared to respond to the PMED 2019 EFY Q1 data request

# libraries
library(tidyverse)


# reading the required data
hmis <- readRDS("monthly update/data/processed/Sep 2026 dashboard/upto_Sep_2026_hmis_for_app.rds")

Q1_2019 <- hmis |>
  filter(month_year %in% c("Jul-2026", "Aug-2026", "Sep-2026")) |>
  group_by(region, data_type, greg_year, greg_month)|>
  summarise(value = sum(value),
            .groups = "drop")|>
  select(region, year = greg_year, month = greg_month, data_type, value)


# save
write_csv(Q1_2019, "monthly update/data/ad hoc requests/2019 EFY Q1 malaria test and positive data.csv")
