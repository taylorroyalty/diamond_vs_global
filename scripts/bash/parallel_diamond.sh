#!/bin/bash

query_list=$1

function diamond_blastp {
	query=$1
	filename=$(echo $query | rev | cut -f 1 -d '/' | rev | cut -f 1 -d '.')
	diamond_ex=.dimaond
	diamond blastp --query $query --db /home/troyalty/Documents/projects/blast_vs_diamond/data/swiss_prot/diamond_db/swiss_prot_db.dmnd --out $filename$diamond_ex -p 1 --max-target-seqs 5 --outfmt 6 --evalue 1000
}

export -f diamond_blastp

parallel --eta -j 30 'diamond_blastp {}' < $query_list
