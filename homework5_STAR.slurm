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
FILESforward=($(ls -1 /scratch/rtp8vfa/trimmed_reads/*_1.fq.gz))
FILESreverse=($(ls -1 /scratch/rtp8vfa/trimmed_reads/*_2.fq.gz))
# Use slurm array number to get select file for this job
FILEforward="${FILESforward[$SLURM_ARRAY_TASK_ID]}"
FILEreverse="${FILESreverse[$SLURM_ARRAY_TASK_ID]}"
# Define prefixes
FILEprefix=($(basename $FILEforward _1_val_1.fq.gz))
# Load modules
module purge
module load star gcc
# Align reads using STAR
STAR --runThreadN 8 --genomeDir /scratch/$USER/hg38_gencode_v44_genomeindex --readFilesIn $FILEforward $FILEreverse --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate --quantMode TranscriptomeSAM GeneCounts --outFileNamePrefix $FILEprefix
# LINE 22: 
# STAR --runThreadN 8 
#      --genomeDir /scratch/$USER/hg38_gencode_v44_genomeindex
#      --readFilesIn $FILEforward $FILEreverse
#      --readFilesCommand zcat 
#      --outSAMtype BAM SortedByCoordinate 
#      --quantMode TranscriptomeSAM GeneCounts 
#      --outFileNamePrefix $FILEprefix