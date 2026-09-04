# Makefile for aligning short reads with BWA

ACC=AF086833
NAME=ebola-1976
SRR=SRR1972739

REF=refs/${NAME}.fa
R1=reads/${SRR}_1.fastq
R2=reads/${SRR}_2.fastq
BAM=bam/${SRR}.bam
DEPTH=stats/${SRR}_depth.txt

N=10000

SHELL = bash
.ONESHELL:
.SHELLFLAGS = -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules


usage:
	@echo "#"
	@echo "# Usage: make [all|refs|fastq|index|align|stats|clean]"
	@echo "#"


refs:
	mkdir -p $(dir ${REF})
	bio fetch ${ACC} --format fasta > ${REF}
	seqkit stats ${REF}


fastq:
	mkdir -p $(dir ${R1})
	fastq-dump -X ${N} --outdir reads --split-files ${SRR}
	seqkit stats ${R1} ${R2}


index: refs
	bwa index ${REF}


align: index fastq
	mkdir -p $(dir ${BAM})
	bwa mem -t 4 ${REF} ${R1} ${R2} | \
		samtools sort > ${BAM}
	samtools index ${BAM}


stats: align
	mkdir -p $(dir ${DEPTH})

	# Alignment statistics
	samtools flagstat ${BAM}

	# Coverage at every genome position
	samtools depth -a ${BAM} > ${DEPTH}

	# Observed average coverage
	awk '{sum += $$3} END {print "Observed average coverage:", sum/NR}' ${DEPTH}


all: stats


clean:
	rm -rf refs reads bam stats


.PHONY: all refs fastq index align clean stats usage
