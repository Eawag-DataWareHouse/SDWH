##
## Run basic functionality tests of the data ware house
##
## These tests are based on the example found in the github repository
##
## !!! running these tests all data will be DELETED !!!
## -------------------------------------------------------


## -----------
## 1) reset data base

system("$HOME/SDWH/Tests/reset_DWH.sh")


## -----------
## 2) run Pentaho to import data

## run it twice to check for dublicates
system.time({system("$HOME/SDWH/PentahoConfiguration/shellScripts/runAllTransformationAndJobs.sh")})

system.time({system("$HOME/SDWH/PentahoConfiguration/shellScripts/runAllTransformationAndJobs.sh")})


## -----------
## 3) run tests


library(RMySQL)

## connect to DB. Change PW if necessary
DBcon <- dbConnect(MySQL(),
                   user='root',
                   password='DBroot',
                   dbname='WaterResearch',
                   host='localhost')

## list alll tables
tabs <- dbListTables(DBcon)

stopifnot( length(tabs) == 15 )


## --- test queries

## 1)  Give data from 'PluvioNr01' between time t1 and t2

qq <- "SELECT *
FROM WaterResearch.factTable as s,
     WaterResearch.DateTime as dt,
     WaterResearch.signalHasDateTime as sdt,
     WaterResearch.Source as src
WHERE s.signal_ID=sdt.signal_ID and
     dt.DateTime_ID=sdt.DateTime_ID and
     s.Source_ID=src.Source_ID and
     src.source_ID='PluvioNr01' and
     dt.Date BETWEEN '2013-03-22 14:00:30' AND '2013-03-22 14:10:30'"

res <- dbGetQuery(DBcon, qq)

stopifnot( ncol(res) == 10 )
stopifnot( sum(res) == 0 )
