rm(list = ls())

# This code is prepared to filter out the month of intersest for the bulletin
#from the large HMIS dataset the NMEP monthly bulletin

# Author: Enku Demssie
# Date : Sep 15 2026

#library
library(tidyverse)


# 1. reading the large HMIS
large_hmis <- readRDS("monthly update/data/processed/Sep 2026 dashboard/upto_Sep_2026_hmis_for_app.rds")

# filter the data required for the monthly bulletin
hmis_Sep_bulletin <- large_hmis |>
  filter(month_year %in% c("Sep-2026", "Sep-2025"))

# save the above data so that i can delete the original large data and save space
saveRDS(hmis_Sep_bulletin, "monthly update/data/processed/Sep_2026_bulletin/Sep_2025_2026_hmis.rds")
#--------------------------------END-----------------------------------------  