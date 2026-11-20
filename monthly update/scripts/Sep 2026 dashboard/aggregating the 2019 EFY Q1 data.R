rm(list =ls())

# library
library(tidyverse)

hmis <- readRDS("monthly update/data/processed/Sep 2026 dashboard/upto_Sep_2026_hmis_for_app.rds")


# filter q1 case data
hmis_q1_2019_cases <- hmis |>
  filter(efy == 2019, data_type %in% c("pf_conf", "pv_conf",
                                       "pm_conf", "tested", "po_conf", 
                                       "clinical", "mixed_conf", "positives")) |>
  group_by(efy, region, data_type, department, outcome) |>
  summarise(value = sum(value, na.rm = T),
            .groups = "drop") 


hmis_q1_2019_cases |>
  filter(data_type %in% c("tested", "positives")) |>
  group_by(data_type) |>
  summarise(total_test = sum(value, na.rm = T)) # correct


hmis_q1_2019_cases|>
  filter(efy == 2019, data_type %in% c("pf_conf", "pv_conf",
                                       "pm_conf",  "po_conf", 
                                       "mixed_conf"), department == "IPD",
         outcome == "Mortality") |>
  group_by(region) |>
  summarise(value = sum(value))



# save
write_csv(hmis_q1_2019_cases, "monthly update/data/ad hoc requests/q1_2019_data_aggregated.csv")


