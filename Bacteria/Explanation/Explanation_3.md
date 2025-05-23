# Code explanation for Script_SIMPER.R
-----------------------------------------

This R script performs a SIMPER (Similarity Percentage Analysis) to identify the bacterial taxa that contribute most to the differences in community composition between sample groups. After loading the required packages (tidyverse, vegan, and scales), binary presence/absence data of taxa are imported from a TSV file [taxa_presence_absence_min10.tsv](../data/taxa_presence_absence_min10.tsv). The matrix is transposed so that each row represents a sample, and empty columns are removed. A metadata table (df_plot) is then created by extracting information from sample names (such as sample number, group, subgroup, country, and region), allowing the encoding of biological and geographical relationships between individuals.

A custom function, run_simper(), is defined to execute the SIMPER analysis between two or more user-defined groups. It filters the data according to the selected scenario and calculates the mean contribution of each taxon to the dissimilarity between groups (without permutation tests in this implementation). The top 20 contributing taxa are extracted and visualized using a bar plot generated with ggplot2, where contributions are displayed as percentages. Taxon names are italicized in accordance with taxonomic conventions. The results are exported both as a CSV table and as a PDF figure.

Finally, the user can specify a comparison scenario from several options (e.g., Greek and Italian subgroups, or comparisons by country or region), which triggers the function with the appropriate groups. This flexible structure allows testing of various biological or geographical aggregation levels to identify the taxa most responsible for bacterial community differentiation—without the need to write custom SIMPER code for each case.

The resulting graph should look like the one below (fig.1): 
![graph_2](https://github.com/user-attachments/assets/90a74edc-a3b4-46bd-9b66-f01cabb11c94)

