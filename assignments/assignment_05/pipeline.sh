#!/bin/bash
set -ueo pipefail

# 01 - download fastq files for processing using 01_download_data.sh

# (Note that this script should already be in a folder added to your $PATH)
01_download_data.sh

# 02 - run fastp on fastq files

# or update the below with a path to a different folder containing raw data 
cd ~/SUPERCOMPUTING/assignments/assignment_05/data/raw

# run fastp in loop on fwd reads using 02_run_fastp.sh
# 02_run_fastp.sh should automatically put the outputs into the "data/trimmed" folder 
for i in *_R1_001.subset.fastq.gz;do 02_run_fastp.sh $i;done
