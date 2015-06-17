## =======================================================
## Project:
##
## Description:
##
## File: function_read_radar.r
## Path: c:/Users/scheidan/Dropbox/Eawag/Rainfall assimilation/Adliswil/data raw/Radar/
##
## January  8, 2014 -- Andreas Scheidegger, based on code of Raphael and Rao
##
## andreas.scheidegger@eawag.ch
## =======================================================

## xcoor:  coordinate of *bottom left* point of pixel in CH1903 [km]
## ycoor:  coordinate of *bottom left* point of pixel in CH1903 [km]

## --- load and if necessary install packages
require("rgdal") || install.packages("rgdal")

gif2matrix <- function(file, xcoor, ycoor, xstep=1, ystep=1, rain.code) {

  ## Read in rain intensities from GIF-file
  data.file <- rgdal::readGDAL(file,
                               c(480-ycoor+76-1, xcoor-255),
                               c(xstep, ystep),
                               silent=TRUE)

  data.matrix <- as.matrix(data.file)

  ## convert in [mm/h]
  for(i in 1:length(rain.code)) {
    data.matrix[data.matrix == i] <- rain.code[i]
  }

  data.matrix
}
