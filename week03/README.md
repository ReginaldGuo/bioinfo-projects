
# Assignment for week 03
**micromamba activate bioinfo**
**cd  ~/edu/bioinfo-projects/week03**
 **wget https://ftp.ensemblgenomes.ebi.ac.uk/pub/bacteria/current/fasta/bacteria_1_collection/acetonema_longum_dsm_6540_gca_000219125/dna/Acetonema_longum_dsm_6540_gca_000219125.ASM21912v1_.dna.toplevel.fa.gz**
 **ls**
    Acetonema_longum_dsm_6540_gca_000219125.ASM21912v1_.dna.toplevel.fa.gz
    README.md
**gunzip Acetonema_longum_dsm_6540_gca_000219125.ASM21912v1_.dna.toplevel.fa.gz**
**mv Acetonema_longum_dsm_6540_gca_000219125.ASM21912v1_.dna.toplevel.fa Ald.fa**
**ls**

```bash   
seqkit stats Ald.fa
```

Output: 
    text
    file    format  type  num_seqs    sum_len  min_len  avg_len  max_len
    Ald.fa  FASTA   DNA        296  4,323,011      209  14,604.8  223,575
The genome is 4,323,011 bp long and consists of 296 contigs.
```bash
grep -v '^#' Ald.gff | cut -f 3 | sort | uniq -c | sort -nr
```
Output:
    4107 exon 
    4047 mRNA
    4047 gene
    4047 CDS
    296 region
    60 ncRNA_gene
    60 ncRNA
**grep $'\tgene\t' Ald.gff > gene.gff**
Check: wc -l gene.gff

ATG (methionine, M) is the most common start codon and usually initiates translation. To identify the correct protein sequence, the correct reading frame must be selected. For genes on the reverse strand, IGV displays the forward reference sequence, so the reverse-complement strand (or the complementary bases) must be used to view the correct translation.