# Packages
library(tidyverse)
library(vegan)       # for beta-diversity
library(broom)       # to format results
library(ggplot2)

# 1. Load matrix
mat <- read.delim("taxa_presence_absence_min10.tsv", row.names = 1, check.names = FALSE)

# 2. Transpose: row = sample, columns = taxa
mat_t <- t(mat)

# 3. Clean: remove empty lines
sums <- rowSums(mat_t)
mat_t_nonempty <- mat_t[sums > 0, ]

# 4. Calculate Jaccard distance (binary)
dist_jaccard <- vegdist(mat_t_nonempty, method = "jaccard", binary = TRUE)

# 5. Performing a PCoA (classic ordination)
pcoa_res <- cmdscale(dist_jaccard, k = 2, eig = TRUE)

# 6. Create DataFrame for ggplot
df_plot <- as.data.frame(pcoa_res$points)
df_plot$Sample <- rownames(df_plot)

# Add groups according to samples
df_plot$Group <- case_when(
  df_plot$Sample %in% paste0("P", 1:7)   ~ "F",
  df_plot$Sample %in% paste0("P", 8:20)  ~ "G",
  df_plot$Sample %in% paste0("P", 21:34) ~ "I",
  df_plot$Sample %in% paste0("P", 35:43) ~ "S",
  TRUE ~ "Autre"
)

# 7. View PCoA with enhancements
pcoa_plot <- ggplot(df_plot, aes(x = V1, y = V2, color = Group, label = Sample)) +
  geom_point(size = 3) +
  stat_ellipse(type = "norm", linetype = "dashed", linewidth = 1) +
  geom_text(vjust = -1, size = 3, show.legend = FALSE) +
  scale_color_manual(values = c("F" = "red", "G" = "blue", "I" = "green", "S" = "purple")) +
  labs(title = "Analyse de la diversité β (PCoA - Jaccard)",
       subtitle = "Ellipses par groupe",
       x = "Axe 1", y = "Axe 2", color = "Groupe") +
  theme_minimal() +
  theme(
    text = element_text(size = 14),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 12),
    legend.position = "right",
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5)
  )

print(pcoa_plot)

# 8. PERMANOVA
permanova_res <- adonis2(dist_jaccard ~ Group, data = df_plot)
print(permanova_res)

# 9. Dispersion homogeneity test
betadisp_res <- betadisper(dist_jaccard, df_plot$Group)
anova_disp <- anova(betadisp_res)
print(anova_disp)

# 10. Automatic summary of results
summary_table <- tibble(
  Test = c("PERMANOVA", "Dispersion"),
  `R2 / F value` = c(permanova_res$R2[1], anova_disp$`F value`[1]),
  `p-value` = c(permanova_res$`Pr(>F)`[1], anova_disp$"Pr(>F)"[1])
)

print(summary_table)

## Test pairwise PERMANOVA

# 1. Create a function for PERMANOVA between 2 groups
pairwise_permanova <- function(data_matrix, grouping_vector) {
  combinaisons <- combn(unique(grouping_vector), 2, simplify = FALSE)
  
  resultats <- lapply(combinaisons, function(pair) {
    idx <- grouping_vector %in% pair
    subset_matrix <- data_matrix[idx, ]
    subset_group <- grouping_vector[idx]
    dist_subset <- vegdist(subset_matrix, method = "jaccard", binary = TRUE)
    mod <- adonis2(dist_subset ~ subset_group)
    tibble(
      Group1 = pair[1],
      Group2 = pair[2],
      R2 = mod$R2[1],
      F_value = mod$F[1],
      p_value = mod$`Pr(>F)`[1]
    )
  })
  
  bind_rows(resultats)
}

# 2. Use the function
results_pairwise <- pairwise_permanova(mat_t_nonempty, df_plot$Group)

# 3. See results
print(results_pairwise)

## Heatmap

# 1. Preparing data for the heatmap
heatmap_data <- results_pairwise %>%
  mutate(Significant = ifelse(p_value < 0.05, "Significant", "Not Significant"))

# 2. Making the heatmap
heatmap_plot <- ggplot(heatmap_data, aes(x = Group1, y = Group2, fill = p_value)) +
  geom_tile(color = "white") +
  geom_text(aes(label = round(p_value, 3)), size = 4) +
  scale_fill_gradient2(low = "red", mid = "white", high = "blue", midpoint = 0.05, name = "p-value") +
  labs(title = "Pairwise PERMANOVA - Heatmap des p-values",
       x = "Groupe 1",
       y = "Groupe 2") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(heatmap_plot)
