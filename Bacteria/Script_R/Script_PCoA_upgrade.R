# Packages
library(tidyverse)
library(vegan)     # for β-diversity
library(ggrepel)   # to avoid overlapping labels

# 1. Load matrix
mat <- read.delim("taxa_presence_absence_min10.tsv",
                  row.names = 1, check.names = FALSE)

# 2. Transpose: row = sample, columns = taxa
mat_t <- t(mat)

# 3. Clean: remove completely empty lines
mat_t <- mat_t[rowSums(mat_t) > 0, ]

# 4. Calculate Jaccard distance (binary)
dist_jaccard <- vegdist(mat_t, method = "jaccard", binary = TRUE)

# 5. PCoA (classic ordination)
pcoa_res <- cmdscale(dist_jaccard, k = 2, eig = TRUE)

# 6. % of variance explained by each axis
var_expl <- round(100 * pcoa_res$eig[1:2] / sum(pcoa_res$eig), 1)

# 7. Building the ggplot data.frame
df_plot <- as.data.frame(pcoa_res$points) %>%
  setNames(c("PCoA1", "PCoA2")) %>%
  rownames_to_column("Sample") %>%
  mutate(
    Group = case_when(
      Sample %in% paste0("P", c(1:7, 35:43)) ~ "France_Spain",
      Sample %in% paste0("P", 8:20)          ~ "Greece",
      Sample %in% paste0("P", 21:34)         ~ "Italia",
      TRUE                                   ~ NA_character_
    )
  )

# 8. Plot 
pcoa_plot <- ggplot(df_plot, aes(x = PCoA1, y = PCoA2)) +
  # Ellipses 95% (colored outline)
  stat_ellipse(aes(group = Group, color = Group),
               type = "t", linetype = "dashed", size = 0.8, level = 0.95) +
  # Dots with filling + black border
  geom_point(aes(fill = Group, shape = Group),
             size = 3, stroke = 0.6, color = "black") +
  # Sample labels
  geom_text_repel(aes(label = Sample),
                  size = 3, fontface = "bold", max.overlaps = 15, segment.size = 0.3) +
  # Titles
  labs(
    title    = "Diversity analysis β  (PCoA - Jaccard)",
    subtitle = "Grouping by region: France+Spain, Greece, Italia",
    x = paste0("PCoA1 (", var_expl[1], "%)"),
    y = paste0("PCoA2 (", var_expl[2], "%)")
  ) +
  # Filling points
  scale_fill_manual(
    name = "Region",
    values = c(
      "France_Spain" = "#E69F00",  # orange
      "Greece"       = "#009E73",  # vert
      "Italia"       = "#0072B2"   # bleu
    )
  ) +
  # Color of ellipses
  scale_color_manual(
    name = "Region",
    values = c(
      "France_Spain" = "#E69F00",
      "Greece"       = "#009E73",
      "Italia"       = "#0072B2"
    )
  ) +
  # Group shapes
  scale_shape_manual(
    name = "Region",
    values = c("France_Spain" = 21, "Greece" = 22, "Italia" = 24)
  ) +
  # Own theme
  theme_bw(base_size = 14) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position  = "bottom",
    legend.box       = "horizontal",
    plot.title       = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle    = element_text(hjust = 0.5)
  )

# 9. Display + export
print(pcoa_plot)

ggsave("PCoA_Jaccard_regions_bordered_final.pdf", plot = pcoa_plot,
       width = 7, height = 5)
