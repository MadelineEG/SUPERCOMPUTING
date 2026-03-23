# README for Assignment 6
``` text
Madeline Eibner-Gebhardt
Assignment 06
19 Mar, 2026
```

### 1. Setup
```bash
cd ~/SUPERCOMPUTING/assignments/assignment_06
mkdir assemblies 
mkdir assemblies/assembly_{conda,local,module}
mkdir data scripts
touch scripts/{01_download_data.sh,02_flye_2.9.5_conda_install.sh,02_flye_2.9.5_manual_build.sh,03_run_flye_conda.sh,03_run_flye_local.sh,03_run_flye_module.sh}
touch flye-env.yml pipeline.sh README.md
```

### 2. Download Raw Data
In scripts/01_download_data.sh:
```bash
#!/bin/bash
set -ueo pipefail

# cd into raw data directory
cd $HOME/SUPERCOMPUTING/assignments/assignment_06/data

# download raw data
wget https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz
```

```bash
cd ~/SUPERCOMPUTING/assignments/assignment_06/scripts
chmod +x 01_download_data.sh
./01_download_data.sh
```

### 3. Get Flye v2.9.6 (local build)
In scripts/02_flye_2.9.5_manual_build.sh:
```bash
#!/bin/bash
set -ueo pipefail

# cd into programs directory
cd ~/programs

# clone and build Flye if it doesn't already exist
if [ ! -d ~/programs/"Flye" ]; then
        cd ~/programs
        git clone https://github.com/fenderglass/Flye
        cd Flye
        make
        echo 'export PATH="$HOME/programs/Flye/bin:$PATH"' >> ~/.bashrc
fi

# cd back to original directory
cd ~/SUPERCOMPUTING/assignments/assignment_06
```

```bash
cd ~/SUPERCOMPUTING/assignments/assignment_06
chmod +x ./scripts/02_flye_2.9.5_manual_build.sh
./scripts/02_flye_2.9.5_manual_build.sh
```

### 4. Get Flye v2.9.6 (conda build)
In scripts/02_flye_2.9.5_conda_install.sh:
```bash
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
```

Testing out the above script:
```bash
source ./scripts/02_flye_2.9.5_conda_install.sh
conda deactivate
```

### 5. Decipher how to use Flye
Test command following example for Nanopore data:
```bash
flye --nano-raw SRR33939694.fastq.gz --out-dir out_nano --threads 6
```

### 6A. Run Flye - Conda
(Note that this script must be run from the assignments/assignment_06 directory)

In scripts/03_run_flye_conda.sh:
```bash
#!/bin/bash
set -ueo pipefail

# load minforge, activate flye-env
module load miniforge3
source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh  

# activate flye-env
conda activate flye-env

# make required directory
mkdir -p ./assemblies/assembly_conda

# run flye (assuming user is in assignment_06 directory)
flye --nano-raw ./data/SRR33939694.fastq.gz --out-dir ./assemblies/assembly_conda/junk --threads 6

# extract desired assembly and log files
mv ./assemblies/assembly_conda/junk/{assembly.fasta,flye.log} ./assemblies/assembly_conda/

# clean up junk files
rm -r ./assemblies/assembly_conda/junk

# rename relevant files
mv ./assemblies/assembly_conda/assembly.fasta ./assemblies/assembly_conda/conda_assembly.fasta
mv ./assemblies/assembly_conda/flye.log ./assemblies/assembly_conda/conda_flye.log

# deactivate flye-env
conda deactivate
```

```bash
chmod +x ./scripts/03_run_flye_conda.sh
./scripts/03_run_flye_conda.sh
```

### 6B. Run Flye - Module Env
In scripts/03_run_flye_module.sh:

```bash
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
```

```bash
chmod +x ./scripts/03_run_flye_module.sh
./scripts/03_run_flye_module.sh
```

### 6C. Run Flye - Local Build
In scripts/03_run_flye_local.sh:

```bash
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
```

```bash
chmod +x ./scripts/03_run_flye_local.sh
./scripts/03_run_flye_local.sh
```

### 7. Compare results in log files
Here is the general code: 
```bash
tail -n 10 conda_flye.log
```

### 8. Build a `pipeline.sh` script
In assignment_06:
```bash
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
```

**Running the Pipeline**
```bash
chmod +x ./pipeline.sh
./pipeline.sh
```

### 9. Delete everything except scripts and start over
Removed all raw data and assembly outputs. Reran pipeline to test functionality. 

## Description
This pipeline:
* Downloads *E. coli* phage raw genome sequences
* Installs Flye, a genome assembly software, using three different methods: Conda, module-based installation, and local installation
* Assembles the *E. coli* phage data via Flye after each installation  
* Outputs summary stats for each assembly to the screen

**Usage:**

Run this pipline from the folder assignments_06 (see setup instructions from part 1):
```bash
chmod +x ./pipeline.sh
./pipeline.sh
```

## Reflection
I ran into a few basic challenges while writing and testing my scripts. I had a few "typo" problems, e.g., typing "outdir" instead of "out-dir" with Flye, which I fixed by looking more closely at the Flye user manual. I also couldn't get 03_run_flye_conda.sh to run at first and eventually realized that it had either wiped itself clean or I hadn't saved it properly. Fortunately, I'd already copied it into the README. My final pipeline also initially crashed at the local Flye build step because I had already downloaded Flye. I added an if statement checking for Flye in the programs directory and downloading it and adding it to the path in the case that it wasn't present.

I noticed that the environment (in 02_flye_2.9.5_conda_install.sh)seemed to auto-deactivate after activating it within the script -- or it was only accessible within the script. I was initially concerned this was a problem, but it wasn't an issue when I ran the pipeline, possibly because I activated the environment within each script that required it. I also learned that it can be important to specify the location of scripts (even those in the current working directory) with ./script.sh. I had two pipeline.sh files from different assignments and, since I had previously added a different "pipeline.sh" file to my path, the wrong pipeline initially ran when I tried to test my current pipeline.

My preferred method is still to download tools locally. Local downloads don't rely on an existing pre-installed modules and don't require the extra steps of activating and deactivating conda, etc. However, I will probably use the Conda method for the next assignment to enhance reproducibility -- so that the user doesn't need to have a given program pre-installed and added to their $PATH (and so I don't need to add it to their ~/.bashrc to make the pipeline work).

