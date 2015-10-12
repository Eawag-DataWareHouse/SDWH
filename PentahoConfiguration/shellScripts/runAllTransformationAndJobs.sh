#!/bin/bash

# ---------------------------------
# -- define paths

# root directory of landing zone
landingzonepath="$HOME/SDWH/Landingzone"

# root directory of raw data backup
rawdatabBackupPath="$HOME/SDWH/RawDataBackup"

# path to Pentaho configuration (DI)
pentahoconfigpath="$HOME/SDWH/PentahoConfiguration"

# name of Pentaho Di Repository
PentahoRep="PentahoFiles"

# define logfiles
logFileMetadata="$HOME/SDWH/Logs/autoRun_script_MetadataOutput.log"
logFileData="$HOME/SDWH/Logs/autoRun_script_DataOutput.log"
performanceLogFile="$HOME/SDWH/Logs/pentahoPerformance_optimized.log"

# ---------------------------------
# Run split scripts

cd $landingzonepath/DataTempMulti
# find all directories in the landingzone with multiple sources in one file
for multisource in $(find . -maxdepth 1 -mindepth 1 -type d -printf '%f\n')
do    
	DIRECTORY="$landingzonepath/DataTempMulti/$multisource"
 	# if $DIRECTORY exists
	if [ -d "$DIRECTORY" ]; then

	    cd $DIRECTORY
	    # if rawData contains files
            if [ "$(ls -A rawData/)" ]; then
 		echo "Split files in: $DIRECTORY"

		./runSplitScript.sh

		# --- move raw data

 		# create backup directory if it does not yet exists
 		mkdir -p "$rawdatabBackupPath/$multisource/rawData"

		# move files
		mv rawData/* "$rawdatabBackupPath/$multisource/rawData/" # there is the --backup options, but it does not work ?!?!?!
		echo "raw files moved to: $rawdatabBackupPath/$multisource/rawData/"
            fi

	    cd $landingzonepath/DataTempMulti
	fi
done

echo "================================="
echo "All Multisource files splitted!"


# ---------------------------------
# -- Run conversions scripts

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

	    cd $DIRECTORY
	    # if rawData contains files
            if [ "$(ls -A rawData/)" ]; then
 		echo "Convert files in: $DIRECTORY"

		./RunConversionScript.sh

		# convert 1.23e5 to 1.23E5
		FILE="$DIRECTORY/data/data_$instances.csv"
		if [ -f "$FILE" ]; then
	    	    sed -i 's/\([0-9]\)e\([-+]\)/\1E\2/g' $FILE
		fi

		# --- move raw data

 		# create backup directory if it does not yet exists
 		mkdir -p "$rawdatabBackupPath/$source/$instances/rawData"

		# move files
		mv rawData/* "$rawdatabBackupPath/$source/$instances/rawData/" # there is the --backup options, but it does not work ?!?!?!
		echo "raw files moved to: $rawdatabBackupPath/$source/$instances/rawData/"
            fi

	    cd $landingzonepath/Data
	fi
    done
done

echo "================================="
echo "All data converted!"

# ---------------------------------
# -- Run site Transformation (add site_metadata)

cd $landingzonepath/Site
for site in */
do
    siteMetaFile=$landingzonepath/Site/$site"site_metadata.xml"

    echo  "siteMetaFile: 	  $siteMetaFile" >>$logFileMetadata

    $HOME/datalab/data-integration/kitchen.sh -file=$pentahoconfigpath/jobs/updateSite.kjb \
	-level=Rawlevel -param:siteMetaFile=$siteMetaFile \
	-rep=$PentahoRep -level=Detailed >> $logFileMetadata

    echo  "siteMetaFile: 	  $siteMetaFile" >>$logFileData

done
echo "================================="
echo "All site meta data updated!"

# ---------------------------------
# -- import to data base
#
# iterate through all source types under $landingzonepath/Data
for source in $landingzonepath/Data/*/
do
    cd $source
    # iterate through all source instances under $landingzonepath/Data/$source
    for instances in */
    do

	echo "-----------"
	echo "Import data from: "$source$instances

	#--set parameter values
	parameterFile=$landingzonepath/Data/"Parameters.xml"
	sourceTypeMetaFile=$source"sourceType_metadata.xml"
	sourceMetaFile=$source$instances"source_metadata.xml"

	dataFile=${source}${instances}"data/data_"${instances::-1}".csv"
	validationFile=$source"valueDefinition.xml"
	rawDataPath=${source}${instances}"rawData"

	echo  "parameterFile:	  $parameterFile" >> $logFileMetadata
	echo  "sourceTypeMetaFile: $sourceTypeMetaFile" >> $logFileMetadata
	echo  "sourceMetaFile:     $sourceMetaFile" >> $logFileMetadata

	echo  "dataFile: 	  $dataFile" >>$logFileMetadata
	echo  "valueDefinitionFile: 	  $validationFile" >>$logFileMetadata
	echo  " " >> $logFileMetadata

	echo "$instances :" >> $performanceLogFile
	now=$(date +"%T")
	echo "updateMetadata startTime : $now" >> $performanceLogFile

	#-- update meta data
	# The following line passes the above parameters to pentaho job and executes updateMetadata job
	$HOME/datalab/data-integration/kitchen.sh -file=$pentahoconfigpath/jobs/updateMetadata.kjb \
	    -level=Rawlevel -param:parameterFile=$parameterFile \
	    -param:sourceTypeMetaFile=$sourceTypeMetaFile -param:sourceMetaFile=$sourceMetaFile -param:siteMetaFile=$siteMetaFile \
	    -param:dataFile=$dataFile -param:validationFile=$validationFile -rep=$PentahoRep -level=Detailed >> $logFileMetadata

	now=$(date +"%T")
	echo "updateMetadata endTime : $now" >> $performanceLogFile
	echo " " >> $performanceLogFile

	echo " " >> $logFileMetadata
	echo "end of inserting updateMetadata" >> $logFileMetadata
	echo " " >> $logFileMetadata


	echo "-----------"
	echo "Meta data updated!"


	echo  "parameterFile:	  $parameterFile" >> $logFileData
	echo  "sourceTypeMetaFile: $sourceTypeMetaFile" >> $logFileData
	echo  "sourceMetaFile:     $sourceMetaFile" >> $logFileData
	echo  "siteMetaFile: 	  $siteMetaFile" >>$logFileData
	echo  "dataFile: 	  $dataFile" >>$logFileData
	echo  "valueDefinitionFile: 	  $validationFile" >>$logFileData
	echo  " " >> $logFileData

	#-- the following step checks if the standardized file exists, passes the above parameters to pentaho job and executes updateData job
	#-- dont forget to move or delete the files under rawData directory otherwise the first step of this shell script
	#   re-generate the dataFile and executes this step again... even if there is no change in the raw file

	if [ -f "$dataFile" ]; then
	    now=$(date +"%T")g
	    echo "updateData startTime: $now" >> $performanceLogFile
	    $HOME/datalab/data-integration/kitchen.sh -file=$pentahoconfigpath'/jobs/UpdateData.kjb' -level=Rawlevel \
		-param:parameterFile=$parameterFile -param:sourceTypeMetaFile=$sourceTypeMetaFile \
		-param:sourceMetaFile=$sourceMetaFile -param:siteMetaFile=$siteMetaFile -param:dataFile=$dataFile \
		-param:validationFile=$validationFile -rep=$PentahoRep -level=Detailed >> $logFileData
	    now=$(date +"%T")
	    echo "updateData endTime: $now" >> $performanceLogFile
	    echo "" >> $performanceLogFile
	fi

	echo "-----------"
	echo "Signals updated!"

    done
done

echo "================================="
echo "All data imported!"
