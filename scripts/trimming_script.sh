#!/bin/bash

# Set the path to the adapters file

sudo yum install java-1.8.0-openjdk



brew cask install java
adap="$CONDA_PREFIX/share/trimmomatic-0.39-1.adapters"

# Set the path to the output directory
#output_dir="/home/bioinformaticsnu/bio-labs/project_2/shuffled/output"

# Loop over the input files
for input_file in ./*.fastq.gz; do

  # Get the base name of the input file
  base_name=$(basename "$input_file" .fastq.gz)

  # Create the output file name
  output_file="${base_name}_trimmed.fastq.gz"

  # Run Trimmomatic
trimmomatic SE -phred33 \
    "$input_file" \
    "$output_file" \
    ILLUMINACLIP:"$adapters_path":2:30:10 \
    LEADING:3 \
    TRAILING:3 \
    SLIDINGWINDOW:4:15 \
    MINLEN:36

done
