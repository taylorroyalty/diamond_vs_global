#! /usr/lib/python3.8
from Bio import SeqIO
from math import log
import sys
import pandas as pd
import nwalign3 as nw

in_fasta=sys.argv[1]
ref=sys.argv[2]
outfile=sys.argv[3]


def global_align(query,seq2):
    seq1=query.seq
    seq_id=query.id
    lamb=0.255
    K=0.035
    alignment=nw.global_align(seq1,seq2,
                              gap_open=-11,
                              gap_extend=-1,
                              matrix='/usr/share/ncbi/data/BLOSUM62')
    score=nw.score_alignment(alignment[0],alignment[1],
                              gap_open=-11,
                              gap_extend=-1,
                              matrix='/usr/share/ncbi/data/BLOSUM62')
    
    bitscore=(lamb*score-log(K))/log(2)
    return seq_id,score, bitscore

fasta_iter = SeqIO.parse(open(in_fasta),"fasta") #convert fasta file to fastaiterator object
# with open(outfile,'w+') as fasta_write:
# for query in fasta_iter:
scores=[global_align(query,ref) for query in fasta_iter]

df_out=pd.DataFrame(scores,columns=['id','score','bitscore'])
df_out.to_csv(outfile,sep='\t')
