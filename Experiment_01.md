## Experiment Script

- Percentage of contaminated sequences
kraken2 --db kraken2/kraken2_custom_db/ --use-names --threads 30 --confidence 0.01 --report 0.New_departure/PE_reads_RNA_Pn/kraken_report_4_Pn_haemocytes.txt --output 0.New_departure/PE_reads_RNA_Pn/kraken_output_4_haemocytes.txt 0.New_departure/PE_reads_RNA_Pn/SRR21820831

- filtering of “classified” sequences
awk -F’\t’ ‘$1==”C” ‘kraken_output_4_Pn_haemocytes.txt > kraken_output_4_Pn_haemocytes_C.txt

- Extract bacteria names from the file and put them in another file
cut -f 2 kraken_output_4_Pn_haemocytes_C.txt > reads_4_Pn_haemocytes_toremove.txt

- Extraction of bacteria from the P. nobilis transcriptome
Seqkit grep -v -f reads_4_Pn_haemocytes_toremove.txt SRR21820831.fastq -o 4_Pn_haemocytes_RNA_filtered_fastq

- Transcriptome quality
fastqc 4_Pn_haemocytes_RNA_filtered_fastq

- unreliable data breakdown
trimmomatic ? code  -> oui

- galaxy 
