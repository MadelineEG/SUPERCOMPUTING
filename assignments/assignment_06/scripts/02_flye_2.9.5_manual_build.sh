#!/bin/bash
set -ueo pipefail

# cd into programs directory
cd ~/programs

# clone and build Flye if it doesn't already exist
if [ ! -d ~/programs/"Flye" ]; then
        cd ~/programs
        git clone https://github.com/fenderglass/Flye
        cd Flye
        make
        echo 'export PATH="$HOME/programs/Flye/bin:$PATH"' >> ~/.bashrc
fi

# cd back to original directory
cd ~/SUPERCOMPUTING/assignments/assignment_06
