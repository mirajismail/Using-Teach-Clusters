#!/bin/bash
module load gcc/13.2.0
export PATH=$HOME/hmmer/bin:$PATH

mkdir -p results

ls fasta_chunks/*.fasta | parallel -j 32 \
  'hmmsearch --cpu 2 --noali -o results/{/.}_results.txt Pfam-A.hmm {}'

