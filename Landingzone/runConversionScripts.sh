#!/bin/bash

# root directory of landing zone
landingzonepath="$HOME/SDWH/Landingzone"

cd $landingzonepath

# find all directories in the landingzone
for source in $(find . -maxdepth 1 -mindepth 1 -type d -printf '%f\n')
do
    # find all instances
    for instances in $(find . -maxdepth 2 -mindepth 2 -type d -printf '%f\n')
	do
	DIRECTORY="$landingzonepath/$source/$instances"

	# if $DIRECTORY exists
	if [ -d "$DIRECTORY" ]; then

	    echo "working directory: $DIRECTORY"
	    cd $DIRECTORY
	    ./RunConversionScript.sh

	    # convert 1.23e5 to 1.23E5
	    FILE="$DIRECTORY/data/data_$instances.csv"
	    if [ -f "$FILE" ]; then
	    	sed -i 's/\([0-9]\)e\([-+]\)/\1E\2/g' $FILE
	    fi

	    cd $landingzonepath
	fi
    done
done
