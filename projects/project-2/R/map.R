# MFL adverts from Burning Glass by LA -----------------------------------------

# Map data for each LA using plotly

# 02/2018 - LG - Original
# 02/2018 - ZW - Altered for LAs and MFL data

library(rgdal)
library(RColorBrewer)
library(leaflet)
library(sp)
library(htmlwidgets)

# change projection 

# map function -------------------------------------------------------------
make_map <- function(data_column, label_text, legend_text, n_bins){
  # define colour palette
  pal <- colorBin("Oranges", domain = data_column, 
                       bins = n_bins)

  # define labels
  labels <- label_text %>% 
    lapply(htmltools::HTML)

  # make map
  map <- leaflet(LAD_England) %>%
    addProviderTiles(providers$CartoDB.Positron) %>% 
    # data and fills
    addPolygons(
      fillColor = ~pal(data_column), 
      weight = 1, 
      opacity = 0.7, 
      color = "black", 
      fillOpacity = 1, 
      highlight = highlightOptions(
        weight = 1, 
        color = "#666", 
        dashArray = "", 
        fillOpacity = 1, 
        bringToFront = TRUE), 
      label = labels, 
      labelOptions = labelOptions(
        style = list("font-weight" = "normal", padding = "3px 8px"), 
        textsize = "15px", 
        direction = "auto")) %>% 
    # legend
    addLegend(pal = pal, 
              values = ~data_column, 
              opacity = 0.7, 
              title = legend_text, 
              position = "topright")

  return(map)
}
