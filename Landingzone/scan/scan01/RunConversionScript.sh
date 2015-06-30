EXT=fp
for i in *.${EXT};
	do
		Rscript Scan2Standard.r ./rawData/$i
	done
