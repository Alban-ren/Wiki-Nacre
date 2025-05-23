#!/bin/bash
set -euo pipefail

DIR="/home/stephane/Documents/kraken2/results"
TMPDIR="/home/stephane/Documents/kraken2/results/tmp_taxa_abundance"
OUT="taxa_abundance_absolute_top50_families.tsv"
OUT_NORM="taxa_abundance_normalized_top50_families.tsv"

# Check that awk is available
if ! command -v awk &> /dev/null; then
  echo "Erreur : awk n'est pas installé." >&2
  exit 1
fi

# Cleaning and creating a temporary folder
rm -rf "$TMPDIR"
mkdir -p "$TMPDIR"

# 1. For each sample, extract the families (F) and their counts
for f in "$DIR"/report_kraken_F*.txt; do
  sample=$(basename "$f" .txt | sed 's/^report_kraken_//')
  # TaxID and count extraction
  awk -F'\t' '$4=="F" {print $5"\t"$2}' "$f" \
    | sort | uniq -c \
    | awk '{print $2"\t"$1}' > "$TMPDIR/$sample.tsv"
done

# 2. Calculate total abundance of each family (all samples)
awk '{tot[$1]+=$2} END{for(f in tot) print f, tot[f]}' "$TMPDIR"/*.tsv \
  | sort -k2,2nr > "$TMPDIR/all_families_totals.txt"

# 3. Selection of top 50 families
head -n 50 "$TMPDIR/all_families_totals.txt" | cut -d' ' -f1 > "$TMPDIR/top50_families.txt"

# 4. Absolute abundance matrix
{
  printf "Taxon"
  for f in "$TMPDIR"/*.tsv; do printf "\t%s" "$(basename "$f" .tsv)"; done
  echo
} > "$OUT"

while read -r fam; do
  printf "%s" "$fam"
  for f in "$TMPDIR"/*.tsv; do
    count=$(awk -F'\t' -v fam="$fam" '$1==fam{print $2}' "$f")
    # If count empty or non-numeric, force to 0
    if ! [[ $count =~ ^[0-9]+$ ]]; then count=0; fi
    printf "\t%s" "$count"
  done
  echo

done < "$TMPDIR/top50_families.txt" >> "$OUT"

# Other” line
printf "Autres" >> "$OUT"
for f in "$TMPDIR"/*.tsv; do
  total=$(awk '{s+=$2} END{print s}' "$f")
  top50sum=$(awk -v file="$f" 'NR==FNR{top[$1]; next}($1 in top){sum+=$2} END{print sum}' \
    "$TMPDIR/top50_families.txt" "$f")
  # Digital verification
  if ! [[ $total =~ ^[0-9]+$ ]]; then total=0; fi
  if ! [[ $top50sum =~ ^[0-9]+$ ]]; then top50sum=0; fi
  autres=$((total - top50sum))
  printf "\t%s" "$autres"
done >> "$OUT"

echo " Abondance absolue (top50 + Autres) écrite dans $OUT"

# 5. Normalized abundance matrix
{
  printf "Taxon"
  for f in "$TMPDIR"/*.tsv; do printf "\t%s" "$(basename "$f" .tsv)"; done
  echo
} > "$OUT_NORM"

while read -r fam; do
  printf "%s" "$fam"
  for f in "$TMPDIR"/*.tsv; do
    total=$(awk '{s+=$2} END{print s}' "$f")
    count=$(awk -F'\t' -v fam="$fam" '$1==fam{print $2}' "$f")
    # Digital force
    if ! [[ $total =~ ^[0-9]+$ ]]; then total=0; fi
    if ! [[ $count =~ ^[0-9]+$ ]]; then count=0; fi
    # Calculation normalized via awk to guarantee float format with 0 before the decimal point
    norm=$(awk -v c="$count" -v t="$total" 'BEGIN{ if(t==0) printf "0.0000"; else printf "%.4f", c/t }')
    printf "\t%s" "$norm"
  done
  echo

done < "$TMPDIR/top50_families.txt" >> "$OUT_NORM"

# Standardized “Other” line
printf "Autres" >> "$OUT_NORM"
for f in "$TMPDIR"/*.tsv; do
  total=$(awk '{s+=$2} END{print s}' "$f")
  top50sum=$(awk -v file="$f" 'NR==FNR{top[$1]; next}($1 in top){sum+=$2} END{print sum}' \
    "$TMPDIR/top50_families.txt" "$f")
  if ! [[ $total =~ ^[0-9]+$ ]]; then total=0; fi
  if ! [[ $top50sum =~ ^[0-9]+$ ]]; then top50sum=0; fi
  autres=$((total - top50sum))
  # Norm via awk
  norm=$(awk -v c="$autres" -v t="$total" 'BEGIN{ if(t==0) printf "0.0000"; else printf "%.4f", c/t }')
  printf "\t%s" "$norm"
done >> "$OUT_NORM"

echo " Abondance normalisée (top50 + Autres) écrite dans $OUT_NORM"
