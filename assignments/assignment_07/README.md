# README for Assignment 7
``` text
Madeline Eibner-Gebhardt
Assignment 07
26 Mar, 2026
```

### 1. Setup
```bash
cd ~/SUPERCOMPUTING/assignments/assignment_07
mkdir {data,output,scripts}
mkdir data/{clean,dog_reference,raw}
touch scripts/{01_download_data.sh,02_clean_reads.sh,03_map_reads.sh}
chmod +x scripts/01_download_data.sh scripts/02_clean_reads.sh scripts/03_map_reads.sh
touch ./assignment_7_pipeline.slurm
```

### 2. Downlaod Sequence Data
Metagenomic data from a study on the presence of harmful cyanobacteria and other aquatic microbes in the San Francisco estuary: https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0203953#sec021 (Bioproject accession numbers SRX8773309 through SRX8773318: https://www.ncbi.nlm.nih.gov/sra?linkname=bioproject_sra_all&from_uid=434758)

Metadata location:
```bash
./data/SraRunTable.csv
```
(downloaded above using the SRA webtool and transferred to HPC via sftp)

Script to download metagenomic data given an SRA Run Table and download *Canis familiaris* reference genome from NCBI. Note that the script requires you to have the file organization specified in the "Setup" step:

In 01_download_data.sh:
```bash
#!/bin/bash
set -ueo pipefail

INPUT_PATH=./data/SraRunTable.csv
OUTPUT_PATH=./data/raw
REF_PATH=./data/dog_reference

# download metagenomic data given SRA Run Table
for i in $(tail -n +2 $INPUT_PATH | cut -d ',' -f1);do fasterq-dump -e 4 $i -O $OUTPUT_PAT>

# download Canis familiaris reference genome
cd $REF_PATH
datasets download genome taxon "Canis familiaris" --reference --filename dog_reference_gen>
unzip ./dog_reference_genome.zip
mv ./ncbi_dataset/data/GCF_*/*_genomic.fna ./dog_reference_genome.fna 
rm -rf ./ncbi_dataset
rm ./md5sum.txt
rm ./README.md
rm ./dog_reference_genome.zip

# return to assignment_07 home directory
cd ../..
```

### 3. Clean up raw reads

Script to 

In 02_clean_reads.sh:
```bash
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
```
(Note again that you need ./data/{raw,clean} to run the above)

fastp parameters: 
* -l 50: removes reads shorter than 50 bp
* -x: polyX trimming on 3' ends 
* -y: removes low complexity reads
* --json /dev/null --html /dev/null: get rid of extra .json and .html files that we don't need

### 4. Map clean reads to dog genome / 5. Extract reads that matched dog genome

In 03_map_reads.sh:
```bash
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
```

### 6. Submit your job to SLURM
Slurm script to put together the environment and run the pipeline:

In ./assignment_7_pipeline.slurm:
```bash
!/bin/bash
#SBATCH --job-name=assignment_7
#SBATCH --nodes=1 # how many physical machines in the cluster
#SBATCH --ntasks=1 # how many separate 'tasks' (stick to 1)
#SBATCH --cpus-per-task=20 # how many cores (bora max is 20)
#SBATCH --time=1-00:00:00 # d-hh:mm:ss or just No. of minutes
#SBATCH --mem=120G # how much physical memory (all by default)
#SBATCH --mail-type=FAIL,END # when to email you
#SBATCH --mail-user=mweibnergebhar@wm.edu # who to email
#SBATCH -o ./output/assignment_7_%j.out #STDOUT to file (%j is jobID)
#SBATCH -e ./output/assignment_7_%j.err #STDERR to file (%j is jobID)

# set up conda environment
module load miniforge3

source "$(conda info --base)/etc/profile.d/conda.sh"

conda create -y -n assignment_07-env bbmap datasets sra-tools fastp samtools -c bioconda

conda activate assignment_07-env

# download SRA data and dog reference genome
./scripts/01_download_data.sh

# clean SRA data with fastp
./scripts/02_clean_reads.sh

# map data against the dog genome and extract reads that align
./scripts/03_map_reads.sh

# deactivate conda environment
conda deactivate
```

```bash
sbatch ./assignment_7_pipeline.slurm
```

### 7. Inspect your stdout and stderr
```bash
cat output/*.err
cat output/*.out
```
.err contains a message warning me to update conda and lists info about the number of reads it has read and written from the data and stats about the fastp runs (although these weren't "errors")

.out contains a record of the software in the environment that I've activated and records of some of the software runs -- though most of these records went to the .err file.

### 8. Inspect your results
Results:
```text
Sample ID	Total Reads	Dog-Mapped Reads
SRR12268243	4744504	777
SRR12268244	8958874	148
SRR12268245	6253334	523
SRR12268246	7643554	350
SRR12268247	7790416	1709
SRR12268248	6709522	5056
SRR12268249	6629940	737
SRR12268250	6659154	9092
SRR12268251	6991946	1933
SRR12268252	7217292	3533
```
Created script ./scripts/inspect.sh to automate this
```bash
#!/bin/bash

cd ./output

echo -e "Sample ID\tTotal Reads\tDog-Mapped Reads" > matches-summary.tsv

paste -d '\t' <(for i in *_dog-matches.sam;do echo ${i/_dog-matches.sam/};done) \
        <(for i in *_dog-matches.sam;do grep -c "^SRR" ${i/_dog-matches.sam/.sam};done) \
        <(for i in *_dog-matches.sam;do grep -c "^SRR" $i;done) \
        >> matches-summary.tsv

cd ..

cat ./output/matches-summary.tsv
```

## Usage
**Purpose:** To quantify the number of reads that match *Canis familiaris* in Ilumina shotgun metagenomic data

**To run the pipeline:**
1. Follow the setup steps in Part 1 to obtain the required directory structure
2. From within assignments_07, run:
```bash
sbatch ./assignment_7_pipeline.slurm
```
3. After running the pipeline, to generate a summary .tsv of dog reads, run:
```bash
./scripts/inspect.sh
```

## Reflection
The most challenging part of the assignment was figuring out how to test the steps in the pipeline without time-consuming waitsteps and running memory-intensive processes on the login node. Eventually, I wrote a temporary slurm script to download some of the SRA data and the reference genome from NCBI with the 01_download_data.sh script. So that I could test the 02_clean_reads.sh and 03_map_reads.sh scripts without a slurm script, I created small subsets of the data using the loop for i in *_1.fastq;do head -n 400 $i > ${i/_1.fastq/_truncated_1.fast1};done and ran the remaining scripts on the "truncated" files. 

I ran into a few issues related to file organization and formatting. For example, I realized that the default way of downloading SRA files creates a system of directories that I didn't initially account for in my script. I added a few lines to the script to extract the specific file of interest from NCBI's directory network and to clean up the directories that I didn't need. I also found that looping over a file path would reference the file and its entire path when I then referenced the variable again, which caused issues (unexpectedly long and strange file paths) when I tried to create (in a new directory) an output file with a name modified from the variable. I was able to troubleshoot the issue by moving the output file directly into the new directory instead of including the directory before the name.

I also standardized a few aspects of my scripting style: I included variables referencing relevant file paths at the beginning of each script and standardized file paths to start at ./ (refering here to the assignment_07 directory) for clarity.

