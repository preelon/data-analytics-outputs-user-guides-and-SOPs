rm(list = ls())

# This code is prepared to analyze and visualize monthly HMIS for the juneil
# the NMEP monthly bulletin

# Author: Enku Demssie
# Date : june 28 2026

#library
library(tidyverse)
library(scales)

# read the hmis data
june_hmis_25_26 <- readRDS("Archieved/data/processed/june_2026_bulletin/june_2025_2026_hmis.rds")

# checking if I correctly filtered out june data
unique(june_hmis_25_26$greg_date) #correct

# 1. Test, positive & TPR in june 2025
june_hmis_25_26 |>
  filter(data_type %in% c("positives", "tested")) |>
  group_by(data_type, greg_year) |>
  summarise(value = sum(value, na.rm = T), .groups = "drop") |>
  pivot_wider(names_from = data_type, values_from = value) |>
  mutate(tpr= (positives/tested) *100)

# 2. Total deths in the month-year
june_hmis_25_26 |>
  filter(greg_year == 2026, department == "IPD",
         outcome == "Mortality",
         data_type != "clinical") |>
  summarise(total_death = sum(value, na.rm = T)) 


# 2. deths by region
june_hmis_25_26 |>
  filter(greg_year == 2026, department == "IPD",
         outcome == "Mortality",
         data_type != "clinical") |>
  group_by(region)|>
  summarise(total_death = sum(value, na.rm = T)) |>
  arrange(desc(total_death))

# 3. ploting test, pos and tpr with labels
# 3.1. preparing a sub data
june_hmis_25_26_plot <- june_hmis_25_26 |>
  filter(data_type %in% c("tested", "positives")) |>
  group_by(month_year, data_type) |>
  summarise(total = sum(value, na.rm = TRUE), .groups = "drop") |>
  pivot_wider(names_from = data_type, values_from = total, values_fill = 0) |>
  mutate(tpr = (positives / tested) * 100)

# 3.2. changing sub data to long form
df_long <- june_hmis_25_26_plot |>
  pivot_longer(cols = c(positives, tested),
               names_to = "data_type", values_to = "count") |>
  #to make the test bar appear on the left and positive on the left
  # the below line to be modified every month to accomodate the respective month_year
  mutate(month_year = factor(month_year, levels = c("Jun-2025", "Jun-2026")),  # preserve x order
         data_type = factor(data_type, levels = c("tested", "positives"))) # tested RIGHT, positives LEFT)


# 3.3. store maximum tested for rescaling
max_tested <- max(june_hmis_25_26_plot$tested, na.rm = TRUE)

# 3.4. test, pos, tpr plot
df_long |>
  ggplot(aes(x=month_year, y=count, fill = data_type))+
  geom_bar(stat = "identity", position = position_dodge(width = 0.7)) +  # clustered bars
  geom_text(aes(label = scales::comma(count)),
            position = position_dodge(width = 0.7), vjust = -0.5, size = 4.5, fontface= "bold")+
  geom_line(data = df_long,
            aes(x = month_year, y = tpr * max_tested / 100, group = 1),
            color = "black", linewidth = 2, inherit.aes = FALSE) +
  geom_point(data = df_long,
             aes(x = month_year, y = tpr * max_tested / 100),
             color = "white", size = 3, inherit.aes = FALSE) +
  scale_fill_manual(values = c("tested" = "#007476", "positives" = "#ff7f50")) +
  scale_y_continuous(
    name = "Number of Tests / Positives",
    labels = scales::comma,
    sec.axis = sec_axis(~ . * 100 / max_tested, name = "TPR (%)")
  ) +
  labs(
    x = "",
    fill = "Data",
    #title = "Malaria Tests, Positives & TPR (june 2025 vs june 2026)"
  ) +
  theme_minimal() +
  theme(
    axis.title = element_text(face = "bold", size = 14),              # x & y axis titles
    axis.title.y.right = element_text(color = "black", face = "bold"),  # secondary y
    axis.text = element_text(face = "bold"),               # axis labels
    axis.text.x = element_text(angle = 45, hjust = 1, face = "bold", size= 15),
    legend.title = element_text(face = "bold"),
    legend.text = element_text(face = "bold", size = 13),
    plot.title = element_text(face = "bold", hjust = 0.5)
  )

ggsave("Archieved/output/june_2026_bulletin/1.test-pos-tpr.svg", 
       width= 10, height = 6) 



# 4. june 2025 confirmed cases by region col chart
june_hmis_25_26 |>
  filter(data_type == "positives") |>
  group_by(region, month_year) |>
  summarise(total = sum(value, na.rm = TRUE), .groups = "drop") |>
  ggplot(aes(x =reorder(region, total), y = total, fill = month_year)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.7)) +
  
  # Add labels
  geom_text(aes(label = scales::comma(total)),
            position = position_dodge(width = 0.7),
            hjust = -0.2, size = 3.2, fontface = "bold", color= "blue4") +
  
  scale_fill_manual(values = c("Jun-2025" = "#007476", "Jun-2026" = "#ff7f50")) +
  scale_y_continuous(
    name = "case count",
    labels = scales::comma,
    expand = expansion(mult = c(0, 0.15)) 
  ) +
  labs(
    x = "Region",
    fill = "Month_Year",
    title = "Case count in june 2026 vs 2025 by region (service data)"
  ) +
  theme_minimal() +
  theme(
    axis.title = element_text(face = "bold", size = 14),
    axis.text = element_text(face = "bold", size = 14),
    axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"),
    legend.title = element_text(face = "bold"),
    legend.text = element_text(face = "bold", size = 13),
    plot.title = element_text(face = "bold", hjust = 0.5)
  ) +
  coord_flip()

ggsave("Archieved/output/june_2026_bulletin/2.pos-by-region.svg", 
       width= 10, height = 6, dpi = 600) 

# 4.1. total number of cases (service report) in june 2025 by region
june_hmis_25_26 |>
  filter(data_type %in% c("positives"),
         greg_year == 2026) |>
  group_by(region) |>
  summarise(total_case= sum(value, na.rm = TRUE)) |>
  arrange(desc(total_case)) 

# 4.2. Extracting sum of positive cases from the top three regions
# (service data)
june_hmis_25_26 |>
  filter(data_type == "positives", 
         region %in% c("Oromia", "Amhara", "South"),
         greg_year == 2026) |>
  summarise(total= sum(value)) #276884, #national pos= 431,507


# 5. Service vs disease data comparison
june_hmis_25_26 |>
  group_by(month_year, data_type) |>
  summarise(total = sum(value, na.rm = TRUE), .groups = "drop") |>
  pivot_wider(names_from = data_type, values_from = total) |>
  mutate(disease_data = rowSums(across(c(pf_conf, pv_conf, mixed_conf)), na.rm = TRUE)) |>
  rename(service_data = positives) |>
  pivot_longer(cols = c(disease_data, service_data), names_to = "data_source", values_to = "total") |>
  ggplot(aes(x=month_year, y= total, fill = data_source)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8))+
  # Add labels
  geom_text(aes(label = scales::comma(total)),
            position = position_dodge(width = 0.7),
            hjust = 0.4, vjust= 3, size = 5, fontface = "bold", color= "white") +
  
  scale_fill_manual(values = c("service_data" = "#007476", "disease_data" = "#ff7f50")) +
  scale_y_continuous(
    name = "case count",
    labels = scales::comma,
    expand = expansion(mult = c(0, 0.15)) 
  ) +
  labs(
    x = "month_year",
    fill = "Data Source",
    title = "Service vs Disease data (june 2025 vs june 2026)") +
  theme_minimal() +
  theme(
    axis.title = element_text(face = "bold", size = 14),
    axis.text = element_text(face = "bold", size = 14),
    axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"),
    legend.title = element_text(face = "bold"),
    legend.text = element_text(face = "bold"),
    plot.title = element_text(face = "bold", hjust = 0.5)
  ) 

ggsave("Archieved/output/june_2026_bulletin/3.service vs disease data.svg", 
       width= 10, height = 6) 



# 6. malaria by species
june_hmis_25_26 |>
  filter(data_type %in% c("pf_conf", "pv_conf", "mixed_conf")) |>
  group_by(data_type, month_year) |>
  summarise(total= sum(value, na.rm = TRUE),.groups = "drop") |>
  pivot_wider(names_from = data_type, values_from = total) |>
  mutate(cum_total = mixed_conf + pf_conf + pv_conf) |>
  mutate(pf = (pf_conf/cum_total) * 100,
         pv = (pv_conf/cum_total) * 100,
         mixed = (mixed_conf/cum_total) * 100) |>
  pivot_longer(cols = c("pf", "pv", "mixed"), names_to = "malaria_type",
               values_to = "proportion") |>
  mutate(malaria_type = factor(malaria_type, 
                               levels = c("pf", "pv", "mixed")))|>
  ggplot(aes(x=month_year, y=proportion, fill = malaria_type)) +
  geom_bar(stat= "identity")+
  geom_text(aes(label = paste0(round(proportion,1), " %")),
            position = position_stack(vjust = 0.5),
            color = "white", size = 5, fontface="bold") +
  scale_fill_manual(values= c("pf" = "#007476", "pv" = "#ff7f50", "mixed" = "#ffd4aa")) +
  labs(
    x = "",
    y= "proportion (%)",
    fill = "Species_proportion",
    title = "Confirmed malaria cases by species proportion"
  ) +
  theme_minimal() +
  theme(
    axis.title = element_text(face = "bold", size = 14),
    axis.text = element_text(face = "bold", size = 14),
    # axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"),
    legend.title = element_text(face = "bold"),
    legend.text = element_text(face = "bold", size = 13),
    plot.title = element_text(face = "bold", hjust = 0.5)
  ) 

ggsave("Archieved/output/june_2026_bulletin/4.Mar-species-proportion.svg", 
       width= 10, height = 6) 
