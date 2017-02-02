####
###Functions for plotting the results

ndvi_2001 <- function(){

  veg <- c("darkgoldenrod2","darkgoldenrod3","darkgoldenrod3","peru","tan3","orange3","yellow3","greenyellow","olivedrab3","olivedrab4","green4","darkgreen")

  #visualize both nvdi
  plot_ndvi01 <- spplot(ndvi_land01, colorkey = list(labels = list(at = seq(-1, 1, by=0.2))), col.regions=colorRampPalette(veg), main= "NDVI 2001 Manaus")

  return(plot_ndvi01)
}

ndvi_2010 <- function(){

  veg <- c("darkgoldenrod2","darkgoldenrod3","darkgoldenrod3","peru","tan3","orange3","yellow3","greenyellow","olivedrab3","olivedrab4","green4","darkgreen")

  #visualize both nvdi
  plot_ndvi10 <- spplot(ndvi_land10, colorkey = list(labels = list(at = seq(-1, 1, by=0.2))), col.regions=colorRampPalette(veg), main= "NDVI 2010 Manaus")
  return(plot_ndvi10)
}


ndvi_dif <- function(){

  dif = c("firebrick4","firebrick3", "brown2","slateblue3","steelblue4","steelblue2","yellow1","greenyellow","olivedrab3","limegreen")

  #Visualize the difference between the ndvis
  plot_difference <- spplot(NDVI_diff, colorkey =list(labels = list(at = seq(-1.8, 1.6, by=0.2))),
                            col.regions=colorRampPalette(dif), main = "Differences in NDVI between 2001-2010")
  return(plot_difference)

}






