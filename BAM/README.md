# Ebola Virus Read Alignment with BWA

## Overview

This project demonstrates a basic bioinformatics workflow for aligning short sequencing reads to a reference genome.

The workflow uses a Makefile to automate the following steps:

1. Download an Ebola virus reference genome.
2. Download paired-end sequencing reads from the Sequence Read Archive (SRA).
3. Index the reference genome using BWA.
4. Align sequencing reads to the reference genome.
5. Generate a sorted and indexed BAM file.
6. Calculate alignment and coverage statistics.
7. Visualize the alignment and coverage using IGV.

The purpose of this project is to learn how sequencing reads are aligned to a reference genome and how alignment quality and sequencing coverage can be evaluated.

---

## Data

### Reference Genome

The reference genome used in this project is an Ebola virus genome.

- Accession: `AF086833`
- Name used in this project: `ebola-1976`
- Genome length: **18,959 bp**

The reference genome is stored as:

```text
refs/ebola-1976.fa
```

### Sequencing Reads

Sequencing reads were downloaded from SRA:

```text
SRR1972739
```

A subset of **10,000 paired-end spots** was downloaded.

The resulting FASTQ files were:

```text
reads/SRR1972739_1.fastq
reads/SRR1972739_2.fastq
```

`seqkit stats` showed:

| File | Number of reads | Total length | Average read length |
|---|---:|---:|---:|
| R1 | 10,000 | 1,010,000 bp | 101 bp |
| R2 | 10,000 | 1,010,000 bp | 101 bp |

Therefore, the dataset contains:

```text
20,000 reads
```

and:

```text
2,020,000 sequenced bases
```

in total.

---

## Software

The following tools were used:

- `bio`
- `SRA Toolkit`
- `seqkit`
- `BWA`
- `samtools`
- `IGV`
- `make`

---

## Project Structure

```text
BAM/
├── Makefile
├── README.md
├── refs/
│   └── ebola-1976.fa
├── reads/
│   ├── SRR1972739_1.fastq
│   └── SRR1972739_2.fastq
├── bam/
│   ├── SRR1972739.bam
│   └── SRR1972739.bam.bai
└── stats/
    └── SRR1972739_depth.txt
```

---

# Makefile

The analysis is automated using a Makefile.

The major targets are:

```text
refs
fastq
index
align
stats
all
clean
```

The dependency structure is approximately:

```text
all
 |
stats
 |
align
 /   \
index fastq
 |
refs
```

This allows `make` to run the required steps in the appropriate order.

---

## Download the Reference Genome

The reference genome can be downloaded using:

```bash
make refs
```

The Makefile runs:

```bash
bio fetch AF086833 --format fasta > refs/ebola-1976.fa
```

Genome statistics can be examined using:

```bash
seqkit stats refs/ebola-1976.fa
```

The reference contains one sequence with a total length of:

```text
18,959 bp
```

---

## Download Sequencing Reads

The sequencing reads can be downloaded using:

```bash
make fastq
```

The Makefile downloads 10,000 SRA spots using:

```bash
fastq-dump \
    -X 10000 \
    --outdir reads \
    --split-files \
    SRR1972739
```

Because the experiment uses paired-end sequencing, two FASTQ files are produced:

```text
SRR1972739_1.fastq
SRR1972739_2.fastq
```

Each SRA spot produces a Read 1 and a Read 2.

Therefore:

```text
10,000 read pairs
=
20,000 individual reads
```

---

# Reference Genome Indexing

Before alignment, the reference genome is indexed using BWA:

```bash
make index
```

The underlying command is:

```bash
bwa index refs/ebola-1976.fa
```

Indexing allows BWA to efficiently search the reference genome when determining where sequencing reads align.

---

# Read Alignment

Reads are aligned using:

```bash
make align
```

The major alignment command is:

```bash
bwa mem -t 4 \
    refs/ebola-1976.fa \
    reads/SRR1972739_1.fastq \
    reads/SRR1972739_2.fastq |
    samtools sort > bam/SRR1972739.bam
```

The workflow can be represented as:

```text
FASTQ R1 ──┐
           ├──> BWA MEM ──> SAM ──> samtools sort ──> BAM
FASTQ R2 ──┘
```

`bwa mem` determines where the sequencing reads align to the reference genome.

The `-t 4` option allows BWA to use four computational threads.

The alignment output is passed directly to:

```text
samtools sort
```

which sorts the alignments according to their genomic coordinates.

The resulting BAM file is:

```text
bam/SRR1972739.bam
```

---

# BAM Indexing

After sorting, the BAM file is indexed using:

```bash
samtools index bam/SRR1972739.bam
```

This produces:

```text
bam/SRR1972739.bam.bai
```

The `.bai` file is an index of the BAM file.

It allows programs such as IGV and samtools to quickly access alignments from a specific genomic region without reading the entire BAM file.

---

# Alignment Statistics

Alignment statistics were generated using:

```bash
samtools flagstat bam/SRR1972739.bam
```

The important output included:

```text
20740 + 0 in total
20000 + 0 primary
15279 + 0 mapped (73.67%)
14539 + 0 primary mapped (72.69%)
20000 + 0 paired in sequencing
10000 + 0 read1
10000 + 0 read2
14480 + 0 properly paired (72.40%)
```

## Percentage of Reads Aligned

There were:

```text
20,000 primary reads
```

and:

```text
14,539 primary mapped reads
```

Therefore:

```text
14,539 / 20,000 × 100
=
72.69%
```

Approximately **72.69% of primary reads aligned to the reference genome**.

The `flagstat` output also reports 73.67% mapped when supplementary alignment records are included.

---

# Expected Average Coverage

Sequencing coverage describes how many times, on average, each nucleotide in the reference genome is represented by sequencing reads.

The total amount of sequencing data was:

```text
R1 = 1,010,000 bp
R2 = 1,010,000 bp
```

Therefore:

```text
Total sequenced bases
=
1,010,000 + 1,010,000
=
2,020,000 bp
```

The reference genome length was:

```text
18,959 bp
```

Expected average coverage is:

```text
Expected coverage
=
Total sequenced bases / Genome length

=
2,020,000 / 18,959

≈ 106.55×
```

Therefore, the expected average coverage was approximately:

**106.55×**

This calculation assumes that all sequenced bases successfully align to the reference genome.

---

# Observed Average Coverage

Actual coverage was calculated using:

```bash
samtools depth -a bam/SRR1972739.bam
```

This command reports the sequencing depth at every position of the reference genome.

For example, conceptually:

```text
reference    position    depth
AF086833     1           45
AF086833     2           46
AF086833     3           48
...
```

Average depth was calculated using:

```bash
samtools depth -a bam/SRR1972739.bam |
awk '{sum += $3} END {print sum/NR}'
```

The result was:

```text
Observed average coverage: 76.3471
```

Therefore, the observed average coverage was approximately:

**76.35×**

This means that each nucleotide in the Ebola reference genome was covered by approximately 76 aligned sequencing reads on average.

---

# Expected vs. Observed Coverage

The expected coverage was:

```text
106.55×
```

while the observed coverage was:

```text
76.35×
```

The observed coverage is lower because not every sequencing read successfully aligned to the reference genome.

The primary mapping rate was approximately:

```text
72.69%
```

A rough prediction based on the mapping rate is:

```text
106.55 × 0.7269 ≈ 77.45×
```

This is close to the observed value of:

```text
76.35×
```

The remaining difference may result from factors such as partial alignments and soft-clipped bases.

---

# Alignment Rate vs. Coverage

Alignment rate and sequencing coverage describe different properties of the sequencing experiment.

### Alignment Rate

Alignment rate asks:

> What fraction of sequencing reads could be aligned to the reference genome?

For this dataset:

```text
Primary mapping rate = 72.69%
```

### Coverage

Coverage asks:

> How many sequencing reads cover each position of the reference genome?

For this dataset:

```text
Observed average coverage = 76.35×
```

Therefore, alignment percentage and sequencing coverage should not be interpreted as the same measurement.

---

# Coverage Variation Across the Genome

Coverage at individual genome positions was generated using:

```bash
samtools depth -a bam/SRR1972739.bam \
    > stats/SRR1972739_depth.txt
```

The IGV coverage track shows that sequencing depth is not uniform across the genome.

Some regions have relatively low coverage, while other regions have substantially higher coverage.

The IGV scale in the whole-genome visualization reached approximately:

```text
0–163×
```

while the calculated average was:

```text
76.35×
```

This indicates substantial variation in sequencing depth across different genomic regions.

---

# IGV Visualization

The alignment was visualized using the Integrative Genomics Viewer (IGV).

The following files were loaded:

```text
refs/ebola-1976.fa
bam/SRR1972739.bam
```

The BAM index:

```text
bam/SRR1972739.bam.bai
```

allows IGV to efficiently access different regions of the alignment.

---

## Understanding the IGV Display

IGV can be interpreted from top to bottom.

### 1. Genome Coordinates

The ruler at the top shows the position within the reference genome.

For example:

```text
2,200 bp
2,400 bp
2,600 bp
```

These numbers indicate genomic coordinates.

### 2. Coverage Track

The histogram above the read alignments represents sequencing depth.

Higher peaks indicate positions covered by more sequencing reads.

Lower regions indicate positions with fewer aligned reads.

### 3. Alignment Track

Each horizontal block represents an individual sequencing read aligned to the reference genome.

Reads occur at different positions because each read originated from a different fragment of the sequenced sample.

### 4. Read Direction

Arrow-like shapes indicate the orientation of reads relative to the reference genome.

Reads may align to either the forward or reverse strand.

### 5. Colored Bases

Gray portions generally represent bases that agree with the reference under the selected IGV display settings.

Colored bases can indicate differences between an aligned read and the reference sequence.

These differences may result from biological sequence variation, sequencing errors, alignment uncertainty, or other causes.

Therefore, a colored base should not automatically be interpreted as a true mutation.

---

# Interpreting the Zoomed IGV Region

When zooming into approximately the 2.2–2.6 kb region, individual aligned reads become visible.

The visualization demonstrates that:

- reads overlap one another at many positions;
- sequencing depth varies across the region;
- some genomic positions show colored mismatches;
- individual reads begin and end at different genomic coordinates;
- reads can align in different orientations.

The coverage histogram increases toward part of this region, demonstrating how local sequencing depth can differ from the genome-wide average.

This illustrates why an average coverage value such as 76.35× does not mean that every nucleotide is covered exactly 76 times.

---

# Running the Complete Workflow

The entire workflow can be executed using:

```bash
make all
```

The Makefile follows the dependency chain:

```text
reference
   ↓
reference index

SRA
 ↓
FASTQ
   ↓
alignment
   ↓
sorted BAM
   ↓
BAM index
   ↓
alignment statistics
   ↓
coverage statistics
```

---

# Cleaning Generated Files

Generated files can be removed using:

```bash
make clean
```

This allows the workflow to be recreated from the beginning.

---

# Key Concepts Learned

This project demonstrates several important concepts in bioinformatics:

### FASTA

FASTA stores reference nucleotide sequences.

### FASTQ

FASTQ stores sequencing reads together with sequencing quality information.

### Read

A read is a sequence of nucleotides measured by a sequencing instrument.

In this dataset, each read was:

```text
101 bp
```

long.

### Paired-End Sequencing

Each sequenced fragment is read from both ends, producing:

```text
Read 1 (R1)
Read 2 (R2)
```

### Alignment

Alignment determines where sequencing reads most likely originated within a reference genome.

### SAM/BAM

SAM stores sequence alignments in a text representation.

BAM is the binary representation commonly used for efficient storage and downstream analysis.

### BAM Index

The `.bai` file allows rapid access to specific genomic regions in a BAM file.

### Alignment Rate

The alignment rate measures the fraction of reads that successfully map to the reference genome.

### Coverage

Coverage measures how many aligned reads cover a particular genomic position.

### Average Coverage

Average coverage is the average sequencing depth across the reference genome.

---

# Summary

In this project, 10,000 paired-end SRA spots produced 20,000 sequencing reads containing a total of 2,020,000 sequenced bases.

The reads were aligned against an Ebola virus reference genome of 18,959 bp using BWA MEM.

The primary read mapping rate was:

**72.69%**

The expected average sequencing coverage was approximately:

**106.55×**

The observed average sequencing coverage was:

**76.35×**

IGV visualization demonstrated that coverage was not uniform across the reference genome and allowed individual sequencing reads and sequence differences relative to the reference to be visually inspected.