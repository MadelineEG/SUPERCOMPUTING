#!/bin/bash
set -ueo pipefail

# Download raw data
./scripts/01_download_data.sh

# Build local Flye
./scripts/02_flye_2.9.5_manual_build.sh

# Build Flye conda env and yml
./scripts/02_flye_2.9.5_conda_install.sh

# Run Flye - conda
./scripts/03_run_flye_conda.sh

# Run Flye - module
./scripts/03_run_flye_module.sh

# Run Flye - local 
./scripts/03_run_flye_local.sh

echo "Summary of Conda run:"
tail -n 10 ./assemblies/assembly_conda/conda_flye.log

echo "Summary of Module run:"
tail -n 10 ./assemblies/assembly_module/module_flye.log

echo "Summary of Local run:"
tail -n 10 ./assemblies/assembly_local/local_flye.log
