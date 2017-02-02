####Script Project
##Team CrisAlex, Cristina González and Wan Quanxing
##02/02/2017
#Changes of vegetation within approximately 10 years in Brazil

##This is the script to produce the NDVI difference between 2001 and 2010

#libraries and functions needed. Check that all the libraries and functions are loaded
#before starting with the script
library(sp)
library(rgdal)
library(raster)
library(tiff)
library(lattice)
library(graphics)
library(leaflet)
source("R/functions.R")
source("R/pre_process.R")
source("R/plot_results.R")
install.packages('leaflet')

rm(list.files())

#Directories necessaries for the script
inDir <- "data"
midDir <- "midsteps"
landsatDir01 <- file.path("data", "landsat2001")
landsatDir10 <- file.path("data", "landsat2010")
outDir <- "output"

#Create folders needed for the process
pre_processing <- create_folders()


#Download image of landsat in 2001 and decompress it (take a few minutes to do the command)
if (!file.exists(file.path(inDir, 'landsat2001.tar.gz'))) {
  download.file('https://www.dropbox.com/s/csiazbfo9569q4z/LT05_L1TP_231062_20010803_20161210_01_T1.tar.gz?dl=1',
                destfile = file.path(inDir, 'landsat2001.tar.gz'), method='auto', mode = "wb")
    # Unpack the data
  untar(file.path(inDir, 'landsat2001.tar.gz'), exdir = landsatDir01)
}


#Download image of landsat in 2010 and decompress it
if (!file.exists(file.path(inDir, 'landsat2010.tar.gz'))) {
  download.file('https://www.dropbox.com/s/z3vc5rybctgjk3o/LT05_L1TP_231062_20100727_20161014_01_T1.tar.gz?dl=1',
                destfile = file.path(inDir, 'landsat2010.tar.gz'), method='auto', mode = "wb")
    # Unpack the data
  untar(file.path(inDir, 'landsat2010.tar.gz'), exdir = landsatDir10)
}


#Input the file of landsat in 2001 and 2010
ln01 <- input_landsat01()
ln10 <- input_landsat10()

#Remove zeros values in the landsat images
ln10[ln10 <= 0 ] <- NA
ln01[ln01 <= 0 ] <- NA

#strick the rasters
ln01_trim <- trim(ln01, values = NA)
ln10_trim <- trim(ln10, values = NA)

#Change the extension and have the same shape the landsat images
ln01_ext <- crop(ln01_trim,ln10_trim, filename = "midsteps/landsat01_ext.grd", datatype = "INT2U", overwrite = TRUE)
ln10_ext <- crop(ln10_trim,ln01_trim, filename = "midsteps/landsat10_ext.grd", datatype = "INT2U", overwrite = TRUE)


#Create a variable with the cloud layer and other with the rest
cloud_ln01 <- ln01_ext[[3]]
ln01_drop <- dropLayer(ln01_ext, 3)
cloud_ln10 <- ln10_ext[[3]]
ln10_drop <- dropLayer(ln10_ext, 3)

#apply the cloud function to remove the clouds
ln01_CloudFree <- overlay(x = ln01_drop, y = cloud_ln01, fun = cloud_01, filename= "midsteps/ln01_CloudFree.grd", overwrite= TRUE)
ln10_CloudFree <- overlay(x = ln10_drop, y = cloud_ln10, fun = cloud_10, filename= "midsteps/ln10_CloudFree.grd", overwrite= TRUE)


#Calculate NDVI for both rasters
ndvi_land01 <- ndvical(ln01_CloudFree[[1]], ln01_CloudFree[[2]])
ndvi_land10 <- ndvical(ln10_CloudFree[[1]], ln10_CloudFree[[2]])

#Save the rasters of ndvi in the output folder
writeRaster(x=ndvi_land01, filename='output/ndvi_land01.grd', datatype="FLT8S")
writeRaster(x=ndvi_land01, filename='output/ndvi_land10.grd', datatype="FLT8S")

#Produce the plot of ndvis
plot_ndvi01 <- ndvi_2001()
plot_ndvi10 <- ndvi_2010()

##Visualization of the results
plot_ndvi01
plot_ndvi10


##Generate the final result
#Differences in the NDVI between 1990 and 2014, we substract landsat5 of landsat8
NDVI_diff <- ndvi_land10 - ndvi_land01
writeRaster(x=NDVI_diff, filename='midsteps/difference_ndvi.grd', datatype="FLT8S")

#check the changes, negative values determine lost of vegetation and positive values gain of vegetation
hist(NDVI_diff, main= "Histogram difference NDVI")

#####Plot the difference between years in ndvi####
plot_difference <- ndvi_dif()
plot_difference

#Save the NDVI difference in png format for plotting with the population
trellis.device(device="png", filename="output/plot_difference2.png")


#####Population Part#####
#commands to produce the interactive map

# Read the raster image of NDVI difference and add to leaflet
r <- raster("midsteps/difference_ndvi.grd")
s <- raster(nrow=1500, ncol=1500)
s@extent=r@extent
proj4string(s)=proj4string(r)
s <- projectRaster(from = r, to = s, method='bilinear')

# Read the population data and plot to leaflet
population <- read.csv("pop_manaus.csv")
dh <- data.frame(cbind(x=population$Longitude,y=population$Latitude,mc=population$DiffPop_2000_2010))
pal <- colorNumeric(c("#030303", "#FFFFFF", "#00CD00"), values(r),
                         na.color = "transparent")

cPal <- colorNumeric(palette = c("#FFFF00","#FF6103","#EE0000"),domain = population$DiffPop_2000_2010)
leaflet(population) %>% addProviderTiles("OpenStreetMap") %>%
  addCircleMarkers(fillColor = ~cPal(population$DiffPop_2000_2010),stroke = FALSE, fillOpacity = 0.9, popup=~DiffPop_2000_2010)%>%
  addRasterImage(s, colors = pal, opacity = 0.6)%>%
  addLegend("bottomright", pal = cPal, values = ~DiffPop_2000_2010,title = "Population difference(2000/2010)",labFormat = labelFormat(suffix = "p."),opacity = 1)%>%
  addLegend("bottomleft",pal = pal, values = values(s),
            title = "NDVI difference(2000/2010)")







