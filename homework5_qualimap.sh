#!/bin/bash
#SBATCH -A bme4350 # account
#SBATCH -p standard # partition/queue
#SBATCH --nodes=1 # number of compute nodes
#SBATCH -c 8 # number of cores
#SBATCH --ntasks=1 # number of program instances
#SBATCH --time=10:00:00 # max time before job cancels
#SBATCH --mem=128G # request memory
$USER=rtp8vfa
# Get list of all data files
FILES=($(ls -1 /scratch/rtp8vfa/aligned_reads/*Aligned.sortedByCoord.out.bam))
# Use slurm array number to get select file for this job
FILE="${FILES[$SLURM_ARRAY_TASK_ID]}"
# Load modules
module purge
unset DISPLAY
module load gcc qualimap
# Quality control with qualimap
qualimap $FILE -p strand-specific-reverse --java-mem-size=32G -a proportional