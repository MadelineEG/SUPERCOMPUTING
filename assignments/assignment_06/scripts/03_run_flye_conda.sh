#!/bin/bash
set -ueo pipefail

# load minforge, activate flye-env
module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh  

# activate flye-env
conda activate flye-env

# make required directory
mkdir -p ./assemblies/assembly_conda

# run flye (assuming user is in assignment_06 directory)
flye --nano-raw ./data/SRR33939694.fastq.gz --out-dir ./assemblies/assembly_conda/junk --threads 6

# extract desired assembly and log files
mv ./assemblies/assembly_conda/junk/{assembly.fasta,flye.log} ./assemblies/assembly_conda/

# clean up junk files
rm -r ./assemblies/assembly_conda/junk

# rename relevant files
mv ./assemblies/assembly_conda/assembly.fasta ./assemblies/assembly_conda/conda_assembly.fasta
mv ./assemblies/assembly_conda/flye.log ./assemblies/assembly_conda/conda_flye.log

# deactivate flye-env
conda deactivate
