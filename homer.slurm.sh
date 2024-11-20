#!/bin/bash
#SBATCH -A bme4350 # account
#SBATCH -p standard # partition/queue
#SBATCH --nodes=1 # number of compute nodes
#SBATCH --ntasks=1 # number of program instances
#SBATCH --time=10:00:00 # max time before job cancels
FILES=($(ls -1 /home/rtp8vfa/bedfiles/*.bed))
FILE="${FILES[$SLURM_ARRAY_TASK_ID]}"
TEMPNAME=($(basename $FILE .sra.bed_summits.bed))
module purge
module load gcc/7.1.0
module load homer/4.10
annotatePeaks.pl FILE hg38 -gsize hg38 > TEMPNAME

