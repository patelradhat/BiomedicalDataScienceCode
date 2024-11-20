#!/bin/bash
#SBATCH -A bme4350 # account
#SBATCH -p standard # partition/queue
#SBATCH --nodes=1 # number of compute nodes
#SBATCH --ntasks=1 # number of program instances
#SBATCH --time=03:00:00 # max time before job cancels
# Create directory for output
OUTDIR=/scratch/rtp8vfa/homework3/fastqc_output_array
mkdir -p $OUTDIR
# Get list of all data files
FILES=($(ls -1 /scratch/rtp8vfa/homework3/*.fastq.gz))
# Use Slurm Array number
#to select file for this job
FILE="${FILES[$SLURM_ARRAY_TASK_ID]}"
echo $FILE
echo "Processing file $FILE"
module purge
module load fastqc
fastqc $FILE --outdir $OUTDIR