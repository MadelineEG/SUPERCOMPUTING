#!/bin/bash
set -ueo pipefail

# make required directory
mkdir -p ./assemblies/assembly_local

# run flye (assuming user is in assignment_06 directory)
flye --nano-raw ./data/SRR33939694.fastq.gz --out-dir ./assemblies/assembly_local/junk --threads 6

# extract desired assembly and log files
mv ./assemblies/assembly_local/junk/{assembly.fasta,flye.log} ./assemblies/assembly_local/

# clean up junk files
rm -r ./assemblies/assembly_local/junk

# rename relevant files
mv ./assemblies/assembly_local/assembly.fasta ./assemblies/assembly_local/local_assembly.fasta
mv ./assemblies/assembly_local/flye.log ./assemblies/assembly_local/local_flye.log
