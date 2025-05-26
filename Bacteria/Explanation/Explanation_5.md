This R script aims to visualize the bacterial community composition across multiple samples using a combined plot that includes a stacked barplot and a dendrogram. This dual representation allows for the simultaneous observation of both the taxonomic structure and the similarity between samples based on microbial profiles.

1. Data loading and matrix preparation
The file taxa_abundance_normalized_top50_families_name.tsv, which contains normalized abundance values (i.e., proportions) for the 50 most abundant bacterial families, is imported. The matrix is transposed so that samples are represented as rows and families as columns, which is the required format for subsequent multivariate analyses.

2. Clustering based on Bray–Curtis dissimilarity
A Bray–Curtis dissimilarity matrix is computed, a standard metric in microbial ecology used to assess compositional differences between samples. A hierarchical clustering is then performed using the average linkage method (UPGMA), and the result is converted into a dendrogram object suitable for visualization.

3. Sample ordering
The sample order derived from the dendrogram is used to reorder the matrix accordingly, ensuring that both the barplot and the dendrogram follow the same layout and are visually aligned.

4. Data reshaping for ggplot2
Abundances are converted to percentages. The data is reshaped to long format using the melt function, which is required to plot stacked bar charts with ggplot2. A numeric identifier is also assigned to each sample to control vertical positioning.

5. Selection of dominant families and grouping of rare ones
Although the input matrix includes the top 50 families, only the 25 most abundant families overall are retained for the final plot. This choice improves legend readability. The less abundant families are grouped under a single category labeled "Other".

6. Color palette and legend formatting
A custom color palette is defined, assigning distinct colors to each family, with a neutral grey for the "Other" category. Taxonomic family names are rendered in italic in the legend using the ggtext package, except for "Other", which remains in plain text.

7. Stacked barplot generation
A horizontal stacked barplot is generated using geom_bar(), with each bar representing a sample and each segment corresponding to a bacterial family's relative abundance. The sample order follows the dendrogram structure, providing a coherent visual flow.

8. Dendrogram construction
The dendrogram is drawn horizontally with a reversed x-axis to display Bray–Curtis dissimilarities from right to left. Sample names are omitted to avoid redundancy, as they are already labeled on the barplot.

9. Final plot assembly with legend
The final figure is assembled using cowplot, placing the dendrogram to the left, the barplot to the right, and the legend at the bottom. This layout provides a comprehensive view of the bacterial community composition and ecological similarity among samples, facilitating interpretation at both taxonomic and multivariate levels.
