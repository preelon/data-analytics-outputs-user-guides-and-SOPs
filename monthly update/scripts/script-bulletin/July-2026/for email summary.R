rm(list = ls())

# libraries
library(tidyverse)

# read the hmis data
july_hmis_25_26 <- readRDS("Archieved/data/processed/july_2026_bulletin/july_2025_2026_hmis.rds")

# total tests
july_hmis_25_26 |>
  filter(data_type == "tested",
         greg_year== 2026) |>
  summarise(sum(value, na.rm = T)) #1993845

# total positives
july_hmis_25_26 |>
  filter(data_type == "positives",
         greg_year== 2026) |>
  summarise(sum(value, na.rm = T)) #567381

# top contribution regions
july_hmis_25_26 |>
  filter(data_type == "positives",
         greg_year == 2026) |>
  group_by(region) |>
  summarise(total = sum(value, na.rm = TRUE), .groups = "drop") |>
  arrange(desc(total))

# total pos from the disease report
july_hmis_25_26 |>
  filter(data_type %in% c("pf_conf", "pv_conf", 
                          "pm_conf", 
                          "po_conf",
                          "mixed_conf"),
         month_year== "Jul-2026") |>
  summarise(value = sum(value, na.rm = T)) #415690


# pf proportion
july_hmis_25_26 |>
  filter(data_type %in% c("pf_conf", "pm_conf", "po_conf"),
         month_year== "Jul-2026") |>
  summarise(value = sum(value, na.rm = T)) #280204 = 67.4%


# pv proportion
july_hmis_25_26 |>
  filter(data_type %in% c("pv_conf"),
         month_year== "Jul-2026") |>
  summarise(value = sum(value, na.rm = T)) #114178 = 28%


# presumed
july_hmis_25_26 |>
  filter(data_type == "clinical",
         greg_year == 2026) |>
  summarise(total = sum(value, na.rm = TRUE), .groups = "drop") #8386


# death in patient
july_hmis_25_26 |>
  filter(greg_year == 2026,
         outcome == "Mortality",
         department == "IPD")|>
  group_by(region)|>
  summarise(total_death = sum(value, na.rm = T))|>
  arrange(desc(total_death))


july_hmis_25_26 |>
  filter(data_type == "positives",
         month_year== "Jul-2026") |>
  
  summarise(value = sum(value, na.rm = T)) #567381


july_hmis_25_26 |>
  filter(data_type == "clinical",
         month_year== "Jul-2026") |>
  
  summarise(value = sum(value, na.rm = T)) #8386

