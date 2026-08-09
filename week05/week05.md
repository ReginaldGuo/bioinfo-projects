# Week05 Sequencing Pipeline

## Week04 Previous Code

```bash
# The URL of the gff3 file
URL="ftp://..."

GFF="polar_bear.gff"

GENES="genes.gff"

if [ ! -f ${GFF} ]; then
    wget ${URL} -O ${GFF}.gz
fi

gunzip -k ${GFF}.gz

cat ${GFF} | awk '$3=="gene"' > ${GENES}
```


## Week05 Code

### Dataset

```bash
SRR="SRR1972976"
GENOME="../week04/ebola.fna"
```


### Genome size

```bash
seqkit stats ${GENOME}
```


### Download reads

```bash
mkdir -p reads

fastq-dump \
-X 2000 \
-F \
--outdir reads \
--split-files ${SRR}
```


### Quality control

```bash
fastqc reads/*.fastq -o fastqc
```


### Trimming

```bash
fastp \
-i reads/${SRR}_1.fastq \
-I reads/${SRR}_2.fastq \
-o trimmed/${SRR}_1.trimmed.fastq \
-O trimmed/${SRR}_2.trimmed.fastq
```