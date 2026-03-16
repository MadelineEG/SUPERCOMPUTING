#!/bin/bash
set -ueo pipefail

# load module
module load Flye

# make required directory
mkdir -p ./assemblies/assembly_module

# run flye (assuming user is in assignment_06 directory)
flye --nano-raw ./data/SRR33939694.fastq.gz --out-dir ./assemblies/assembly_module/junk --threads 6

# extract desired assembly and log files
mv ./assemblies/assembly_module/junk/{assembly.fasta,flye.log} ./assemblies/assembly_module/

# clean up junk files
rm -r ./assemblies/assembly_module/junk

# rename relevant files
mv ./assemblies/assembly_module/assembly.fasta ./assemblies/assembly_module/module_assembly.fasta
mv ./assemblies/assembly_module/flye.log ./assemblies/assembly_module/module_flye.log
