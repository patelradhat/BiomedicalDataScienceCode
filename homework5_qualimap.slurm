#!/bin/bash
#SBATCH -A bme4350 # account
#SBATCH -p standard # partition/queue
#SBATCH --nodes=1 # number of compute nodes
#SBATCH -c 16 # number of cores
#SBATCH --ntasks=1 # number of program instances
#SBATCH --time=10:00:00 # max time before job cancels
#SBATCH --mem=128G # request memory
$USER=rtp8vfa
# Create directory for output
OUTDIR=/scratch/rtp8vfa/qualimap_output
mkdir -p $OUTDIR
# Get list of all data files
BAMFILES=($(ls -1 /scratch/rtp8vfa/aligned_reads/*Aligned.sortedByCoord.out.bam))
GTFFILE="/scratch/rtp8vfa/hg38_gencode_v44/gencode.v44.primary_assembly.annotation.gtf"
# Use slurm array number to get select file for this job
BAMFILE="${BAMFILES[$SLURM_ARRAY_TASK_ID]}"
# Load modules
module purge
unset DISPLAY
module load gcc qualimap
# Quality control with qualimap
TEMPNAME=($(basename $BAMFILE Aligned.sortedByCoord.out.bam))
QUALOUTDIR=/scratch/rtp8vfa/qualimap_output/$TEMPNAME
mkdir -p $QUALOUTDIR
qualimap rnaseq -bam $BAMFILE -gtf $GTFFILE -p strand-specific-reverse --java-mem-size=32G -a proportional -s -pe -outdir $QUALOUTDIR
# LINE 23:
# qualimap rnaseq -bam $BAMFILE -gtf $GTFFILE -p strand-specific-reverse 
#          --java-mem-size=32G -a proportional -s -pe -outdir $OUTDIR