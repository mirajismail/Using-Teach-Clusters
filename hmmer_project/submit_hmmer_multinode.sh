#!/bin/bash
#SBATCH --job-name=hmmsearch_multi
#SBATCH --output=hmmsearch_multi_%j.out
#SBATCH --error=hmmsearch_multi_%j.err
#SBATCH --nodes=2               # use 2 nodes
#SBATCH --ntasks-per-node=20    # 20 processes per node
#SBATCH --cpus-per-task=2       # each hmmsearch gets 2 threads
#SBATCH --time=02:00:00
#SBATCH --mem=0

module load gcc/13.2.0
export PATH=$HOME/hmmer/bin:$PATH

cd $HOME/CSCD71/hmmer_project
mkdir -p results

# Start monitoring every 30s
jobperf -j $SLURM_JOBID -o jobperf_$SLURM_JOBID.log -i 30s &

# Run hmmsearch in parallel across all tasks
ls fasta_chunks/*.fasta | srun --ntasks=$((SLURM_NNODES * SLURM_NTASKS_PER_NODE)) \
  parallel -j $SLURM_NTASKS \
  "hmmsearch --cpu $SLURM_CPUS_PER_TASK --noali \
   -o results/{/.}_results.txt Pfam-A.hmm {}"

wait

