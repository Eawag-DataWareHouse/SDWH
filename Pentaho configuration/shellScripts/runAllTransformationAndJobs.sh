# if you want to run this shell script only for one instance of a
# source type, make sure all the other source types of all instances
# rawData folder is empty, otherwise the standardized data file will
# be re-generated and this process will be executed again for all
# instances of all source types. This will create dublicate in the DWH
# and is a performance issue and the standardized file will be loaded
# again.


logFileMetadata=/home/TempFiles/autoRun_script_MetadataOutput.log
logFileData=/home/TempFiles/autoRun_script_DataOutput.log
performanceLogFile=/home/TempFiles/pentahoPerformance_optimized.log

# root directory of landing zone
path='/home/SDWH/example data'

# --runConversionScripts is a Pentaho job which calls for runConversionScripts shell script in /home/data/deviceTypes
# --run the conversion script

/home/pentaho/data-integration/kitchen.sh -file=/home/svn/eawag_dwh/trunk/Pentaho_DI_Repository/jobs/runConversionScripts.kjb -level=Rawlevel -level=Detailed >> $logFileMetadata

# --the following loop iterates through all source types under /home/data/deviceTypes
for source in $path/*/
do
	cd $source
	# --the following loop iterates through all source instances under /home/data/deviceTypes/$source
	for instances in */
	do 
		#--DIRECTORY=$source$instances
		#--if [ -d "$DIRECTORY" ]; then
			#--if DIRECTORY exists

			#--set parameter values
			parameterFile=$path/Parameters.xml
			sourceTypeMetaFile=$source"sourceType_metadata.xml"
			sourceMetaFile=$source$instances"source_metadata.xml"
			siteMetaFile=$source$instances"site_metadata.xml"
			dataFile=${source}${instances}"data/data_"${instances::-1}".csv"
			validationFile=$source"valueDefinition.xml"

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

			#-- the following line passes the above parameters to pentaho job and executes updateMetadata job
			/home/pentaho/data-integration/kitchen.sh -file=/home/svn/eawag_dwh/trunk/Pentaho_DI_Repository/jobs/updateMetadata.kjb -level=Rawlevel -param:parameterFile=$parameterFile -param:sourceTypeMetaFile=$sourceTypeMetaFile -param:sourceMetaFile=$sourceMetaFile -param:siteMetaFile=$siteMetaFile -param:dataFile=$dataFile -param:validationFile=$validationFile -rep=Pentaho_DI_Repository -level=Detailed >> $logFileMetadata
now=$(date +"%T")
echo "updateMetadata endTime : $now" >> $performanceLogFile
echo " " >> $performanceLogFile 

echo " " >> $logFileMetadata
echo "end of inserting updateMetadata" >> $logFileMetadata
echo " " >> $logFileMetadata

echo  "parameterFile:	  $parameterFile" >> $logFileData
echo  "sourceTypeMetaFile: $sourceTypeMetaFile" >> $logFileData
echo  "sourceMetaFile:     $sourceMetaFile" >> $logFileData
echo  "siteMetaFile: 	  $siteMetaFile" >>$logFileData
echo  "dataFile: 	  $dataFile" >>$logFileData
echo  "valueDefinitionFile: 	  $validationFile" >>$logFileData
echo  " " >> $logFileData

			#-- the following step checks if the standardized file exists, passes the above parameters to pentaho job and executes updateData job
			#-- dont forget to move or delete the files under rawData directory otherwise the first step of this shell script re-generate the dataFile and executes this step again...even if there is no change in the raw file

			if [ -f "$dataFile" ]; then
now=$(date +"%T")
echo "updateData startTime: $now" >> $performanceLogFile 
	/home/pentaho/data-integration/kitchen.sh -file=/home/svn/eawag_dwh/trunk/Pentaho_DI_Repository/jobs/UpdateData.kjb -level=Rawlevel -param:parameterFile=$parameterFile -param:sourceTypeMetaFile=$sourceTypeMetaFile -param:sourceMetaFile=$sourceMetaFile -param:siteMetaFile=$siteMetaFile -param:dataFile=$dataFile -param:validationFile=$validationFile -rep=Pentaho_DI_Repository -level=Detailed >> $logFileData
now=$(date +"%T")
echo "updateData endTime: $now" >> $performanceLogFile 
echo "" >> $performanceLogFile 
			fi
		#--fi
	done
done


