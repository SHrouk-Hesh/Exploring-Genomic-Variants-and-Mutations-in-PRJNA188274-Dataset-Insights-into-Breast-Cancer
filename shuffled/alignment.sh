#!/bin/bash

# Loop over the input files
for i in /home/bioinformaticsnu/bio-labs/project_2/shuffled-and-trimmed/trimmed; do
bwa mem -t 4 GRCh38_chr22.fa $i > $i.sam

done
