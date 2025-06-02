#!/bin/bash

# INPUT FILES 
# ============================
DIAMOND_RESULT="diamond_output.tsv"          # DIAMOND output in tabular format
BRAKER_GTF="braker3/augustus.hints.gtf"      # BRAKER3 annotation file (GTF format)
TRANSCRIPTS_FASTA="braker3/transcripts.fa"   # FASTA file with all transcript sequences
OUTPUT_IDS="TLR_protein_IDs.txt"
OUTPUT_TRANSCRIPTS="TLR_transcripts.fa"

# 1 - FILTER DIAMOND OUTPUT FOR 'toll-like receptor'
# ============================
echo "Filtering DIAMOND results for 'toll-like receptor'..."
grep -i 'toll-like receptor' "$DIAMOND_RESULT" | cut -f1 | sort -u > "$OUTPUT_IDS"


# 2 - MAP PROTEIN IDs TO TRANSCRIPT IDs USING GTF
# ============================
echo "Mapping protein IDs to transcript IDs using BRAKER3 GTF..."
TLR_TRANSCRIPT_IDS="TLR_transcript_IDs.txt"
grep -Ff "$OUTPUT_IDS" "$BRAKER_GTF" | grep 'transcript_id' | \
    sed -n 's/.*transcript_id "\([^"]\+\)".*/\1/p' | sort -u > "$TLR_TRANSCRIPT_IDS"

# 3 - EXTRACT TRANSCRIPT SEQUENCES
# ============================
echo "Extracting transcript sequences from FASTA..."
seqkit grep -f "$TLR_TRANSCRIPT_IDS" "$TRANSCRIPTS_FASTA" -o "$OUTPUT_TRANSCRIPTS"

echo " Extraction completed: $OUTPUT_TRANSCRIPTS"
