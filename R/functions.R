#Script with the functions

#Function to remove the clouds in 2001

cloud_01 <- function(x, y){
  x[y >= 752] <- NA
  return(x)
}

#Function to remove the clouds in 2010
cloud_10 <- function(x, y){
  x[y >= 928 ] <- NA
  return(x)
}

#NDVI function

ndvical <- function(x,y,...) {
  ndvi <- (y-x)/(y+x)
  return(ndvi)
}




