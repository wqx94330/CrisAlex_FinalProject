
###Function to create all folders and directories

create_folders <- function(){
  {
    if (!dir.exists(file.path(inDir))) {
      dir.create("data",  showWarning=FALSE)
    }}
  {
    if (!dir.exists(file.path(midDir))) {
      dir.create("midsteps", showWarning=FALSE)
    }}
  {
    if (!dir.exists(landsatDir01)) {
      dir.create("data/landsat2001", showWarning=FALSE)
    }}
  {
    if (!dir.exists(landsatDir10)) {
      dir.create("data/landsat2010", showWarning=FALSE)
    }}

  {
    if (!dir.exists(file.path(outDir))) {
      dir.create("output", showWarning=FALSE)
    }}
}


###
##Functions to input the landsat images

input_landsat01 <- function(){

  landsat01 <-list.files(path = "data/landsat2001", pattern = glob2rx("*.TIF"), full.names = TRUE)

  #stack the target 3 bands
  ln01 <- stack(x=c(landsat01[[3]], landsat01[[4]], landsat01[[8]]))

  #name the bands properly
  names(ln01) = c("band3", "band4", "clouds")

  return(ln01)
}

input_landsat10 <- function(){

  landsat10 <-list.files(path = "data/landsat2010", pattern = glob2rx("*.TIF"), full.names = TRUE)

  #stack the target 3 bands
    ln10 <- stack(x=c(landsat10[[3]], landsat10[[4]], landsat10[[8]]))

  #name the bands properly
  names(ln10) = c("band3", "band4", "clouds")

  return(ln10)
}







