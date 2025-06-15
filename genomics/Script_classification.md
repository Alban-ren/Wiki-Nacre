## Bioinformatic processing of raw reads: taxonomic classification and exclusion

The Bash pipeline presented below aims to perform a taxonomic filtering of reads derived from high-throughput RNA sequencing (ILLUMINA). First, the Kraken2 tool is used with a custom database composed of bacterial taxa in order to assign a taxonomic classification to the reads. The assigned reads (indicated by the status 'C' for classified) are then filtered using the awk command, and their identifiers are extracted using the cut command. These identifiers are then used by the seqkit grep tool to exclude the corresponding reads from the original FASTQ file. This filtering step allows the retention of only unclassified reads, which are presumed to correspond to host-derived sequences.
* Experiment Script
  --
kraken2 --db kraken2/kraken2_custom_db/ --use-names --threads 30 --confidence 0.01 --report 0.New_departure/PE_reads_RNA_Pn/kraken_report_1_Pn_haemocytes.txt --output 0.New_departure/PE_reads_RNA_Pn/kraken_output_1_haemocytes.txt 0.New_departure/PE_reads_RNA_Pn/SRR21820831

awk -F’\t’ ‘$1==”C” ‘kraken_output_1_Pn_haemocytes.txt > kraken_output_1_Pn_haemocytes_C.txt

cut -f 2 kraken_output_1_Pn_haemocytes_C.txt > reads_1_Pn_haemocytes_toremove.txt

Seqkit grep -v -f reads_1_Pn_haemocytes_toremove.txt SRR21820831.fastq -o 1_Pn_haemocytes_RNA_filtered_fastq

fastqc 1_Pn_haemocytes_RNA_filtered_fastq

