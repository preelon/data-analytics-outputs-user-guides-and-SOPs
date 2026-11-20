rm(list = ls())

# This code is prepared to filter out the month of intersest for the bulletin
#from the large HMIS dataset the NMEP monthly bulletin

# Author: Enku Demssie
# Date : aug 30 2026

#library
library(tidyverse)


# 1. reading the large HMIS
large_hmis <- readRDS("Archieved/data/processed/aug 2026/upto_aug_2026_hmis_for_app.rds")

# filter the data required for the monthly bulletin
hmis_aug_bulletin <- large_hmis |>
  filter(month_year %in% c("Aug-2026", "Aug-2025"))

# save the above data so that i can delete the original large data and save space
saveRDS(hmis_aug_bulletin, "Archieved/data/processed/aug_2026_bulletin/aug_2025_2026_hmis.rds")
#--------------------------------END-----------------------------------------  