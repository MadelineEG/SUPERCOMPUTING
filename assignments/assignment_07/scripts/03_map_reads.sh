#!/bin/bash
set -ueo pipefail

REF=./data/dog_reference/dog_reference_genome.fna
INPUT=./data/clean

for i in $INPUT/*_1_clean.fastq;do
	bbmap.sh ref=$REF in=$i in2=${i/_1_clean.fastq/_2_clean.fastq} \
	out=${i/_1_clean.fastq/.sam} \
	nodisk=t \
	ambiguous=best \
	minid=0.95 \
 	threads=20 \
	-Xmx16g
done

# exclude reads that didn't map to the dog genome
for i in $INPUT/*.sam;do
	samtools view -F 4 $i > ${i/.sam/_dog-matches.sam}
	mv $i ./output
	mv ${i/.sam/_dog-matches.sam} ./output
done
