
# README for Assigment 1

### 1. Setup
Create relevant assignment folders starting in SUPERCOMPUTING directory, which will contain the folder "assignments"
```bash
mkdir assignments
mkdir assignments/assignment_1
mkdir assignments/assignment_2 
```

### 2. Directory Structure
Add major directories. Note that none of these directories can be commited to Github until they contain placeholder files
```bash
mkdir assignments/assignment_1/data
mkdir assignments/assignment_1/scripts
mkdir assignments/assignment_1/results
mkdir assignments/assignment_1/docs
mkdir assignments/assignment_1/config
mkdir assignments/assignment_1/logs
```
Add relevant setup files: 
A gitignore file so that nothing crashes when we add large sequence data files
and an environment file to set up an environment and prevent conflicts with other projects. Note that .gitignore is hidden on terminal
```bash
touch assignments/assignment_1/.gitignore
touch assignments/assignment_1/environment.yml
```
Add markdown files
```bash
touch assignments/assignment_1/README.md
touch assignments/assignment_1/assignment_1_essay.md
```

### 3. Sub-directories
Add subdirectories for storing different relevant types of data in the data directory and for storing different possible results outputs in the results directory. I've included folders for raw and clean data and to store reference sequences and metadata
```bash
mkdir assignments/assignment_1/data/{raw,clean,references,metadata}
mkdir assignments/assignment_1/results/{figures,tables}
```

### 4. Placeholder files