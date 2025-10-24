#!/bin/bash
#SBATCH --job-name=hmmsearch_parallel
#SBATCH --output=hmmsearch_%j.out
#SBATCH --error=hmmsearch_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --time=02:00:00
#SBATCH --mem=0

module load gcc/13.2.0
export PATH=$HOME/hmmer/bin:$PATH

# directories
WORKDIR=$HOME/CSCD71/hmmer_project
cd $WORKDIR
mkdir -p results

# monitor performance every 30 seconds
jobperf -j $SLURM_JOBID -o jobperf_$SLURM_JOBID.log -i 30s &

# run hmmsearch on all chunks in parallel
ls fasta_chunks/*.fasta | parallel -j 32 \
  "hmmsearch --cpu 2 --noali -o results/{/.}_results.txt Pfam-A.hmm {}"

wait

