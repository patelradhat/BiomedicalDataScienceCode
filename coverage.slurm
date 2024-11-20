#!/bin/bash
#SBATCH -A bme4350 # account
#SBATCH -p standard # partition/queue
#SBATCH --nodes=1 # number of compute nodes
#SBATCH --time=10:00:00 # max time before job cancels
BEDFILES=($(ls -1 /scratch/rtp8vfa/bedfiles/*.bed))
BEDFILE="${BEDFILES[$SLURM_ARRAY_TASK_ID]}"
BAMFILES=($(ls -1 /scratch/rtp8vfa/bedfiles/*.bam))
BAMFILE="${BAMFILES[$SLURM_ARRAY_TASK_ID]}"
TEMPNAME=($(basename $BEDFILE .sra.bed_summits.bed))
bedtools coverage -a $BEDFILE -b $BAMFILE > $TEMPNAME