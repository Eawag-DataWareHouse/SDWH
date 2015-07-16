## =======================================================
##
## May 12, 2015 -- Andreas Scheidegger
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
device.instance <- "scan02"

## define coordinate
xcoor <- 580100
ycoor <- 255317
zcoor <- 455.3



## --- read files
data.raw <- read.table(file.raw, dec=",", sep="\t", header=T, skip=1, nrows=1000)



## !!!                                                        !!!
## !!!   for test purposes only the first 1000 lines are read !!!
## !!!                                                        !!!

print("for test purposes only the first 1000 lines are read!!!")

colnames(data.raw) <- gsub("X", "", colnames(data.raw))
colnames(data.raw)[-(1:2)] <- paste0("Absorbance ", colnames(data.raw)[-(1:2)], "_nm")

## format time
time <- strptime(data.raw$Date.Time, "%Y.%m.%d %H:%M:%S")
data.raw$Date.Time <- format(time, "%Y-%m-%d %H:%M:%S")

## remove status column
data.raw <- data.raw[,-2]

## reformat data
data.form <- melt(data.raw, id.vars = c("Date.Time"))
colnames(data.form) <- c("Timestamp", "Parameter", "Value")
data.form$Group_ID <- ""
data.form$X <- xcoor
data.form$Y <- ycoor
data.form$Z <- zcoor

## replace NA with "-1"
data.form$Value[is.na(data.form$Value)] <- -1

## replace null with "-2"
data.form$Value[is.null(data.form$Value)] <- -2


## write data

file.name <- paste0("./data/data_", device.instance, ".csv")

suppressWarnings(
  write.table(data.form, file=file.name, append=TRUE,
              row.names=FALSE, col.names=!file.exists(file.name),
              quote=FALSE, sep=";")
)

print(paste0("File ", file.name, " written or updated."))
