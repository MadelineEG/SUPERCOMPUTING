#!/bin/bash
set -ueo pipefail

INPUT_PATH=./data/SraRunTable.csv
OUTPUT_PATH=./data/raw
REF_PATH=./data/dog_reference

# download metagenomic data given SRA Run Table
for i in $(tail -n +2 $INPUT_PATH | cut -d ',' -f1);do fasterq-dump -e 4 $i -O $OUTPUT_PATH;done

# download Canis familiaris reference genome
cd $REF_PATH
datasets download genome taxon "Canis familiaris" --reference --filename dog_reference_genome.zip
unzip ./dog_reference_genome.zip
mv ./ncbi_dataset/data/GCF_*/*_genomic.fna ./dog_reference_genome.fna 
rm -rf ./ncbi_dataset
rm ./md5sum.txt
rm ./README.md
rm ./dog_reference_genome.zip

# return to assignment_07 home directory
cd ../..
