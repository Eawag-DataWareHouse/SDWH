#!/bin/bash

for i in rawData/*.gif
do
    Rscript Radar2standard.r "./$i"
    echo "converted $i"
done
