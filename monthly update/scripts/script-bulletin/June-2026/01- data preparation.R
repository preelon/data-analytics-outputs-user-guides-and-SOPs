rm(list = ls())

# This code is prepared to filter out the month of intersest for the bulletin
#from the large HMIS dataset the NMEP monthly bulletin

# Author: Enku Demssie
# Date : june 28 2026

#library
library(tidyverse)


# 1. reading the large HMIS
large_hmis <- readRDS("Archieved/data/processed/june 2026/upto_june_2026_hmis_for_app.rds")

# filter the data required for the monthly bulletin
hmis_june_bulletin <- large_hmis |>
  filter(month_year %in% c("Jun-2026", "Jun-2025"))

# save the above data so that i can delete the original large data and save space
saveRDS(hmis_june_bulletin, "Archieved/data/processed/june_2026_bulletin/june_2025_2026_hmis.rds")
#--------------------------------END-----------------------------------------  