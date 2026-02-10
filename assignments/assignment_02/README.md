# README for Assignment 2
Madeline Eibner-Gebhardt
Assignment 02
12 Feb, 2026

### 1. Setting Up
**Confirmed setup on supercomputer**
Logged into HPC, verified assignment_02 existence and setup:
```bash
bora
cd ~/SUPERCOMPUTING
ls assignments/assignment_02
```
Made data folder on HPC:
```bash
mkdir assignments/assignment_02/data
```

### 2. Downloading from NCBI via Command-Line FTP
**Downloaded files from NCBI on local device**
Troubleshot ftp access:
```bash
# attempted ftp command procedure
ftp ftp.ncbi.nlm.nih.gov

# above returned an error ("ftp: command not found"), so downloaded ftp with homebrew
brew install inetutils
ftp ftp.ncbi.nlm.nih.gov
```
From assignments/assignment_02 (local), download files:
```bash
# moved to correct location
cd genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/

# attempted to download the .fna file, encountered error:
# 450 LIST: Connection refused
# 500 Illegal PORT command
get GCF_000005845.2_ASM584v2_genomic.fna.gz

# searched up the error message and found a workaround by putting ftp into passive mode
passive

# correctly downloaded both files
get GCF_000005845.2_ASM584v2_genomic.fna.gz
get GCF_000005845.2_ASM584v2_genomic.gff.gz
```
Verified file presence on local device outside of ftp>:
```bash
# at ftp>, type:
bye

# from assignment_02 folder (where files were newly downloaded):
ls

# above showed the README and both the .fna and .gff, verifying successful download
```

### 3. File Transfer and Permissions
Opened Filezilla, located both files under SUPERCOMPUTING/assignments/assignment_02 on local device
Opened assignments/assignment_02/data on FileZilla remote site (HPC) tab, then dragged files from local to remote
Verified successful copying of files to HPC data folder:
```bash
# on HPC, from SUPERCOMPUTING directory:
ls assignments/assignment_02/data
```
realized that inconsistency now existed between local and HPC because data folder only existed on HPC (not in local assignment_02 directory)
removed new files from local device, pushed from HPC, and pulled back to local to resolve issue

Checked and modified file permissions on HPC:
```bash
# navigated to assignments/assignment_02/data folder from SUPERCOMPUTING
cd assignments/assignment_02/data

# outputs of the below had -rw------- permissions, indicating that only I could read and write to them
ls -ll

# modified permissions to -rw-r--r-- (world readable) via chmod below
chmod 644 GCF_000005845.2_ASM584v2_genomic.fna.gz
chmod 644 GCF_000005845.2_ASM584v2_genomic.gff.gz

# verified updated permissions
ls -ll
```

### 4. Verify File Integrity with md5sum
On local device (in assignments/assignment_02/data):
```bash
md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz
md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz
```
Hash outputs:
e1b894042b53655594a1623a7e0bb63f and 494dc5999874e584134da5818ffac925, respectively

On HPC:
```bash
md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz
md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz
```
Hash outputs:
*Also* e1b894042b53655594a1623a7e0bb63f and 494dc5999874e584134da5818ffac925, respectively

Identical hashes on corresponding files on local device and on HPC indicate successful upload and no corruption

### 5. Create Useful Bash Aliases
Navigated to home directory
```bash
cd ~
nano .bashrc
```
Added below to ~/.bashrc file (previously had a slightly different set of aliases)
```bash
alias u='cd ..;clear;pwd;ls -alFh --group-directories-first'
alias d='cd -;clear;pwd;ls -alFh --group-directories-first'
alias ll='ls -alFh --group-directories-first'
```
Alias descriptions:
* u = Moves to parent directory, then clears the history and prints the current working directory. Finally, lists the directory's contents, including hidden files, in long format and in human readable format (i.e., prints file sizes with units), with a code specifying file type, and with directories listed before files
* d = Moves to the directory that you were previously in (regardless of whether it is the parent directory), clears history, prints the working directory, and lists directory contents in the same format as above
* ll = Lists directory contents, including hidden files, in long format and in human readable format, with a code specifying file type, and with directories listed before files

## Summary of directory structure
├── data
│   ├── GCF_000005845.2_ASM584v2_genomic.fna.gz
│   └── GCF_000005845.2_ASM584v2_genomic.gff.gz
└── README.md

## Reflection