# README for Assignment 4
``` text
Madeline Eibner-Gebhardt
Assignment 04
26 Feb, 2026
```

### 1. Setup

I already have a "programs" directory in my $HOME, but if I were to create one, I would use:

```bash
mkdir ~/programs
```

### 2. Download and unpack "tarball"

I found the relevant url on the GitHub page by clicking the "releases" page and finding the section titled GitHub CLI 2.74.2. Under the assets, the link "GitHub CLI 2.74.2 linux amd64" looked like it corresponded our URL.

```bash
cd ~/programs
wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz
tar -xzvf gh_2.74.2_linux_amd64.tar.gz
rm gh_2.74.2_linux_amd64.tar.gz
```

Note that it looks like I already have a slightly older version of github installed in my programs folder: gh_2.74.0_linux_amd64

### 3. Build a bash script from task 2

```bash
touch programs/install_gh.sh
nano install_gh.sh
```

Inside install_gh.sh:
```text
#!/bin/bash
set -ueo pipefail

# get github link from web
cd $HOME/programs
wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz
# unpack the tarball
tar -xzvf gh_2.74.2_linux_amd64.tar.gz
# remove the downloaded tarball once extracted
rm gh_2.74.2_linux_amd64.tar.gz
```

```bash
# make script executible
chmod +x install_gh.sh
# from directory containing script, add directory to path
export PATH=$PATH:$(pwd)
```

### 4. Run your install_gh.sh script

```bash
./install_gh.sh
```

### 5. Add the location of the gh binary to your $PATH

```bash
export PATH=$PATH:~/programs/gh_2.74.2_linux_amd64/bin
```

### 6. Run gh auth login to setup your GitHub username and password

```bash
gh auth login
```
Then selected that I use GitHub on GitHub.com, that my preferred protocol is HTTPS, and that I would like to authenticicate GitHub CLI via an authenticication token. I pasted my token when prompted.

### 7. Create another installation script (for seqtk)

```bash
# in programs directory
touch install_seqtk.sh
```

Inside install_seqtk.sh:
```text
#!/bin/bash
set -ueo pipefail

# ensure installation is into the programs folder
cd $HOME/programs

# install seqtk
git clone https://github.com/lh3/seqtk.git;
cd seqtk; make

# echo instructions adding  directory containing seqtk to $PATH to ~/.bashrc
echo "export PATH=$PATH:$HOME/programs/seqtk" >> ~/.bashrc
```

```bash
# make script executible
chmod +x install_seqtk.sh
# from directory containing script, add directory to path
export PATH=$PATH:$(pwd)
# install seqtk using the script
./install_seqtk.sh
```

### 8. Figure out seqtk

Testing out different uses of seqtk:

```bash
# cd to location of assignment 3 genomic data file
cd ~/SUPERCOMPUTING/assignments/assignment_03/data
# establish a variable for the long file name
seq_test="GCF_000001735.4_TAIR10.1_genomic"

# generate a reverse complement sequence
seqtk seq -r ${seq_test}.fna > ${seq_test}_rev.fna 
# trim low-quality bases with Phred
seqtk trimfq ${seq_test}.fna > ${seq_test}_trim.fna
# trim each read by 5 bp on the left, 10 bp on the right
seqtk trimfq -b 5 -e 10 ${seq_test}.fna > ${seq_test}_trim-ends.fna
# count number of telomere repeats
seqtk telo ${seq_test}.fna > telo.bed 2> telo.count
# fold long fasta/fastq lines, remove comments
seqtk seq -Cl60 ${seq_test}.fna > ${seq_test}_fold.fna
```

### 9. Write a `summarize_fasta.sh` script
```bash
# cd to location of programs folder
cd ~/programs
touch summarize_fasta.sh
```

```text
#!/bin/bash
set -ueo pipefail

# accept fasta file as argument, store name in var
seq_fa=$1

# calculate, store relevant info
# number of sequences
num_seqs=$(grep -c "^>" $seq_fa)
# number of nucleotides
num_nts=$(cat $seq_fa | grep -v "^>" | tr -d '\n' | wc -m)
# table of sequence names and lengths
~/programs/seqtk/seqtk comp "$seq_fa" > "table_${seq_fa}.txt"

printf "There are $num_seqs sequences and $num_nts nucleotides in $seq_fa\n\n"
# printf "Nucleotides per sequence. First column: seq ID; Second column: total number of nts\n"
# cat table_${seq_fa}.txt

# note: ended up commenting out the last two lines because they caused the screen to display a large table
```

```bash
# make summarize_fasta.sh executible
chmod +x summarize_fasta.sh
# testing summarize_fasta.sh 
cd ~/SUPERCOMPUTING/assignments/assignment_03/data
summarize_fasta.sh GCF_000001735.4_TAIR10.1_genomic.fna
```

### 10. Run `summarize_fasta.sh` in a loop on multiple files.

```bash
cd ~/SUPERCOMPUTING/assignments/assignment_04
mkdir data
cd data

# then used sftp to transfer several of my own transcriptomic data files (in fastq.gz format) to my assignment_04/data folder on the HPC

# unzip .fq.gz files
for i in *.fq.gz; do gunzip $i; done
# convert fastq to fasta
for i in *.fq; do seqtk seq -a $i > ${i}.fa; done
# the above actually named everything .fq.fa, so I fixed this with the below
for i in *.fq.fa; do mv $i ${i/.fq.fa/.fa}; done

# run the script in a loop
for i in *.fa; do summarize_fasta.sh $i; done

```

## Reflection
I ran into a few challenges with making the software that I downloaded and scripts that I wrote accessible from multiple locations on the HPC. Adding the software's path to $PATH in ~./bash.rc didn't always fix the issue, so I had to use workarounds such as including the filepath when I referenced software in my scripts and temporarily adding the location to $PATH. It also took me a few tries to put together the summarize script and effectively loop over it. For example, I realized that I needed to change the name of the output table to correspond with each input file, otherwise I would overwrite it as the loop iterated. I also realized that I couldn't print the table outputs to the screen -- this would take up too much space and time on the terminal -- and should instead save them to files.

I learned how to write scripts, download bioinformatic softwares and use them in my scripts, and write loops so that I could run the scripts on files that match a given pattern. These skills should equip me to start processing and analyzing my own data on the HPC.

$PATH is a list of directories that get searched through when you enter a command. If the location of a given program is in $PATH, you do not have to specify its file path to access it. This is useful because it's common to have to run a program in a folder that is not the one in which you originally installed it.
