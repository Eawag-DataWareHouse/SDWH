## =======================================================
##
## July 07, 2015 -- Tobias Doppler
##
## andreas.scheidegger@eawag.ch
## =======================================================

## =================================
## Run: Rscript Pluvio2Standard.r rawData/rain_full_adl01.txt
##
## writes files data_%SourceInstanceName%.csv
## =================================

## read file name as command line argument
args <- commandArgs(trailingOnly = TRUE)

if(is.na(args[1])) stop("Provide file name of raw file!")
file.raw <- args[1]

## for naming of output file
source.instance <- "Pluvio01_Adliswil"

## define coordinate
xcoor <- 682085
ycoor <- 241498
zcoor <- 495

## --- read files
data.raw <- read.table(file.raw, sep="\t", header=T)

## remove NA values
data.raw<-na.omit(data.raw)

## reformat data
data.form <- data.raw
data.form$Timestamp <- data.raw$date.time
data.form$Parameter <- "rain intensity pluvio"
data.form$Value <- data.raw$rain
data.form$Group_ID <- ""
data.form$X <- xcoor
data.form$Y <- ycoor
data.form$Z <- zcoor
data.form <- data.form[,-c(1,2)]

## write data

file.name <- paste0("./data/data_", source.instance, ".csv")

suppressWarnings(
write.table(data.form, file=file.name, append=TRUE,
            row.names=FALSE, col.names=!file.exists(file.name),
            quote=FALSE, sep=";")
)
print(paste0("File ", file.name, " written or updated."))


