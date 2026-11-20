# this script is prepared to bind the previously cleaned 7 years hmis to 
# the may 2026 hmis

# NOTE: start by changing the 1st file name to the last month's name

rm(list = ls())

#libraries
library(tidyverse)
library(lubridate)
library(gt)

# reading the required dataset
# 1. readinng the 7 year cleaned hmis
hmis_large <- readRDS("monthly update/data/processed/Aug 2026 dashboard/upto_aug_2026_hmis_for_app.rds")

hmis_large |>
  filter(efy==2018)|>
  distinct(month_year) # correct

hmis_large |>
  filter(greg_year == 2023)|>
  distinct(month_year) # correct(jul to dec)

# 2. read the cleaned Sep 2026 hmis
hmis_Sep_2026 <- readRDS("monthly update/data/processed/Sep 2026 dashboard/Sep_2026_hmis_woreda_cleaning_completed.rds")

unique(hmis_Sep_2026$month_year) #"Sep-2026"

# binding the two dats
integrated_hmis <- bind_rows(hmis_large, hmis_Sep_2026)

integrated_hmis |>
  filter(greg_year == 2026)|>
  distinct(month_year)


# saving the binded dataset for the next step
saveRDS(integrated_hmis, "monthly update/data/processed/Sep 2026 dashboard/upto_Sep_2026_hmis_for_app.rds")

# ---------------------------------------------------------------

