#!/bin/bash
set -ueo pipefail

INPUT_PATH=./data/raw
OUTPUT_PATH=./data/clean

for i in $INPUT_PATH/*_1.fastq;do fastp --in1 $i --in2 ${i/_1.fastq/_2.fastq} \
	 -l 50 -x -y \
	 --out1 ${i/_1.fastq/_1_clean.fastq} --out2 ${i/_1.fastq/_2_clean.fastq} \
	 --json /dev/null --html /dev/null
	 mv $INPUT_PATH/*_clean.fastq $OUTPUT_PATH
done

cd ../..
