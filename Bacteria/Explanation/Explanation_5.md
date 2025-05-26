# Code explanation for Script_barplot_&_dendrogram.R
------------------------------------------------------

This R script is designed to visualize the bacterial community composition of multiple samples using a combined stacked barplot and dendrogram. This dual-panel figure allows for an integrated view of taxonomic composition and inter-sample similarity.

1. Package installation and loading
The required R packages (vegan, reshape2, ggplot2, ggdendro, cowplot, scales, and ggtext) are first installed (commented for reproducibility) and then loaded into the session.

2. Data loading and transposition
The input file [taxa_abundance_normalized_top50_families_name.tsv](../data/taxa_abundance_normalized_top50_familie_name.tsv), containing normalized (relative) abundance data for the top 50 bacterial families, is read into R. The data is then transposed so that rows represent samples and columns represent bacterial families — the format required for distance-based ecological analyses.

3. Bray–Curtis dissimilarity and clustering
A Bray–Curtis dissimilarity matrix is calculated using the vegdist function. This metric is widely used in microbial ecology to assess compositional differences. A hierarchical clustering is then performed (average linkage, or UPGMA), and the result is converted to a dendrogram object for plotting.

4. Sample ordering from the dendrogram
The sample order from the dendrogram is extracted and used to reorder the original matrix. This ensures that the barplot (which will display the taxonomic profiles) follows the same structure as the dendrogram.

5. Conversion to percentages
The normalized abundance values (originally between 0 and 1) are multiplied by 100 to express relative abundances as percentages, which are more intuitive to interpret in graphical formats.

6. Long format conversion and continuous sample positioning
The abundance matrix is converted to a long-format data frame using melt, which is required by ggplot2 to create stacked bar plots. A numeric index (SampleNum) is assigned to each sample to facilitate precise vertical positioning.

7. Grouping of rare families into "Other"
From the global sum of relative abundances, the 25 most abundant families are selected. All other families are relabeled as "Other", a strategy commonly used to reduce visual clutter and simplify legends.

8. Alphabetical ordering and legend formatting
The remaining family names are sorted alphabetically, with "Other" placed last. The factor levels of the Family column are updated accordingly to control legend and stacking order.

9. Custom color palette
A custom color palette is created using a predefined vector of hex and named colors. Each family receives a unique color, and the "Other" category is consistently colored in light grey ("grey70").

10. Italicized legend labels
Using ggtext, taxonomic family names in the legend are rendered in italic, with the exception of "Other" which remains in regular font. This is consistent with scientific naming conventions.

11. Stacked barplot construction
A horizontal stacked barplot is generated with ggplot2, showing relative abundances per sample. The sample order follows the dendrogram layout. A clean, minimalist theme is applied, and the legend is positioned at the bottom to enhance readability.

12. Dendrogram construction
The dendrogram is plotted using ggplot2 from the ggdendro output. It is flipped horizontally (x-axis reversed) to align with the sample order in the barplot. Axis elements are minimized for clarity.

13. Final figure assembly
Using cowplot, the dendrogram and barplot are arranged side by side, followed by the shared legend. The final layout ensures a cohesive and interpretable figure, simultaneously displaying both taxonomic profiles and ecological dissimilarities among samples.
