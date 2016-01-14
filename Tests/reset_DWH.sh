#
# !!! Reset SDWH: !!!
#  - empty all log files
#  - delete all converted data files
#  - delets all data bases
#  - creates a new empty data base
# --------------------------------------------

# SDWh directory
sdwhpath="$HOME/SDWH"

# root directory of landing zone
landingzonename="Landingzone"

# directory of log files
logpath="$sdwhpath/Logs"


# clear log files
> $logpath/autoRun_script_DataOutput.log
> $logpath/pentahoPerformance_optimized.log
> $logpath/autoRun_script_MetadataOutput.log
echo "cleared log files"

# delete data bases
mysql -u root --password=dwh --execute="drop database temp;"
mysql -u root --password=dwh --execute="drop database WaterResearch;"
echo "Databases deleted"


# delete old landing zone
rm -rf "$sdwhpath/$landingzonename"

cd $sdwhpath
pwd
git clone https://github.com/Eawag-DataWareHouse/SDWH-Landingzone.git

mv SDWH-Landingzone $landingzonename
echo "Cloned new example Landingzone"


# produce new empty databases
mysql -u root --password=dwh < ~/SDWH/PentahoConfiguration/SQLqueries/tempCreateStatement.sql
mysql -u root --password=dwh < ~/SDWH/PentahoConfiguration/SQLqueries/CreateStatement.sql

echo "New empty databases created"
