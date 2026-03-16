#!/bin/bash
set -ueo pipefail

# cd into raw data directory
cd $HOME/SUPERCOMPUTING/assignments/assignment_06/data

# download raw data
wget https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz
