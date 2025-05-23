# code explanation for Script_binary_table.sh
--------------------------------------------
The script begins by activating strict execution options (set -euo pipefail) to ensure it halts in the event of an error, an undefined variable, or a failure in a pipeline. Three variables are then defined: the directory containing the Kraken2 files (DIR), the name of the final output file (OUT), and a temporary directory (TMPDIR) used to store intermediate results, which is created using mkdir -p.
In the first loop, the script iterates over all files starting with report_kraken_F in the directory defined by DIR. For each file, it extracts the sample name from the filename by removing the prefix and, if present, the .txt extension. Then, using the awk command, it extracts line by line the taxon name (field 6, after trimming leading spaces) and the number of reads directly assigned to that taxon (field 3) (Fig. 1). The result is saved as an individual .tsv file for each sample in the temporary directory.

 ![image](https://github.com/user-attachments/assets/f7c126f1-caf0-49f6-81cd-5108bffa5363)

Figure 1 : example of a report file fragment

Next, the script compiles a unique list of all taxon names found in the .tsv files. This is done using cut to extract the names, followed by sorting and deduplication with sort -u. The final list is stored in all_taxa.txt. In the third step, it generates the header of the presence/absence matrix by writing “Taxon” as the first column, followed by the names of the samples extracted from the .tsv files. The fourth and main loop reads each listed taxon. For each sample, the script checks whether the taxon is present in the corresponding file and retrieves the associated read count. If the taxon is absent, the count is set to zero. If the read count is greater than or equal to 10, a “1” is recorded in the matrix cell; otherwise, a “0” is recorded. Each row thus represents a taxon, and each column corresponds to a sample.
Finally, at the end of the script, a message confirms that the binary presence/absence matrix has been successfully generated in the specified output file.
