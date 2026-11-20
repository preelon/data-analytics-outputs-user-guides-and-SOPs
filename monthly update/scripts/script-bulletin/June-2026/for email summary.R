rm(list = ls())

# libraries
library(tidyverse)

# read the hmis data
june_hmis_25_26 <- readRDS("Archieved/data/processed/june_2026_bulletin/june_2025_2026_hmis.rds")

# total tests
june_hmis_25_26 |>
  filter(data_type == "tested",
         greg_year== 2026) |>
  summarise(sum(value, na.rm = T)) #1918501

# total positives
june_hmis_25_26 |>
  filter(data_type == "positives",
         greg_year== 2026) |>
  summarise(sum(value, na.rm = T)) #555075

# top contribution regions
june_hmis_25_26 |>
  filter(data_type == "positives",
         greg_year == 2026) |>
  group_by(region) |>
  summarise(total = sum(value, na.rm = TRUE), .groups = "drop") |>
  arrange(desc(total))

# presumed
june_hmis_25_26 |>
  filter(data_type == "clinical",
         greg_year == 2026) |>
  summarise(total = sum(value, na.rm = TRUE), .groups = "drop")


# death in patient
june_hmis_25_26 |>
  filter(greg_year == 2026,
         outcome == "Mortality",
         department == "IPD")|>
  group_by(region)|>
  summarise(total_death = sum(value, na.rm = T))|>
  arrange(desc(total_death))


june_hmis_25_26 |>
  filter(data_type %in% c("pf_conf", "pv_conf", 
                          "pm_conf", 
                          "po_conf",
                          "mixed_conf"),
         month_year== "Jun-2026") |>
  summarise(value = sum(value, na.rm = T))

june_hmis_25_26 |>
  filter(data_type == "positives",
         month_year== "Jun-2026") |>
  
  summarise(value = sum(value, na.rm = T))


june_hmis_25_26 |>
  filter(data_type == "clinical",
         month_year== "Jun-2026") |>
  
  summarise(value = sum(value, na.rm = T))

