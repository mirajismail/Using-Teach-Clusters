#!/bin/bash
#SBATCH --job-name=lissajous_ramdisk
#SBATCH --output=output_%j.txt
#SBATCH --error=error_%j.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --time=00:10:00

# Compile
g++ -O2 -o lissajous_args lissajous_args.cpp -lm

# Create a RAMdisk scratch directory (on node local memory)
RAMDISK=/dev/shm/lissajous_$SLURM_JOB_ID
mkdir -p $RAMDISK

# Run all combinations in parallel, writing to RAM
parallel -j $SLURM_CPUS_PER_TASK "./lissajous_args {1} {2} > $RAMDISK/output_{1}_{2}.txt" ::: $(seq 1 5) ::: $(seq 1 5)

# Combine results in RAM first
cat $RAMDISK/output_*.txt > $RAMDISK/all_results.txt

# Copy results back to your working directory before the job ends
cp $RAMDISK/*.txt $SLURM_SUBMIT_DIR/

# Clean up the RAMdisk
rm -rf $RAMDISK

