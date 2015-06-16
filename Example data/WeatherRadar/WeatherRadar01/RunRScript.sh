EXT=gif
for i in *.${EXT};
	do
		Rscript Radar2standard.r ./rawData/$i
	done
