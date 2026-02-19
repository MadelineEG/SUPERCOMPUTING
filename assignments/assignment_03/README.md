# README for Assignment 3
``` text
Madeline Eibner-Gebhardt
Assignment 03
19 Feb, 2026
```

### 1. Setup
On local device, made an alias for the astral server login in .bashrc (from within home directly -- or, on another device, wherever .bashrc is located)

Navigate to the assignments/assignment_03 directory on the HPC, then set it up

```bash
# cd SUPERCOMPUTING/assignments/assignment_03 or equivalent file path to reach assignment_03
# assuming everything is being run from within assignment_03 on the HPC:
touch README.md
mkdir data
```

### 2. Sequence Download

Use wget to download data from an internet link, then unzip it with gunzip

``` bash
# from within assignments/assignment_03:
cd data
wget https://gzahn.github.io/data/GCF_000001735.4_TAIR10.1_genomic.fna.gz
gunzip GCF_000001735.4_TAIR10.1_genomic.fna.gz
```

### 3. Explore File Contents

```bash
MYFILE="GCF_000001735.4_TAIR10.1_genomic.fna"
```

**1) How many sequences are in the FASTA file? (answer=7)**

```bash
grep "^>" data/$MYFILE | wc -l
```

**2) What is the total number of nucleotides (not including header lines or newlines)? (answer=119,668,634)**

```bash
cat data/$MYFILE | grep -v "^>" | tr -d '\n' | wc -m
```

**3) How many total lines are in the file? (answer=14)**

```bash
cat data/$MYFILE  | wc -l
```

**4) How many header lines contain the word "mitochondrion"? (answer=1)**

```bash
cat data/$MYFILE | grep "^>" | grep "mitochondrion" | wc -l
```

**5) How many header lines contain the word "chromosome"? (answer=5)**

```bash
cat data/$MYFILE | grep "^>" | grep "chromosome" | wc -l
```

**6) How many nucleotides are in each of the first 3 chromosome sequences? (answer=30,427,672   19,698,290  23,459,831)**

```bash
cat data/$MYFILE | grep -v "^>" | head -1 | wc -m
cat data/$MYFILE | grep -v "^>" | tail -6 | head -1 | wc -m
cat data/$MYFILE | grep -v "^>" | tail -5 | head -1 | wc -m
```

**7) How many nucleotides are in the sequence for 'chromosome 5'? (answer=26,975,503)**

```bash
cat data/$MYFILE | grep -v "^>" | tail -3 | head -1 | wc -m
```

**8) How many sequences contain "AAAAAAAAAAAAAAAA"? (answer=1)**

```bash
grep "AAAAAAAAAAAAAAAA" data/$MYFILE | wc -l
```

**9) If you were to sort the sequences alphabetically, which sequence (header) would be first in that list? (answer=>NC_000932.1...)**

```bash
(sort <(cat data/$MYFILE | grep "^>" | grep ">")) | head -1
```

**10) How would you make a new tab-separated version of this file, where the first column is the headers and the second column are the associated sequences? (show the command(s))**

```bash
paste <(grep "^>" data/$MYFILE) <(grep -v "^>" data/$MYFILE) > combined.txt
```

## Reflection (300-600 words)

For each question, I found that the easiest approach was to 1), determine what specific pieces of information I needed in order to obtain the final answer, 2), determine what individual commands I needed in order to extract those pieces of information, and 3), determine in what order (and in what way) to stitch together the commands in order to process the relevant information and obtain a final answer. For example, to answer question 2 (outputting the total number of nucleotides), I first determined that I needed to filter for sequence lines (i.e., lines that were not headers) and then that I needed to use a word count (wc) related tool (wc with the -m flag gives character count) to count the characters. I stitched these together by piping the stdout of grep -v into wc -m. 

I often had to troubleshoot results that did not make sense. With question 2, for example, I obtained a nucleotide count that was too high, then realized that I needed to filter out the newline characters. Using the tr command (tr –help told me that I could use the -d flag to delete all the unwanted newlines), I added a newline-removal step that took the stdout of grep -v and sent the header-filtered, newline-removed stdout as stdin to wc -m. I learned that thinking about Unix commands in small chunks is effective and makes troubleshooting errors easier.

Sometimes I forgot to redirect an output to a specific file or command and was surprised when a long string of nucleotides spewed out onto my screen. This happened annoyingly often, but thankfully I was able to ^C out of it before I ran into any major problems. For example, for question 10, I accidentally ran paste <(grep "^>" data/$MYFILE) <(grep -v "^>" data/$MYFILE) without the > combined.txt telling it to paste into a specific file.

The skills in this assignment are essential for computational work because they allow the scientist to quickly extract information from large datasets and answer questions that would be impossible to answer via manual searching. One way to automate my solutions would be to create shortcuts for certain commonly-used tools and their specific uses. For example, grep -v “^>”, since I use it often, could potentially be encoded by a shorter word or code, similarly to aliases. On its own, this wouldn’t be great for reproducibility, but the README could have a specifying all the “shortcuts” so that the user could paste them in and run the code as-expected.

