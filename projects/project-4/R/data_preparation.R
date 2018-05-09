library(readr)
library(rgdal)
library(ggplot2)
library(dplyr)
library(plotly)

# Lookup

geography_lookup <- read_csv("Data/geography_lookup.csv")

registered_animals <- read_csv("Data/registered_animals.csv") %>%
  na.omit() %>%
  mutate(AnimalType = ifelse(AnimalType == 'D', 'Dog', AnimalType)) %>%
  filter(Age <= 20)

# Shape file

states <- readOGR("Data/SSC_2016_QSLD")

jacks <- registered_animals %>%
  filter(SpecificBreed %in% c('JACKRUSSL', 'JACKRUSSLX'))

         