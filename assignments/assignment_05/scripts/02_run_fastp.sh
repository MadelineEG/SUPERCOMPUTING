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
