# README for Assignment 3
``` text
Madeline Eibner-Gebhardt
Assignment 03
19 Feb, 2026
```

### 1. Setup
On local device, made an alias for the astral server login in .bashrc (from within home directly -- or, on another device, wherever .bashrc is located)

```text
alias astral="ssh mweibnergebhar@astral.sciclone.wm.edu"
```

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
# from within assignments/assignment_03:
cd data
```

```bash
MYFILE="GCF_000001735.4_TAIR10.1_genomic.fna"
```

**Note: Still need to figure out 6, 7, and 10**

**1) How many sequences are in the FASTA file? (answer=7)**

```bash
grep "^>" $MYFILE | wc -l
```

**2) What is the total number of nucleotides (not including header lines or newlines)? (answer=119,668,634)**

```bash
cat $MYFILE | grep -v "^>" | tr -d '\n' | wc -m
```

**3) How many total lines are in the file? (answer=14)**

```bash
cat $MYFILE  | wc -l
```

**4) How many header lines contain the word "mitochondrion"? (answer=1)**

may want to automate more by, e.g., storing all the header lines in a var that can access for multiple things below? -- actually, almost definitely am suposed to do this; discuss in reflection -- or maybe not, think abt it on Tuesday

```bash
cat $MYFILE | grep "^>" | grep "mitochondrion" | wc -l
```

**5) How many header lines contain the word "chromosome"? (answer=5)**

```bash
cat $MYFILE | grep "^>" | grep "chromosome" | wc -l
```

**6) How many nucleotides are in each of the first 3 chromosome sequences? (answer=30,427,672   19,698,290  23,459,831)**

still not certain how to effectively filter out \n

**7) How many nucleotides are in the sequence for 'chromosome 5'? (answer=26,975,503)**
**8) How many sequences contain "AAAAAAAAAAAAAAAA"? (answer=1)**

```bash
grep "AAAAAAAAAAAAAAAA" $MYFILE | wc -l
```

**9) If you were to sort the sequences alphabetically, which sequence (header) would be first in that list? (answer=>NC_000932.1...)**

```bash
(sort <(cat $MYFILE | grep "^>" | grep ">")) | head -1
```

**10) How would you make a new tab-separated version of this file, where the first column is the headers and the second column are the associated sequences? (show the command(s))**

Need to paste the below together somehow, not sure how or if did second part properly
```bash
(cat $MYFILE | grep "^>" | grep ">") > headers.txt
(cat $MYFILE | grep -v "^>") > sequences.txt
```

## Reflection (300-600 words)
Originally did cat GCF_000001735.4_TAIR10.1_genomic.fna | grep -v "^>" | grep -i "[atcgn]" | wc -m for 2 and got a count that included newlines

Had to learn some new sytax for grep (by looking in the help file) -- e.g., grep -i to make it case insensitive (noticed that some nts were capitalized and some not in the raw data)

also grep doesn't work for all apps bc line-based -- needed to use tr -d '\n' to filter out individual newline characters

For question 3, kept trying to use grep to obtain the number of lines -- realized that just doing wc -l on the file was simpler

grep -v "\n" didn't work

Realized that I could automate certain elements to a greater extent than I had been doing (e.g., turning the file name into an env var)

cat $MYFILE | grep -v "^>" cats lots of sequence data
or 
cat $MYFILE | grep "^>" 

cat $MYFILE | grep "^>" | grep ">" fixes the problem and just ouputs the header rows

paste <(cat $MYFILE | grep "^>" | grep ">") <(cat $MYFILE | grep -v "^>" | tr -d '\n') bad bc removed newlines, sent lots of stuff to screen (last question)

paste <(cat $MYFILE | grep "^>" | grep ">") <(cat $MYFILE | grep -v "^>") -- also sent lots of stuff to screen
