## =======================================================
## Project:
##
## Description:
##
## File: read_images.r
## Path: c:/Users/scheidan/Dropbox/Eawag/Rainfall assimilation/Adliswil/data raw/Radar/
##
## January  8, 2014 -- Andreas Scheidegger
##
## andreas.scheidegger@eawag.ch
## =======================================================

source("function_read_radar.r")


## --- load and if necessary install packages
require("rgdal") || install.packages("rgdal")


## --- read source files
path <- "C:/Users/scheidan/Dropbox/Eawag/Rainfall assimilation/Adliswil/data raw/Radar/Meteoradar"
images <- list.files(path, pattern="gif", full.names=FALSE)


## read conversion table for intensities
rain.code <- read.table("C:/Users/scheidan/Dropbox/Eawag/Rainfall assimilation/Adliswil/data raw/Radar/RGB_rainrate256.txt", head=T)[,5]
rain.code[1] <- 0


## --- read files

## xcoor:  coordinate of *bottom left* point of pixel in CH1903 [km]
## ycoor:  coordinate of *bottom left* point of pixel in CH1903 [km]

for(xcoor in 680:683){
  for(ycoor in 238:242){

    print(c(xcoor, ycoor))

    data <- matrix("NA", ncol=2, nrow=length(images))
    for(i in 1:length(images)) {


      time.str <- substr(images[i], 28, 28+11)
      time <- strptime(time.str, "%Y%m%d%H%M")

      time.for <- format(time, "%d.%m.%Y %H:%M:%S")
      if(substr(time.str, 12, 13) %in% c("2", "7")) substr(time.for, 18, 18) <- "3"

      pixel <- gif2matrix(paste(path, images[i], sep="/"),
                          xcoor, ycoor,
                          1, 1,
                          rain.code)

      data[i,] <- c(time.for, pixel[1,1])
    }

    write.table(data, file=paste0("Radar_", xcoor, "_", ycoor, ".csv"),
                row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
  }
}

## -----------
## test

## gif2matrix(paste(path, images[1], sep="/"),
##            xcoor=255, ycoor=479,
##            1, 1,
##            rain.code)

## gif2matrix(paste(path, images[1], sep="/"),
##            xcoor=255, ycoor=480,
##            1, 1,
##            rain.code)

## ## image(out)
