# this script is prepared to preprocess the hmis data before taking it to the 
# app

# Note: while replacing the previous month name with the current one using
# a replace tool, remember that the month in the factoring levels will also change.
# so don't forget to keep that one as it is

rm(list = ls())

#libraries
library(tidyverse)
library(lubridate)
library(sf)

# reading the cleaned hmis data
hmis <- readRDS("monthly update/data/processed/Oct 2026 dashboard/upto_Oct_2026_hmis_for_app.rds")

hmis|>
  filter(greg_year == 2023)|>
  distinct(greg_month)

# after making the dashboard to the woreda level, the app become very slow
# so I'm filtering hmis data only from 2016 EFY (to improve efficiency)
hmis <- hmis |>
  filter(greg_date > as.Date("2023-06-01"))

# aggregate to save space for the shiny app
hmis_dashboard <- hmis|>
  group_by(
    id_1082,
    region,
    zone,
    woreda,
    facility_type,
    greg_date,
    department,
    outcome,
    data_type
  ) |>
  summarise(
    value = sum(value, na.rm = TRUE),
    .groups = "drop"
  )

# read sf
sf <- readRDS("monthly update/data/eth-admin3-v1082-clean-id.rds")|>
  sf::st_drop_geometry()


# prepare a geo look up
geo_lookup <- hmis_dashboard %>%
  distinct(
    id_1082,
    region,
    zone,
    woreda
  ) %>%
  arrange(region, zone, woreda)

# save the geo look up
saveRDS(geo_lookup, "monthly update/data/processed/Oct 2026 dashboard/geo_lookup.rds")

# create a population lookup
pop_lookup <- read_csv("monthly update/data/eth-admin3-v1082-clean-id_with_pop_2030.csv")|>
  filter(year %in% c(2020:2026))

# save population lookup
#saveRDS(pop_lookup, "monthly update/data/processed/population_lookup.rds")

# creating time lookup
time_lookup <- tibble(
  greg_date = seq(
    from = as.Date("2020-01-01"),
    to = as.Date("2030-12-01"),
    by = "month"
  )
)

# create gregorian variable
time_lookup <- time_lookup %>%
  mutate(
    greg_year = year(greg_date),
    
    greg_month = month(
      greg_date,
      label = TRUE,
      abbr = TRUE
    ),
    
    greg_year_ui = factor(
      greg_year,
      levels = 2020:2026,
      labels = 2020:2026
    ),
    
    greg_month_num = month(greg_date),
    
    month_year = format(
      greg_date,
      "%b-%Y"
    )
  )

# create EFY variable
time_lookup <- time_lookup %>%
  mutate(
    
    efy = ifelse(
      greg_month_num >= 7,
      greg_year - 7,
      greg_year - 8
    ),
    
    efy_month_num = case_when(
      greg_month_num >= 7 ~ greg_month_num - 6,
      TRUE ~ greg_month_num + 6
    )
  )


# creating EFY display label
time_lookup <- time_lookup %>%
  mutate(
    efy_time = month_year
  )

# convert to factor
time_lookup <- time_lookup %>%
  mutate(
    
    greg_month = factor(
      greg_month,
      levels = c(
        "Jan","Feb","Mar","Apr",
        "May","Jun","Jul","Aug",
        "Sep","Oct","Nov","Dec"
      )
    ),
    
    month_year = factor(
      month_year,
      levels = format(
        greg_date,
        "%b-%Y"
      )
    )
  )

# save the time lookup
saveRDS(time_lookup,"monthly update/data/processed/time_lookup.rds")


# join time lookup to hmis
hmis_dashboard <- hmis_dashboard %>%
  left_join(
    time_lookup,
    by = "greg_date"
  )

# selecting the columns i need before saving
hmis_dashboard <- hmis_dashboard |>
  select(id_1082, region, zone, woreda, greg_date, greg_year, 
         greg_month, greg_month_num, month_year,
         efy, greg_year_ui,efy_month_num, efy_time, facility_type, department, outcome,
         data_type, value)


# sanity check
hmis_dashboard |>
  filter(data_type %in% c("tested", "positives"))|>
  group_by(data_type) |>
  summarise(total = sum(value, na.rm = T)) # correct

hmis_dashboard |>
  filter(greg_year == 2026)|>
  distinct(month_year) # correct

hmis_dashboard |>
  filter(data_type %in% c("tested", "positives") & month_year =="Oct-2026")|>
  group_by(data_type) |>
  summarise(total = sum(value, na.rm = T)) # correct


unique(hmis_dashboard$efy)

hmis_dashboard|>
  filter(greg_year==2023)|>
  distinct(greg_month) #correct

# saving the clean hmis for app use
saveRDS(hmis_dashboard, "monthly update/data/processed/Oct 2026 dashboard/upto_Oct_2026_hmis_for_app.rds")

# sanity check 
hmis_dashboard |>
  filter(
    data_type == "positives",
    #efy %in% c(2018, 2019),
    month_year %in% c(
      "Jul-2025", "Aug-2025", "Oct-2025",
      "Jul-2026", "Aug-2026", "Oct-2026"
    )
  ) |>
  group_by(greg_year) |>
  summarise(
    value = sum(value, na.rm = TRUE),
    .groups = "drop"
  )
#-----------------------------------------------------------------------------

unique(hmis_dashboard$greg_year)
hmis_dashboard |>
  filter(greg_year== 2023)|>
  distinct(month_year)

# sanity check
hmis_dashboard |>
  filter(greg_year== 2026, month_year == "Oct-2026",
         data_type %in% c("tested", "positives"))|>
  group_by(data_type)|>
  summarise(total = sum(value, na.rm = T))

