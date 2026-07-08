# Assignment Week02
## 1
Apteryx owenii (Little Spotted kiwi)
Small flightless bird in the kiwi family

## 2 
Command:
micromamba activate bioinfo
cd ~/edu/bioinfo-projects/week02
wget https://ftp.ensembl.org/pub/current_gff3/apteryx_owenii/Apteryx_owenii.aptOwe1.116.gff3.gz
ls
Output: 
Apteryx_owenii.aptOwe1.116.gff3.gz

Command: 
gunzip Apteryx_owenii.aptOwe1.116.gff3.gz
ls
Output:
Apteryx_owenii.aptOwe1.116.gff3

Command:
cat Apteryx_owenii.aptOwe1.116.gff3 | head   
Output:
##gff-version 3
##sequence-region   PTFC01000001.1 1 17302385
##sequence-region   PTFC01000002.1 1 15230537
##sequence-region   PTFC01000003.1 1 11796731
##sequence-region   PTFC01000004.1 1 9503414
##sequence-region   PTFC01000005.1 1 8974325
##sequence-region   PTFC01000006.1 1 7808292
##sequence-region   PTFC01000007.1 1 7741487
##sequence-region   PTFC01000008.1 1 7634977
##sequence-region   PTFC01000009.1 1 6795204
(bioinfo) 

Command: 
cat Apteryx_owenii.aptOwe1.116.gff3 | grep '^##sequence-region' | wc -l
Output: 
5096
Explanation:
5096 sequence regions do not equal to 5096 complete chromosomes. The genome assembly contains many scaffolds.

## 3 
Command:
cat Apteryx_owenii.aptOwe1.116.gff3 | grep -v '^#' | wc -l
Output:
898837

## 4 
Command:
cat Apteryx_owenii.aptOwe1.116.gff3 | grep -v '^#' | cut -f 3 | sort | uniq -c
Output:
334633 CDS
130019 biological_region
352046 exon
15853 five_prime_UTR
16196 gene
3169 lnc_RNA
28116 mRNA
 102 miRNA
2640 ncRNA_gene
  58 pseudogene
  58 pseudogenic_transcript
  51 rRNA
5096 region
  18 scRNA
  79 snRNA
 215 snoRNA
10335 three_prime_UTR
 153 transcript
Find gene: 16196 

or
cat Apteryx_owenii.aptOwe1.116.gff3 | cut -f 3 | grep '^gene$' | wc -l

## 5
CDS: Protein Coding Sequence 
CDS (Coding sequence) is a sequence of nucleotides that corresponds to the sequence of amino acids in a protein.

## 6 
Command:
cat Apteryx_owenii.aptOwe1.116.gff3 | grep -v '^#' | cut -f 3 | sort | uniq -c | sort -nr | head

Output:
352046 exon
334633 CDS
130019 biological_region
28116 mRNA
16196 gene
15853 five_prime_UTR
10335 three_prime_UTR
5096 region
3169 lnc_RNA
2640 ncRNA_gene

## 7 & 8
After analyzing the GFF file, it seems to be a well-annotated organism because it contains 898,837 annotated features and 16,196 genes. However, the genome assembly is fragmented into many scaffolds because it contains 5,096 sequence regions. Protein-coding regions make up a large part of the annotation.