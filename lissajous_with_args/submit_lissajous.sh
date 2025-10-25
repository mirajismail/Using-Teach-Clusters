#!/bin/bash
#SBATCH --job-name=lissajous
#SBATCH --output=output_%j.txt
#SBATCH --error=error_%j.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --time=00:10:00


# Compile
g++ -O2 -o lissajous_args lissajous_args.cpp -lm

# Run all combinations in parallel
parallel -j $SLURM_CPUS_PER_TASK "./lissajous_args {1} {2} > output_{1}_{2}.txt" ::: $(seq 1 5) ::: $(seq 1 5)

# Combine all results
cat output_*.txt > all_results.txt

