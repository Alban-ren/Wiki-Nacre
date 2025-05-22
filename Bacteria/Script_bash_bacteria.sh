#!/usr/bin/env bash
set -euo pipefail

DIR="0.New_departure/PE_reads_RNA_Pn"
OUT="taxa_presence_absence_min10.tsv"
TMPDIR="tmp_taxa_counts_min10"
mkdir -p "$TMPDIR"

# 1. For each report_kraken_F* (with or without .txt)
for f in "$DIR"/report_kraken_F*; do
  # basename complet, ex. "report_kraken_F1.txt" or "report_kraken_F1"
  fbase=$(basename "$f")
  # removes the prefix
  sample=${fbase#report_kraken_}
  # remove extension if any
  sample=${sample%.txt}

  awk -F'\t' '
    {
      name = $6
      sub(/^[ \t]+/, "", name)   # enlève l’indentation
      print name "\t" $3         # $3 = reads directement assignés
    }
  ' "$f" > "$TMPDIR/$sample.tsv"
done

# 2. List of all taxa
cut -f1 "$TMPDIR"/*.tsv | sort -u > "$TMPDIR/all_taxa.txt"

# 3. Header
{
  printf "Taxon"
  for f in "$TMPDIR"/*.tsv; do
    printf "\t%s" "$(basename "$f" .tsv)"
  done
  echo
} > "$OUT"

# 4. Binary matrix (≥10 reads)
while read -r taxon; do
  printf "%s" "$taxon"
  for f in "$TMPDIR"/*.tsv; do
    count=$(awk -F'\t' -v t="$taxon" '$1==t{print $2}' "$f")
    [[ -z "$count" ]] && count=0
    [[ "$count" -ge 10 ]] && printf "\t1" || printf "\t0"
  done
  echo
done < "$TMPDIR/all_taxa.txt" >> "$OUT"

echo "Binary matrix (≥10 reads) generated : $OUT"
