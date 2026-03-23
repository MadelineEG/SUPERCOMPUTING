#!/bin/bash
#SBATCH --job-name=assignment_7
#SBATCH --nodes=1 # how many physical machines in the cluster
#SBATCH --ntasks=1 # how many separate 'tasks' (stick to 1)
#SBATCH --cpus-per-task=20 # how many cores (bora max is 20)
#SBATCH --time=1-00:00:00 # d-hh:mm:ss or just No. of minutes
#SBATCH --mem=120G # how much physical memory (all by default)
#SBATCH --mail-type=FAIL,END # when to email you
#SBATCH --mail-user=mweibnergebhar@wm.edu # who to email
#SBATCH -o ./output/assignment_7_%j.out #STDOUT to file (%j is jobID)
#SBATCH -e ./output/assignment_7_%j.err #STDERR to file (%j is jobID)

# set up conda environment
module load miniforge3

source "$(conda info --base)/etc/profile.d/conda.sh"

conda create -y -n assignment_07-env bbmap datasets sra-tools fastp samtools -c bioconda

conda activate assignment_07-env

# download SRA data and dog reference genome
./scripts/01_download_data.sh

# clean SRA data with fastp
./scripts/02_clean_reads.sh

# map data against the dog genome and extract reads that align
./scripts/03_map_reads.sh

# deactivate conda environment
conda deactivate
