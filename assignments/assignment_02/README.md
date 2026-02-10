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
Made data folder:
```bash
mkdir assignments/assignment_02/data
```

### 2. Downloading from NCBI via Command-Line FTP
**Downloaded from NCBI on local device**
Troubleshot ftp access:
```bash
# attempted ftp command procedure
ftp ftp.ncbi.nlm.nih.gov

# above returned an error ("ftp: command not found"), so downloaded with homebrew
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
Opened assignments/assignment_02/data on FileZilla remote site tab, then dragged files from local to remote
Verified successfuly copying to HPC data folder:
```bash
# on HPC, from SUPERCOMPUTING directory:
ls assignments/assignment_02/data

# realized that inconcistency now between local and HPC because data folder only exists on HPC 
# removed new files from local device, pushed from HPC, and pulled back to local to resolve issue
```

### 4. Verify File Integrity with md5sum

### 5. Create Useful Bash Aliases

## Reflection