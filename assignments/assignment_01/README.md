
# README for Assigment 1

### 1. Setup
Create relevant assignment folders starting in SUPERCOMPUTING directory, which will contain the folder "assignments"
```bash
mkdir assignments
mkdir assignments/assignment_01
```

### 2. Directory Structure
Add major directories. Note that none of these directories can be commited to Github until they contain placeholder files. The file paths below are again designed to be run from a directory (e.g. SUPERCOMPUTING) that contains the assignments folder
```bash
mkdir assignments/assignment_01/data
mkdir assignments/assignment_01/scripts
mkdir assignments/assignment_01/results
mkdir assignments/assignment_01/docs
mkdir assignments/assignment_01/config
mkdir assignments/assignment_01/logs
```
Add relevant setup files: 
For example, add a gitignore file so that, e.g, we ignore large sequence files that we dont want to put on GitHub. Note that .gitignore is hidden on terminal
```bash
touch assignments/assignment_01/.gitignore
```
Add markdown files
```bash
touch assignments/assignment_01/README.md
touch assignments/assignment_01/assignment_1_essay.md
```

### 3. Sub-directories
Add subdirectories for storing different relevant types of data in the data directory and for storing different possible result outputs in the results directory. I've included folders for raw and clean data and to store reference sequences and metadata
```bash
mkdir assignments/assignment_01/data/{raw,clean,references,metadata}
mkdir assignments/assignment_01/results/{figures,tables,sequences}
```

### 4. Placeholder files
Add placeholder files for data, scripts, results, etc so that folders show up in the git repository
```bash
# raw compressed placeholder fastq files for raw data folder
touch assignments/assignment_01/data/raw/{sequence_1.fq.gz,sequence_2.fq.gz}

# clean placeholder fasta files after unzipping and converting the format of the raw fastqs and possibly removing adapters and low quality sequences
touch assignments/assignment_01/data/clean/{sequence_1.fasta,sequence_2.fasta}

# create placeholder reference genome and gff file -- if, for example, we are trying to obtain all the reads that align against a particular species and info about the genes to which they align, we will need these files
touch assignments/assignment_01/data/references/{genome_ref.fasta,genome_annotation.gff}

# create placeholder metadata csv
touch assignments/assignment_01/data/metadata/metadata.csv

# create placeholder script
touch assignments/assignment_01/scripts/script.py

# create placeholder results table and figure
# in the below example, we might have profiled the species present in the sequence data with our code and now have a csv with species names and associated data plus a figure with percent abundances
touch assignments/assignment_01/results/tables/species.csv
touch assignments/assignment_01/results/figures/abundance.pdf

# imagining that we also used our code to align and extract all reads that aligned to a particular species' reference genome and then generated a consensus sequence for those reads
# create placeholder consensus sequence from aligning raw data against reference sequence and other steps
touch assignments/assignment_01/results/sequences/consensus_genome.fasta

# create placeholder document
touch assignments/assignment_01/docs/info.pdf

# create environment config file to prevent conflicts with other projects
touch assignments/assignment_01/config/environment.yml

# create placeholder log file
touch assignments/assignment_01/logs/alignment_job_01.log
```
