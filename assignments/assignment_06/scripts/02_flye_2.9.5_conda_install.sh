#!/bin/bash
set -ueo pipefail

# load python3 and conda from module
module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh  

# create environment for flye
mamba create -y -n flye-env flye -c bioconda

# activate environment
conda activate flye-env

# output flye version number
flye -v

# document env in yml
conda env export --no-builds > flye-env.yml

