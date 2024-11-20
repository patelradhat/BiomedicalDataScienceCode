#!/bin/bash
#SBATCH -A bme4350 # account
#SBATCH -p standard # partition/queue
#SBATCH --nodes=1 # number of compute nodes
#SBATCH --time=10:00:00 # max time before job cancels
#SBATCH -c 8
module load R
Rscript peak_analysis.R