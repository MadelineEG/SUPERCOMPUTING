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

## Instructions for Future User

## Reflection
* getting scripts to work properly from wherever -- remembering to update permissions, $PATH, run exec bash, etc
* intially made a mistake with the naming convention (put FWD and REV rather than R1 and R2 in the variables for the 02_run_fastp.sh script and was confused briefly about why fastp was raising an error)
* getting output to go into correct directory -- created a var specifying the output dir in the 02 script -- gave me an error at first bc tried to expand ~ in "" -- needed to use $HOME instead

* learned that can link together individual scripts in a central pipeline script
* can easily automate removal of json and html in fastp
* useful to specify $OUT_DIR in scripts in addition to inputs and outputs
* useful to test individual scripts on a subset of data before putting them together into a pipeline and running it (makes it easier to find and debug the sources of errors)

* separate scripts in pipeline = useful bc modularity and can prob mix and match them into dif pipelines -- also easier to understand the overall pipeline when you look at it, vs. having all the details of the complex script components
* can be annoying bc need to put them all into $PATH -- also if someone else wants to use it, they have to make sure they have all the individual scripts
