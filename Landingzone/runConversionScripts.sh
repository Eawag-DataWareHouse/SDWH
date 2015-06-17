for source in scan WeatherRadar MicrowaveLinks WaterSampleDataLab FloDar
do
	for instances in 01 02 03 04 05 06 07 08 09 10
	do 
		DIRECTORY=/home/data/deviceTypes/$source/$source$instances/
		if [ -d "$DIRECTORY" ]; then
			# if $DIRECTORY exists
			cd /home/data/deviceTypes/$source/$source$instances/
			echo "working directory: $DIRECTORY"	
			./RunRScript.sh
				FILE=$DIRECTORY/data/data_$source$instances.csv
				if [ -f "$FILE" ]; then
				sed -i 's/\([0-9]\)e\([-+]\)/\1E\2/g' $FILE
				fi
		fi
	done
done
