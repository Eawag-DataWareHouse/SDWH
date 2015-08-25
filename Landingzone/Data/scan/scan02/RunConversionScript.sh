#!/bin/bash

for i in rawData/*.fp
do
    Rscript Scan2Standard.r "./$i"
    echo "converted $i"
done
