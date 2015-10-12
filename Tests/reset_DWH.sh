#
# !!! Reset SDWH: !!!
#  - empty all log files
#  - delete all converted data files
#  - delets all data bases
#  - creates a new empty data base
# --------------------------------------------


# root directory of landing zone
landingzonepath="$HOME/SDWH/Landingzone"

# directory of log files
logpath="$HOME/SDWH/Logs"


# clear log files
> $logpath/autoRun_script_DataOutput.log
> $logpath/pentahoPerformance_optimized.log
> $logpath/autoRun_script_MetadataOutput.log
echo "cleared log files"

# delete data bases
mysql -u root --password=DBroot --execute="drop database temp;"
mysql -u root --password=DBroot --execute="drop database WaterResearch;"
echo "Databases deleted"


# delete all converted data files
cd $landingzonepath/Data

# find all directories in the landingzone
for source in $(find . -maxdepth 1 -mindepth 1 -type d -printf '%f\n')
do
    # find all instances
    for instances in $(find . -maxdepth 2 -mindepth 2 -type d -printf '%f\n')
	do
	DIRECTORY="$landingzonepath/Data/$source/$instances"

	# if $DIRECTORY exists
	if [ -d "$DIRECTORY" ]; then
	    rm $DIRECTORY/data/*.csv
	    cd $landingzonepath/Data
	fi
    done
done

echo "Converted data files deleted"

# produce new empty databases
mysql -u root --password=DBroot < ~/SDWH/PentahoConfiguration/SQLqueries/tempCreateStatement.sql
mysql -u root --password=DBroot < ~/SDWH/PentahoConfiguration/SQLqueries/CreateStatement.sql

echo "New empty databases created"
