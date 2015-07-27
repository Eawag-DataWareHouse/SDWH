## =======================================================
##
## April 17, 2015 -- Andreas Scheidegger
##
## andreas.scheidegger@eawag.ch
## edited by Miroslav Vrzba
## editet by Tobias Doppler, 14.07.2015
## =======================================================

## =======================================================
## reads weather Radar images from meteoswiss of type precip.sv (georeference: TZC_georef.png)
## e.g. "meteoswiss.radar.precip.sv.201311020252.gif"
## =======================================================
##
## =======================================================
## colors are converted to rain intensities according to "8bit_Metranet_v102.txt"
## special values are:
## -10    echo suppressed
## -90    reserved
## -100   no echo / pixel not covered by any radar
## =======================================================
##
## For more information refer to:
## Q:\Abteilungsprojekte\Eng\SWWData\UrbHyd\Radar\dataset-kundeninfo-outgoing-2013
##
## =======================================================
## Output is a .csv file in the standardized file format for the DataWareHouse
## Output filename "data/data_",source.instance,".csv"
## =======================================================
## Run: Rscript Radar2standard.r radarimage.gif
## =======================================================

# clear variables / environment
# rm(list = ls())

## read file name as command line argument
args <- commandArgs(trailingOnly = TRUE)

if(is.na(args[1])) stop("Provide file name of radar image!")
image <- args[1]

## =========================================================
## INPUT NEEDED! in the following section you have to change things!
## =========================================================

## Set coordinates for the rectangle to be read
## xcoor:  x coordinate of *TOP LEFT* corner of the area to be read in CH1903 [km]  dimensions easthing = [255 965]
## ycoor:  y coordinate of *TOP LEFT* corner of the area to be read in CH1903 [km]  dimensions northing = [-160 480]
xcoor <- 700
ycoor <- 250

## n.pixel.x:   number of pixels in x direction (full picture: 710 px in x direction)       1 px = 1 km
## n.pixel.y:   number of pixels in y direction (full picture: 640 px in y direction)
n.pixel.x <- 20
n.pixel.y <- 15

## define source instance for naming of file
source.instance <- "WeatherRadar01"

## =========================================================
## =========================================================


## load and if necessary install packages
if(!require("rgdal")) install.packages("rgdal", repos="http://cran.rstudio.com/")

## function to produce matrix from picture
gif2matrix <- function(file, xcoor, ycoor, xstep=1, ystep=1, rain.code) {

  #define origin in pixels
  xpix <- xcoor-255
  ypix <- 480-ycoor+76

  ## Read in rain intensities from GIF-file
  data.file <- rgdal::readGDAL(file,
                               offset=c(ypix, xpix),
                               region.dim=c(ystep, xstep),
                               silent=TRUE)

  data.matrix <- as.matrix(data.file)

  ## convert in [mm/h]
  for(i in 0:length(rain.code)-1) {
    data.matrix[data.matrix == i] <- rain.code[i+1]
  }

  data.matrix
}

## code to convert rgb value into rain rate [mm/h]
rain.code <- c(-10, 1e-04, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45,
               0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1, 1.1, 1.25,
               1.35, 1.45, 1.55, 1.65, 1.75, 1.85, 1.95, 2, 3.05, 4.05, 5.05, 6.05,
               7.05, 8.05, 9.05, 10.05, 11.05, 12.05, 13.05, 14.05, 15.05, 16.05,
               17.05, 18.05, 19.05, 20.05, 21.05, 22.05, 23.05, 24.05, 25.05, 26.05,
               27.05, 28.05, 29.05, 30.05, 31.05, 32.05, 33.05, 34.05, 35.05, 36.05,
               37.05, 38.05, 39.05, 40.05, 41.05, 42.05, 43.05, 44.05, 45.05, 46.05,
               47.05, 48.05, 49.05, 50.05, 51.05, 52.05, 53.05, 54.05, 55.05, 56.05,
               57.05, 58.05, 59.05, 60.05, 61.05, 62.05, 63.05, 64.05, 65.05, 66.05,
               67.05, 68.05, 69.05, 70.05, 71.05, 72.05, 73.05, 74.05, 75.05, 76.05,
               77.05, 78.05, 79.05, 80.05, 81.05, 82.05, 83.05, 84.05, 85.05, 86.05,
               87.05, 88.05, 89.05, 90.05, 91.05, 92.05, 93.05, 94.05, 95.05, 96.05,
               97.05, 98.05, 99.05, 100.05, 101.05, 102.05, 103.05, 104.05, 105.05,
               106.05, 107.05, 108.05, 109.05, 110.05, 111.05, 112.05, 113.05,
               114.05, 115.05, 116.05, 117.05, 118.05, 119.05, 120.05, 121.05,
               122.05, 123.05, 124.05, 125.05, 126.05, 127.05, 128.05, 129.05,
               130.05, 131.05, 132.05, 133.05, 134.05, 135.05, 136.05, 137.05,
               138.05, 139.05, 141.05, 142.05, 143.05, 144.05, 145.05, 146.05,
               147.05, 148.05, 149.05, 150.05, 151.05, 152.05, 153.05, 154.05,
               155.05, 156.05, 157.05, 158.05, 159.05, 160.05, 161.05, 162.05,
               163.05, 164.05, 165.05, 166.05, 167.05, 168.05, 169.05, 170.05,
               171.05, 172.05, 173.05, 174.05, 175.05, 176.05, 177.05, 178.05,
               179.05, 180.05, 181.05, 182.05, 183.05, 184.05, 185.05, 186.05,
               187.05, 188.05, 189.05, 190.05, 191.05, 192.05, 193.05, 194.05,
               195.05, 196.05, 197.05, 198.05, 199.05, 200.05, 201.05, 202.05,
               203.05, 204.05, 205.05, 206.05, 207.05, 208.05, 209.05, 210.05,
               220.05, 230.05, 240.05, 250.05, 260.05, 270.05, 280.05, 290.05,
               300.05, 310.05, 320.05, 330.05, 340.05, -90, -90, -90,
               -90, 9999.9)

## get time stamp from file name
split<-gregexpr(pattern ='/',image)[[1]]
splitter<-split[length(split)]
time.str <- substr(image, splitter+28, splitter+28+11)
time <- strptime(time.str, "%Y%m%d%H%M")

time.for <- format(time, "%Y-%m-%d %H:%M:%S")
if(substr(time.str, 12, 13) %in% c("2", "7")) substr(time.for, 18, 18) <- "3"

## read image in matrix
radar.mat <- gif2matrix(image,
                        xcoor, ycoor,
                        n.pixel.x, n.pixel.y,
                        rain.code)

## produce standardized file format for DataWareHouse
df.out <- cbind(expand.grid(X=xcoor:(xcoor+n.pixel.x-1),
                            Y=(ycoor-1):(ycoor-n.pixel.y)),
                            Value=c(radar.mat),
                            Parameter="rain intensity",
                            Group_ID="",
                            Z="",
                            Timestamp=time.for)
df.out <- df.out[,c(7,4,3,5,1,2,6)]

## remove values outside of radar coverage
Sdf.out <- df.out[df.out$Value < 9999,]

## write output file
file.name <- paste0("data/data_",source.instance,".csv")
write.table(df.out, file=file.name, row.names=FALSE, append=T, col.names=!file.exists(file.name), quote=FALSE, sep=";")

print(paste0("File ", file.name, " written/updated."))
