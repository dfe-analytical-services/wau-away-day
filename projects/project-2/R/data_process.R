library(dplyr)
library(tidyr)

data <- read.csv("Data/LA_and_Regional_Spreadsheet_201617.csv", 
                 stringsAsFactors = FALSE) %>% 
  select("Financial.Year",
         "Region", 
         "ONS.Code", 
         "JPP.order", 
         "Local.Authority", 
         "Authority.type", 
         "Household...total.waste..tonnes.", 
         "Household...waste.sent.for.recycling.composting.reuse..tonnes.", 
         "Household...estimated.rejects..tonnes."
  )

colnames(data) <- c("Financial.Year",
                    "Region", 
                    "ONS.Code", 
                    "JPP.order", 
                    "Local.Authority", 
                    "Authority.type", 
                    "House_Total_Waste",
                    "House_Total_Recycle",
                    "House_Rejected"
                    )

data <- data %>%
  mutate(House_Total_Waste = gsub(",", "", House_Total_Waste)) %>%
  mutate(House_Total_Recycle = gsub(",", "", House_Total_Recycle)) %>%
  mutate(House_Rejected = gsub(",", "", House_Rejected)) %>%
  mutate(Perc_Recycled = 100*((as.numeric(House_Total_Recycle) - as.numeric(House_Rejected))/as.numeric(House_Total_Waste)))

data_16 <- data %>% 
  filter(Financial.Year == "2016-17") %>%
  select(ONS.Code, Local.Authority, Perc_Recycled)

data_15 <- data %>% 
  filter(Financial.Year == "2015-16") %>%
  select(ONS.Code, Local.Authority, Perc_Recycled)

data_14 <- data %>% 
  filter(Financial.Year == "2014-15") %>%
  select(ONS.Code, Local.Authority, Perc_Recycled)

data_all <- full_join(data_14, data_15, by = c("ONS.Code"))
data_all <- full_join(data_all, data_16, by = c("ONS.Code"))

data_all <- data_all %>%
  select(ONS.Code, Local.Authority.x, Perc_Recycled.x, Perc_Recycled.y, `Perc_Recycled`)

colnames(data_all) <- c("ONS_Code", "Local_Authority", "Perc_Recycled_14", "Perc_Recycled_15", "Perc_Recycled_16")

data_all <- data_all %>%
  mutate(Change = Perc_Recycled_16 - Perc_Recycled_14)

low_recycle <- data_all$Perc_Recycled_16 < 30
negative_change <- data_all$Change < 5

bad <- low_recycle*negative_change

data_all$bad <- bad

# code -------------------------------------------------------------------------
# read in shape file with LAs
LAD_England <- readOGR("Data/LAD_Shapefile/Local_Authority_Districts_December_2016_Generalised_Clipped_Boundaries_in_Great_Britain.shp")

# join with MFL adverts data
LAD_England@data <- left_join(LAD_England@data, 
                              data_16, 
                              by = c("lad16cd" = "ONS.Code"))


source("R/map.R")

projection <- CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')
LAD_England <- spTransform(LAD_England, projection)

make_map(LAD_England$Perc_Recycled,
         sprintf("<strong>%s</strong><br/> %.2f %s", LAD_England$lad16nm, 
                 LAD_England$Perc_Recycled, "% recycled"),
         "Percentage recycled 2016", 10)

