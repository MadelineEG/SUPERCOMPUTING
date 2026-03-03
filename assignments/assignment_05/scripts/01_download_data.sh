#!/bin/bash
set -ueo pipefail

# cd into raw data directory
cd $HOME/SUPERCOMPUTING/assignments/assignment_05/data/raw

# download raw data
wget https://gzahn.github.io/data/fastq_examples.tar

# unpack the tarball
tar -xvf fastq_examples.tar

# clean up .tar file
rm fastq_examples.tar
