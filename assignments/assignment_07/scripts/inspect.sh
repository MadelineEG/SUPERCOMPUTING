#!/bin/bash

cd ./output

echo -e "Sample ID\tTotal Reads\tDog-Mapped Reads" > matches-summary.tsv

paste -d '\t' <(for i in *_dog-matches.sam;do echo ${i/_dog-matches.sam/};done) \
	<(for i in *_dog-matches.sam;do grep -c "^SRR" ${i/_dog-matches.sam/.sam};done) \
	<(for i in *_dog-matches.sam;do grep -c "^SRR" $i;done) \
	>> matches-summary.tsv

cd ..

cat ./output/matches-summary.tsv
