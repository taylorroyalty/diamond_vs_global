#! /bin/bash

query=$1
ref=$2
n=$3

fileo=alignment_
n_max=$(tr -cd ">" < $ref | wc -c)

i=0
until [ $i -gt $n_max ]; do
	s=$(echo "$i*$n+1" | bc)
	e=$(echo "($i+1)*$n" | bc)
	frac=$(echo "($i+1)/$n_max" | bc)
	echo $i
	awk -v start=$s -v stop=$e 'NR>stop{exit} NR>=start' $query > tmp_evolution.fasta
	expr=$(head -n 1 tmp_evolution.fasta | cut -f 2 -d '|')
	grep -A1 $expr $ref > tmp_ref.fasta
	needle tmp_ref.fasta tmp_evolution.fasta -gapopen 11 -gapextend 1 -outfile tmp_align
	grep "1: " tmp_align | rev | cut -f 1 -d ' ' | rev > tmp1
	grep "2: " tmp_align | rev | cut -f 1 -d ' ' | rev > tmp2
	grep "Identity:" tmp_align | rev | cut -f 1-2 -d ' ' | rev > tmp3
	grep "Similarity:" tmp_align | rev | cut -f 1-2 -d ' ' | rev > tmp4
	grep "Score:" tmp_align | rev | cut -f 1 -d ' ' | rev > tmp5
	paste tmp1 tmp2 tmp3 tmp4 tmp5 >> alignment_scores.tsv
	let "i=i+1"
done
