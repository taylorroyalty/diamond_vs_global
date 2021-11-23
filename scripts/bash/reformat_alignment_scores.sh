#!/bin/bash

dir=$1

align_ex=.align

for f in $dir/*; do
	name=$(head -n 1 $f | cut -f 1)
	cut -f 1 $f -d $'\t' > tmp1
	cut -f 2 $f -d $'\t' | rev | cut -f 1-3 -d '_' | rev > tmp2
	cut -f 2 $f -d '(' | cut -f 1 -d '%' > tmp3
	cut -f 3 $f -d '(' | cut -f 1 -d '%' > tmp4
	cut -f 5 $f -d $'\t' > tmp5
	paste tmp1 tmp2 tmp3 tmp4 tmp5 > $dir$name$align_ex
	rm tmp*
	rm $f
done
