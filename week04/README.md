# Assignment for week 04
```micromamba activate bioinfo```
```cd ~/edu/bioinfo-projects/```
```mkdir week04```
```cd ~/edu/bioinfo-projects/week04```
# Genome assembly accession from the assigned paper
```ACC="GCF_000848505.1"```
```datasets summary genome accession "$ACC" | jq```
New version of client (18.33.1) available at https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/mac/datasets.
{
  "reports": [
    {
      "accession": "GCF_000848505.1",
      "annotation_info": {
        "name": "Annotation submitted by NCBI RefSeq",
        "provider": "NCBI RefSeq",
        "release_date": "2018-08-13",
        "stats": {
          "gene_counts": {
            "protein_coding": 7,
            "total": 7
          }
        }
      },
      "assembly_info": {
        "assembly_level": "Complete Genome",
        "assembly_name": "ViralProj14703",
        "assembly_status": "current",
        "assembly_type": "haploid",
        "paired_assembly": {
          "accession": "GCA_000848505.1",
          "annotation_name": "Annotation submitted by Institute of Virology, Philipps-University Marburg",
          "status": "current"
        },
        "release_date": "2000-09-15",
        "submitter": "Institute of Virology, Philipps-University Marburg"
      },
      "assembly_stats": {
        "atgc_count": "18959",
        "contig_l50": 1,
        "contig_n50": 18959,
        "gc_count": "7787",
        "gc_percent": 41,
        "number_of_component_sequences": 1,
        "number_of_contigs": 1,
        "number_of_scaffolds": 1,
        "scaffold_l50": 1,
        "scaffold_n50": 18959,
        "total_number_of_chromosomes": 1,
        "total_sequence_length": "18959",
        "total_ungapped_length": "18959"
      },
      "current_accession": "GCF_000848505.1",
      "organism": {
        "infraspecific_names": {
          "isolate": "Ebola virus/H.sapiens-tc/COD/1976/Yambuku-Mayinga"
        },
        "organism_name": "Zaire ebolavirus",
        "tax_id": 186538
      },
      "paired_accession": "GCA_000848505.1",
      "source_database": "SOURCE_DATABASE_REFSEQ",
      "type_material": {
        "type_display_text": "ICTV species exemplar",
        "type_label": "TYPE_ICTV"
      }
    }
  ],
  "total_count": 1
}

```datasets download genome accession "$ACC" --include genome,gff3,gtf```
```unzip -n ncbi_dataset.zip```

# Determine the genome size and count the number of features of each type in the GFF file

```mv stats ncbi_dataset/data/GCF_000848505.1/GCF_000848505.1_ViralProj14703_genomic.fna ebola.fna```
```seqkit stats ncbi_dataset/data/GCF_000848505.1/GCF_000848505.1_ViralProj14703_genomic.fna```
file       format  type  num_seqs  sum_len  min_len  avg_len  max_len
ebola.fna  FASTA   DNA          1   18,959   18,959   18,959   18,959
Genome size 18,959
```grep -v '^#' ebola.gff | cut -f3 | sort | uniq -c | sort -nr```
11 CDS
   8 regulatory_region
   8 polyA_signal_sequence
   7 mRNA
   7 gene
   7 exon
   4 sequence_feature
   1 three_prime_UTR
   1 region
   1 five_prime_UTR

```bash
awk -F '\t' '
$0 !~ /^#/ && $3=="gene" {
    len=$5-$4+1
    print len "\t" $9
}' ebola.gff | sort -nr | head -1
```
6782	ID=gene-ZEBOVgp7;Dbxref=GeneID:911824;Name=L;gbkey=Gene;gene=L;gene_biotype=protein_coding;locus_tag=ZEBOVgp7

The longest gene is L, with a genomic length of 6782 bp. The L gene encodes the viral RNA-dependent RNA polymerase (RdRp), also known as the Large (L) protein. This enzyme is responsible for replicating the viral RNA genome and transcribing viral mRNAs. It plays an essential role in Ebola virus replication and is required for the production of new virus particles.

# Pick another gene, and describe its name and function
1453	ID=gene-ZEBOVgp5;Dbxref=GeneID:911826;Name=VP30;gbkey=Gene;gene=VP30;gene_biotype=protein_coding;locus_tag=ZEBOVgp5
VP30 encodes a viral transcription activator that is required for efficient transcription of Ebola virus genes. It works with the L protein and VP35 to regulate viral mRNA synthesis and plays an essential role in virus replication
# Examine the distribution of genomic features: Are they closely packed or is there significant intergenic space?
The genomic features are closely packed, with very little intergenic space between adjacent genes. In IGV, the seven protein-coding genes (NP, VP35, VP40, GP, VP30, VP24, and L) are arranged almost continuously across the 18.9 kb genome, with only short non-coding regions separating them. This compact organization is typical of RNA viruses and maximizes the coding capacity of the small viral genome.
# Using IGV, estimate what proportion of the genome is covered by coding sequences.
Approximately 85–90% of the genome is covered by coding sequences.


GCA_900007085.1
Isolation from different times can be used to track mutation of the strain.











