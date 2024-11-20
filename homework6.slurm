#!/bin/bash
#SBATCH -A bme4350 # account
#SBATCH -p standard # partition/queue
#SBATCH --nodes=1 # number of compute nodes
#SBATCH --ntasks=1 # number of program instances
#SBATCH -c 16 # number of cores
#SBATCH --time=10:00:00 # max time before job cancels
# Get list of all data files
FILES=($(ls -1 /scratch/rtp8vfa/aligned_reads/*.toTranscriptome.out.bam))
# Use Slurm Array number
#to select file for this job
FILE="${FILES[$SLURM_ARRAY_TASK_ID]}"
# Create directory for output
TEMPNAME=($(basename $FILE Aligned.toTranscriptome.out.bam))
# Index
RSEMREF=/scratch/rtp8vfa/hg38_gencode_v44_rsemindex/RSEMref
module purge
module load gcc/7.1.0 openmpi/3.1.4 rsem
rsem-calculate-expression --no-bam-output --num-threads 16 --alignments $FILE $RSEMREF $TEMPNAME --paired-end
