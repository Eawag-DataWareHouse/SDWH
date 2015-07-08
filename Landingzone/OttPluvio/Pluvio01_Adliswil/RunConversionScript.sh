#!/bin/bash

for i in rawData/*.txt
do
    Rscript Pluvio2Standard.r "./$i"
    echo "converted $i"
done
