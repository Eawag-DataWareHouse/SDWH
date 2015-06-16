## =======================================================
##
## April 16, 2015 -- Andreas Scheidegger
##
## andreas.scheidegger@eawag.ch
## =======================================================

## =================================
## Run: Rscript Scan2standard.r SCAN.fp
##
## writes files data_%DeviceInstanceName%.csv
## =================================

## --- load and if necessary install packages
if(!require("reshape2")) install.packages("reshape2", repos="http://cran.rstudio.com/")

## read file name as command line argument
args <- commandArgs(trailingOnly = TRUE)

if(is.na(args[1])) stop("Provide file name of FloDar raw file!")
file.raw <- args[1]


## for naming of output file
device.instance <- "SCAN1"

## define coordinate
xcoor <- 580000
ycoor <- 255300
zcoor <- 455.3



## --- read files
data.raw <- read.table(file.raw, dec=",", sep="\t", header=T, skip=1, nrows=1000)



## !!!                                                        !!!
## !!!   for test purposes only the first 1000 lines are read !!!
## !!!                                                        !!!

print("for test purposes only the first 1000 lines are read!!!")

colnames(data.raw) <- gsub("X", "", colnames(data.raw))
colnames(data.raw)[-(1:2)] <- paste0("reflectivity_", colnames(data.raw)[-(1:2)], "_nm")

## format time
time <- strptime(data.raw$Date.Time, "%Y.%m.%d %H:%M:%S")
data.raw$Date.Time <- format(time, "%d-%m-%Y %H:%M:%S")

## remove status column
data.raw <- data.raw[,-2]

## reformat data
data.form <- melt(data.raw, id.vars = c("Date.Time"))
colnames(data.form) <- c("Timestamp", "Parameter", "Value")
data.form$Group_ID <- NA
data.form$X <- xcoor
data.form$Y <- ycoor
data.form$Z <- zcoor


## write data

file.name <- paste0("data_", device.instance, ".csv")

write.table(data.form, file=file.name, append=TRUE,
            row.names=FALSE, col.names=TRUE, quote=FALSE, sep=";")

print(paste0("File ", file.name, " written or updated."))
