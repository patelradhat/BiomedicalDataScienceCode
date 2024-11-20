#!/bin/bash
#SBATCH -A bme4350 # account
#SBATCH -p standard # partition/queue
#SBATCH --nodes=1 # number of compute nodes
#SBATCH -c 8 # number of cores
#SBATCH --ntasks=1 # number of program instances
#SBATCH --time=03:00:00 # max time before job cancels
# Create directory for output
OUTDIR=/scratch/rtp8vfa/homework4/trimmed_output_fastqc
mkdir -p $OUTDIR
# Get list of all data files
FILESforward=($(ls -1 /scratch/rtp8vfa/homework3/*_1.fastq.gz))
FILESreverse=($(ls -1 /scratch/rtp8vfa/homework3/*_2.fastq.gz))
# Use Slurm Array number
#to select file for this job
FILEforward="${FILESforward[$SLURM_ARRAY_TASK_ID]}"
FILEreverse="${FILESreverse[$SLURM_ARRAY_TASK_ID]}"
module purge
module load fastqc
module load trimgalore
trim_galore -q 20 --illumina --paired --length 20 --fastqc $FILEforward $FILEreverse -o $OUTDIR