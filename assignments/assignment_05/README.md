# README for Assignment 5
``` text
Madeline Eibner-Gebhardt
Assignment 05
5 Mar, 2026
```

### 1. Setup

Setting up directories and empty script files:
```bash
cd ~/SUPERCOMPUTING/assignments/assignment_05
mkdir ./scripts
mkdir ./log
mkdir data
mkdir ./data/{raw,trimmed}
touch pipeline.sh
touch README.md
touch scripts/{01_download_data.sh,02_run_fastp.sh}
```

### 2. Script to download and prep fastq data

```bash
nano ~/.bashrc
```

Add scripts folder to path in .bashrc:
```bash
export PATH=/sciclone/home/mweibnergebhar/SUPERCOMPUTING/assignments/assignment_05/scripts:$PATH
```

Update script executability and open script:
```bash
exec bash
cd cd ~/SUPERCOMPUTING/assignments/assignment_05
chmod +x scripts/01_download_data.sh
nano scripts/01_download_data.sh
```

In 01_download_data.sh:
```text
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
```

### 3. Install, explore fastp

Install fastp (**fastp 1.1.0**) and update executability:
```bash
cd $HOME/programs
wget http://opengene.org/fastp/fastp
chmod a+x ./fastp
nano ~/.bashrc
```

Add fastp to path in .bashrc:
```text
export PATH=$PATH:$HOME/programs
```
(Note that programs directory was already in my .bashrc, so I left it as is for this portion of the assignment)

### 4. Script to run fastp

```bash
cd ~/SUPERCOMPUTING/assignments/assignment_05/scripts
chmod +x 02_run_fastp.sh
nano 02_run_fastp.sh
```

In 02_run_fastp.sh:
```text
#!/bin/bash
set -ueo pipefail

# input variables
FWD_IN=$1
REV_IN=${FWD_IN/_R1_/_R2_}

# output variable
FWD_OUT=${FWD_IN/.fastq.gz/.trimmed.fastq.gz}
REV_OUT=${REV_IN/.fastq.gz/.trimmed.fastq.gz}

# output directory
OUT_DIR="$HOME/SUPERCOMPUTING/assignments/assignment_05/data/trimmed"

# run fastp
fastp --in1 $FWD_IN --in2 $REV_IN --out1 $OUT_DIR/$FWD_OUT --out2 $OUT_DIR/$REV_OUT \
      --json /dev/null --html /dev/null \
      --trim_front1 8 --trim_front2 8 \
      --trim_tail1 20 --trim_tail2 20 \
      --n_base_limit 0 --length_required 100 \
      --average_qual 20
```
Note: assuming we want separate fwd and rev outputs and are *not* merging them here

Test on one fwd input file:
```bash
./scripts/02_run_fastp.sh ./data/raw/6083_001_S1_R1_001.subset.fastq.gz
```
This outputted info about the fastp run to the screen and produced the new files 6083_001_S1_R1_001.subset.trimmed.fastq.gz and 6083_001_S1_R2_001.subset.trimmed.fastq.gz and put them in the ~/SUPERCOMPUTING/assignments/assignment_05/data/raw folder

Note: will need to ensure that trimmed outputs end up in the trimmed folder when setting up the pipeline

### 5. `pipeline.sh` script

```bash
cd ~/SUPERCOMPUTING/assignments/assignment_05
chmod +x pipeline.sh
nano pipeline.sh
```

In pipeline.sh:
```text
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
```

pipeline.sh wouldn't run, so added it to $PATH in .bashrc
```bash
nano ~/.bashrc

# in .bashrc:
export PATH=/sciclone/home/mweibnergebhar/SUPERCOMPUTING/assignments/assignment_05/:$PATH

# then on command line -- making sure change gets recognized
exec bash

# run pipeline
pipeline.sh
```

### 6. Delete all the data files and start over

Delete the data files:
```bash
cd ~/SUPERCOMPUTING/assignments/assignment_05/data/raw
rm *.fastq.gz
cd ~/SUPERCOMPUTING/assignments/assignment_05/data/trimmed
rm *.fastq.gz
```

Rerun pipeline:
```bash
pipeline.sh
```

## Instructions for Future User
**Purpose:** This pipeline downloads and unzips a dataset of example fastq files (paired end), then processes them via quality filtering and trimming with fastp. The current script trims 8 bases from the front and 20 bases from the end of each forward and reverse read, discards reads that have "N" bases, are shorter than 100 nt, or have an average quality score of less than 20.

**Requirements:** 
* fastp 1.1.0 downloaded and added to $PATH
* Specified file organization (see "Setup" section above)
* Scripts 01_download_data.sh, 02_run_fastp.sh, and pipeline.sh (see above code for script contents and information) downloaded and added to $PATH

**Summary Instructions for Running the Pipeline:**
1) Set up appropriate file organization (see part 1 above)
2) Ensure fastp 1.1.0 is installed and added to $PATH 
3) Create script files 01_download_data.sh and 02_run_fastp.sh containing the scripts specified above
4) Create central pipeline pipeline.sh file containing the script specified above
5) Ensure all scripts are executable and added to $PATH
6) Make any desired modifications to fastp processing specifications, output directory location, etc in 02_run_fastp.sh
7) Run pipeline:
```bash
    pipeline.sh
```

## Reflection
I encountered a few minor challenges related to getting the scripts to work properly from different directory locations on the HPC. I remembered to add my script locations to $PATH, but they sometimes failed to run either because I had forgotten to update the permissions using permission or I hadn't run exec bash to process the changes I'd made to .bashrc. I also ran into an error where fastp failed to produce the output files. I eventually realized that I'd used "~" in quotes in a file path specifying the output directory in 02_run_fastp.sh. I changed this to "$HOME". I also realized that I had misnamed the fwd and rev sequences in 02_run_fastp.sh as using the patterns "FWD" and "REV" rather than "R1" and "R2." Once I fixed this, the pipeline ran as expected

I learned that it can be convenient to link together individual scripts in a central pipeline script for workflow automation. I also found that it was useful to test individual scripts on a subset of data before putting them together into a pipeline and running it. This made it easier to detect and debug the source of errors and I can imagine would would be especially important in larger and more-complex pipelines.

Splitting a pipeline into multiple scripts (that you link together) is useful because it creates modularity--so that others can more easily mix and match components of the pipeline with other pipelines or with their own scripts. The modularity also makes it easier to identify the source of errors when they arise because they allow the user to inspect smaller portions of code and their intermediate outputs--and to test the portions of code on small subsets of data before running everything.

On the other hand, this modularity can sometimes be inconvenient because it requires the user to make sure that 1), they have all of the scripts and that 2), all of the scripts have the correct permissions, are in $PATH, etc. This combination of factors might make reproducibility slightly more difficult.

