# install and load packages 
library(leaflet)
library(raster)
install.packages('leaflet')

getwd()
setwd("M:/CrisAlex_FinalProject")

population <- read.csv("pop_manaus.csv")

dh <- data.frame(cbind(x=population$Longitude,y=population$Latitude,mc=population$DiffPop_2000_2010))

leaflet(dh)%>%addProviderTiles("Esri.WorldStreetMap")%>%setView(-60.020993, -3.025258,zoom=10)

cPal <- colorNumeric(palette = c("blue","yellow","red"),domain = population$DiffPop_2000_2010)
leaflet(population) %>% addProviderTiles("Esri.WorldTopoMap") %>%
  addCircleMarkers(fillColor = ~cPal(population$DiffPop_2000_2010),stroke = FALSE,fillOpacity = 0.6, popup=~DiffPop_2000_2010)%>%
  addLegend("bottomright", pal = cPal, values = ~DiffPop_2000_2010,title = "population difference",labFormat = labelFormat(suffix = "p."),opacity = 1)

#Plot Raster Images(NDVI)
r <- raster("ndvi_land01.grd")
pal <- colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"), values(r),
                    na.color = "transparent")

leaflet() %>% addTiles() %>%
  addRasterImage(r, colors = pal, opacity = 0.8) %>%
  addLegend(pal = pal, values = values(r),
            title = "NDVI")
