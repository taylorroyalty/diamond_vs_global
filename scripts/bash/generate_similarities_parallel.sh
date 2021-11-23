#! /bin/bash


file_indices=$1

function parallel_nw {
#	query=/home/troyalty/Documents/projects/blast_vs_diamond/data/swiss_prot/swiss_evolution.fasta
	query=$1
	reference=/home/troyalty/Documents/projects/blast_vs_diamond/data/swiss_prot/swiss_prot_08032020.fasta
#	tmp_query=tmp_query_
	tmp_ref=tmp_ref_
	tmp_align=tmp_align_

	tmp1=tmp1_
	tmp2=tmp2_
	tmp3=tmp3_
	tmp4=tmp4_
	tmp5=tmp5_

	alignment=alignment_scores_
	tsv_ex=.tsv

#	start=$(echo $1 | cut -f 1 -d ' ')
#	end=$(echo $1 | cut -f 2 -d ' ')

	expr=$(head -n1 $1 | cut -f 2 -d '|')
#	awk -v start=$start -v stop=$end 'NR>stop{exit} NR>=start' $query > $tmp_query$expr
	grep -A1 $expr $reference > $tmp_ref$expr
	needle $tmp_ref$expr $1 -gapopen 11 -gapextend 1 -outfile $tmp_align$expr

	grep "1: " $tmp_align$expr | rev | cut -f 1 -d ' ' | rev > $tmp1$expr
	grep "2: " $tmp_align$expr | rev | cut -f 1 -d ' ' | rev > $tmp2$expr
	grep "Identity:" $tmp_align$expr | rev | cut -f 1-2 -d ' ' | rev > $tmp3$expr
	grep "Similarity:" $tmp_align$expr | rev | cut -f 1-2 -d ' ' | rev > $tmp4$expr
	grep "Score:" $tmp_align$expr | rev | cut -f 1 -d ' ' | rev > $tmp5$expr
	paste $tmp1$expr $tmp2$expr $tmp3$expr $tmp4$expr $tmp5$expr > $alignment$expr$tsv_ex

	rm tmp*$expr
}

export -f parallel_nw

parallel -j 30 --eta 'parallel_nw {}' < $file_indices
