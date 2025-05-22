The script begins by activating strict execution options (set -euo pipefail) to ensure it halts in the event of an error, an undefined variable, or a failure in a pipeline. Three variables are then defined: the directory containing the Kraken2 files (DIR), the name of the final output file (OUT), and a temporary directory (TMPDIR) used to store intermediate results, which is created using mkdir -p.


In the first loop, the script iterates over all files starting with report_kraken_F in the directory defined by DIR. For each file, it extracts the sample name from the filename by removing the prefix and, if present, the .txt extension. Then, using the awk command, it extracts line by line the taxon name (field 6, after trimming leading spaces) and the number of reads directly assigned to that taxon (field 3) (Fig. 1). The result is saved as an individual .tsv file for each sample in the temporary directory.

![Capture d'écran 2025-05-22 120102](https://github.com/user-attachments/assets/76063d9b-04e9-4092-8348-24c9f87e99e0)

Figure 1 : example of a report file fragment


Next, the script compiles a unique list of all taxon names found in the .tsv files. This is done using cut to extract the names, followed by sorting and deduplication with sort -u. The final list is stored in all_taxa.txt.
In the third step, it generates the header of the presence/absence matrix by writing “Taxon” as the first column, followed by the names of the samples extracted from the .tsv files.
The fourth and main loop reads each listed taxon. For each sample, the script checks whether the taxon is present in the corresponding file and retrieves the associated read count. If the taxon is absent, the count is set to zero. If the read count is greater than or equal to 10, a “1” is recorded in the matrix cell; otherwise, a “0” is recorded. Each row thus represents a taxon, and each column corresponds to a sample.

Finally, at the end of the script, a message confirms that the binary presence/absence matrix has been successfully generated in the specified output file.





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

echo "✅ Binary matrix (≥10 reads) generated : $OUT"
