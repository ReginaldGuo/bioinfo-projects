
# Assignment for Week 01

## Samtools Version
Command:
    bash
conda activate bioinfo
samtools --version

Output:
    text
samtools 1.23.1
Using htslib 1.23.1
Copyright (C) 2025 Genome Research Ltd.

## Create Nested Directory Structure

Command:
    bash
mkdir -p project/data/raw
mkdir -p project/results/figures

## Create Files in Different Directories

Command:
    bash
touch project/data/raw/sample1.fastq
touch project/results/summary.txt

## Relative Path
Command:
    bash
cd week01
cat README.md

Explanation:
These commands use relative paths because they refer locations relative to the current directory.

## Absolute Path
Command:
    bash
cat /Users/reginald/edu/bioinfo-projects/week01/README.md

Explanation:
This command uses an absolute path because it specify the complete path from the root directory.

