#!/bin/bash
#SBATCH -A bme4350 # account
#SBATCH -p standard # partition/queue
#SBATCH --nodes=1 # number of compute nodes
#SBATCH -c 8 # number of cores
#SBATCH --ntasks=1 # number of program instances
#SBATCH --time=10:00:00 # max time before job cancels
module purge
module load star gcc
$USER=rtp8vfa
PREFIX=($(ls -1 /scratch/rtp8vfa/trimmed_reads/*_*_))
FILEforward=($(ls -1 /scratch/rtp8vfa/trimmed_reads/*_1.fq.gz))
FILEreverse=($(ls -1 /scratch/rtp8vfa/trimmed_reads/*_2.fq.gz))
STAR --runThreadN 8 --genomeDir /scratch/$USER/hg38_gencode_v44_genomeindex --readFilesIn FILEforward FILEreverse --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate --quantMode TranscriptomeSAM GeneCounts --outFileNamePrefix F93_FBS
FILES=($(ls -1 /scratch/rtp8vfa/homework3/*.fastq.gz))
