rm(list = ls())

# libraries
library(tidyverse)

# read the hmis data
Oct_hmis_25_26 <- readRDS("monthly update/data/processed/Oct 2026 dashboard/upto_Oct_2026_hmis_for_app.rds") |>
  filter(greg_year %in% c(2025:2026),
         greg_month == "Oct")

# total tests
Oct_hmis_25_26 |>
  filter(data_type == "tested",
         greg_year== 2026) |>
  summarise(sum(value, na.rm = T)) #1,863,737

# total positives
Oct_hmis_25_26 |>
  filter(data_type == "positives",
         greg_year== 2026) |>
  summarise(sum(value, na.rm = T)) #449,499

# top contribution regions
Oct_hmis_25_26 |>
  filter(data_type == "positives",
         greg_year == 2026) |>
  group_by(region) |>
  summarise(total = sum(value, na.rm = TRUE), .groups = "drop") |>
  arrange(desc(total))

# total pos from the disease report
Oct_hmis_25_26 |>
  filter(data_type %in% c("pf_conf", "pv_conf", 
                          "pm_conf", 
                          "po_conf",
                          "mixed_conf"),
         month_year== "Oct-2026") |>
  summarise(value = sum(value, na.rm = T)) #353,565


# pf proportion
Oct_hmis_25_26 |>
  filter(data_type %in% c("pf_conf", "pm_conf", "po_conf"),
         month_year== "Oct-2026") |>
  summarise(value = sum(value, na.rm = T)) #226,421 = 64%


# pv proportion
Oct_hmis_25_26 |>
  filter(data_type %in% c("pv_conf"),
         month_year== "Oct-2026") |>
  summarise(value = sum(value, na.rm = T)) #107,622 = 30%


# presumed
Oct_hmis_25_26 |>
  filter(data_type == "clinical",
         greg_year == 2026) |>
  group_by(month_year)|>
  summarise(total = sum(value, na.rm = TRUE), 
            .groups = "drop") # 8,394 (2.3%)


# death in patient
Oct_hmis_25_26 |>
  filter(greg_year == 2026,
         outcome == "Mortality",
         department == "IPD",
         !data_type %in% c("clinical", "actual_reports", "actual_reports_ontime",
                           "expected_reports"))|>
  group_by(region)|>
  summarise(total_death = sum(value, na.rm = T))|>
  arrange(desc(total_death)) # 10


Oct_hmis_25_26 |>
  filter(data_type == "positives",
         month_year== "Oct- 2026") |>
  
  summarise(value = sum(value, na.rm = T)) #411,198


Oct_hmis_25_26 |>
  filter(data_type == "clinical",
         month_year== "Oct-2026") |> 
  
  summarise(value = sum(value, na.rm = T)) #8,394

