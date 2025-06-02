

Based on the alignment results obtained with DIAMOND, a filtering step is performed using Seqkit within a [Bash script](../Scripts/Script_TLRs.sh) to extract only the identifiers (IDs) of proteins annotated with the term “toll-like receptor.” These identifiers are then cross-referenced with transcriptomic annotations from BRAKER3, allowing the corresponding RNA sequences of TLRs to be retrieved and compiled into a single file.

This Bash script is designed to automatically extract RNA transcripts corresponding to Toll-like receptors (TLRs) using results from both DIAMOND functional annotation and BRAKER3 structural annotation. It begins by filtering the DIAMOND output file (diamond_output.tsv) to retain only entries annotated as "toll-like receptor", saving the corresponding protein IDs.

These protein IDs are then matched against the BRAKER3 GTF annotation file to retrieve the associated transcript IDs. Finally, using seqkit, the script extracts the RNA transcript sequences from a global FASTA file, saving them into a final output file (TLR_transcripts.fa). 

This pipeline provides a fast and efficient way to isolate TLR-related sequences from complex transcriptomic datasets.
