## Code explanation for Script_TLRs.sh
-------------------------------------------

This [Bash script](../Scripts/Script_TLRs.sh) is designed to automatically extract RNA transcripts corresponding to Toll-like receptors (TLRs) using results from both DIAMOND functional annotation and BRAKER3 structural annotation. It begins by filtering the [DIAMOND output file](../data/Annoted_DIAMOND.tsv) (diamond_output.tsv) to retain only entries annotated as "toll-like receptor", saving the corresponding protein IDs.

These protein IDs are then matched against the [BRAKER3 GTF annotation file](../data/Annoted_BRAKER3.txt) to retrieve the associated transcript IDs. Finally, using seqkit, the script extracts the RNA transcript sequences from a global FASTA file, saving them into a final output file (TLR_transcripts.fa). 

This pipeline provides a fast and efficient way to isolate TLR-related sequences from complex transcriptomic datasets.

The resulting coding sequences are then submitted to the SMART (Simple Modular Architecture Research Tool) bioinformatics platform, which enables the identification of functional domains within the proteins (fig.1).

![Capture d'écran 2025-06-02 105306](https://github.com/user-attachments/assets/c2f5ce9e-e09c-4c26-aef6-57062e56df57)

***Figure 1 : Example of 3 TLRs structured by SMART for Pinna nobilis***

The domain structures of TLRs from Pinna nobilis and Pinna rudis are then grouped into families based on their similarity and compared to the classification proposed by Gerdol et al. (2017). This classification is based on both a qualitative approach (organization and architecture of functional domains) and a quantitative one (number of domains per TLR).

