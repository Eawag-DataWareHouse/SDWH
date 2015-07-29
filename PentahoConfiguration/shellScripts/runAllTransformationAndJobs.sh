#!/bin/bash

# if you want to run this shell script only for one instance of a
# source type, make sure all the other source types of all instances
# rawData folder is empty, otherwise the standardized data file will
# be re-generated and this process will be executed again for all
# instances of all source types. This will create dublicate in the DWH
# and is a performance issue and the standardized file will be loaded
# again.


# define logfiles
logFileMetadata="$HOME/SDWH/Logs/autoRun_script_MetadataOutput.log"
logFileData="$HOME/SDWH/Logs/autoRun_script_DataOutput.log"
performanceLogFile="$HOME/SDWH/Logs/pentahoPerformance_optimized.log"

# root directory of landing zone
landingzonepath="$HOME/SDWH/Landingzone"
# path to Pentaho configuration (DI)
pentahoconfigpath="$HOME/SDWH/PentahoConfiguration"

# name of Pentaho Di Repository
PentahoRep="PentahoFiles"

# --runConversionScripts is a Pentaho job which calls for
# runConversionScripts.sh shell script in
# $landingzonepath/ to run the conversion script

$HOME/datalab/data-integration/kitchen.sh -file=$pentahoconfigpath'/jobs/runConversionScripts.kjb' \
    -level=Rawlevel -level=Detailed >> $logFileMetadata



# --the following loop iterates through all source types under $landingzonepath
for source in $landingzonepath/*/
do
    cd $source
    # --the following loop iterates through all source instances under $landingzonepath/$source
    for instances in */
    do

	echo "============================================================"
	echo "We are at: "$source$instances

	#--set parameter values
	parameterFile=$landingzonepath/Parameters.xml
	sourceTypeMetaFile=$source"sourceType_metadata.xml"
	sourceMetaFile=$source$instances"source_metadata.xml"
	siteMetaFile=$source$instances"site_metadata.xml"
	dataFile=${source}${instances}"data/data_"${instances::-1}".csv"
	validationFile=$source"valueDefinition.xml"
	rawDataPath=${source}${instances}"rawData"
	
	echo  "parameterFile:	  $parameterFile" >> $logFileMetadata
	echo  "sourceTypeMetaFile: $sourceTypeMetaFile" >> $logFileMetadata
	echo  "sourceMetaFile:     $sourceMetaFile" >> $logFileMetadata
	echo  "siteMetaFile: 	  $siteMetaFile" >>$logFileMetadata
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


	echo "--------------"
	echo "Meta data updated!"
	# -------------------------------------------------------


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

	echo "--------------"
	echo "Signals updated!"

    done
done
