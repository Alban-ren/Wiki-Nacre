# install.packages(c("vegan","reshape2","ggplot2","ggdendro","cowplot","scales"))

library(vegan)
library(reshape2)
library(ggplot2)
library(ggdendro)
library(cowplot)
library(scales)

# === 1. Reading & transposition ===
df  <- read.table(
  "familles_presentes_filtrees.tsv",
  header    = TRUE, sep = "\t",
  row.names = 1, check.names = FALSE
)
mat <- t(as.matrix(df))  # échantillons × familles

# === 2. Bray–Curtis + clustering ===
dist_bc <- vegdist(mat, method = "bray")
hc      <- hclust(dist_bc, method = "average")

# === 3. Preparing the dendrogram ===
dend  <- as.dendrogram(hc)
ddata <- dendro_data(dend, type = "rectangle")

# === 4. Reorganization according to hc$order ===
order_labels <- hc$labels[hc$order]
mat_ord      <- mat[order_labels, , drop = FALSE]
n_samp       <- length(order_labels)

# === 5. Percentage changeover ===
mat_pct <- mat_ord * 100

# === 6. Long format + continuous position ===
plot_df <- as.data.frame(mat_pct)
plot_df$Sample <- rownames(plot_df)
molten <- melt(
  plot_df,
  id.vars       = "Sample",
  variable.name = "Family",
  value.name    = "Abundance"
)
# set the factor order (from highest to lowest)
molten$Sample <- factor(molten$Sample, levels = order_labels)
# and create a numerical coordinate 1..n
molten$SampleNum <- as.numeric(molten$Sample)

# === 7. Vivid hand pallet ===
custom_cols <- c(
  "Flavobacteriaceae"      = "#e41a1c",
  "Bacillaceae"            = "#377eb8",
  "Clostridiaceae"         = "#ff7f00",
  "Mycobacteriaceae"       = "#000066",
  "Mycoplasmataceae"       = "#ffccff",
  "Arcobacteraceae"        = "#99ff33",
  "Pseudoalteromonadaceae" = "#ff9966",
  "Enterobacteriaceae"     = "#4daf4a",
  "Shewanellaceae"         = "#f781bf",
  "Staphylococcaceae"      = "#a65628",
  "Vibrionaceae"           = "#984ea3"
)
familles <- sort(names(custom_cols))
pal      <- custom_cols[familles]
molten$Family <- factor(molten$Family, levels = familles)

# === 8. Stacked bar-plot (right) on continuous scale ===
p_bar <- ggplot(molten, aes(
  x = Abundance,
  y = SampleNum,
  fill = Family
)) +
  geom_bar(
    stat        = "identity",
    orientation = "y",
    width       = 0.7,
    colour      = "white",
    linewidth   = 0.1
  ) +
  scale_y_continuous(
    breaks = seq_len(n_samp),
    labels = order_labels,
    expand = c(0, 0),
    limits = c(0.5, n_samp + 0.5)
  ) +
  scale_x_continuous(
    expand = c(0, 0),
    breaks = seq(0, 100, 25)
  ) +
  scale_fill_manual(values = pal) +
  guides(fill = guide_legend(
    title           = "Class Family",
    nrow            = 1,
    byrow           = TRUE,
    label.position  = "bottom",
    title.position  = "top",
    override.aes    = list(
      shape  = 22,    # carré
      size   = 5,     # taille du carré
      colour = NA     # pas de bord
    )
  )) +
  labs(x = "Relative abundance (%)", y = NULL) +
  theme_minimal() +
  theme(
    axis.text.y        = element_text(size = 7, face="bold"),
    axis.text.x        = element_text(size = 7),
    legend.position    = "bottom",
    legend.direction   = "horizontal",
    legend.box         = "vertical",
    legend.key.width   = unit(1.2, "lines"),
    legend.key.height  = unit(0.8, "lines"),
    legend.title       = element_text(size = 10, face = "bold"),
    legend.text        = element_text(size = 9,  face = "italic"),
    legend.margin      = margin(t = 10, b = 20),
    panel.grid.major.y = element_blank()
  )

# === 9. Dendrogram (left) on **same** scale y ===
max_h <- max(segment(ddata)$y)
p_dend <- ggplot(segment(ddata), 
                 aes(x = y, y = x, xend = yend, yend = xend)) +
  geom_segment(linewidth = 0.6, color = "black") +
  scale_x_reverse(
    name   = "Bray–Curtis Dissimilarity",
    expand = c(0, 0),
    limits = c(max_h, 0)
  ) +
  scale_y_continuous(
    breaks = seq_len(n_samp),
    expand = c(0, 0),
    limits = c(0.5, n_samp + 0.5)
  ) +
  theme_minimal() +
  theme(
    axis.title.y = element_blank(),
    axis.text.y  = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.x  = element_text(size = 7),
    panel.grid   = element_blank()
  )

# === 10. Legend extraction ===
legend      <- get_plot_component(p_bar, "guide-box-bottom")
p_bar_clean <- p_bar + theme(legend.position = "none")

# === 11. Vertically synchronized assembly ===
combined <- plot_grid(
  p_dend      + theme(plot.margin = margin(5,0,5,5)),
  p_bar_clean + theme(plot.margin = margin(5,5,5,0)),
  ncol       = 2,
  rel_widths = c(1,4),
  align      = "v"
)
final_plot <- plot_grid(
  combined, legend,
  ncol        = 1,
  rel_heights = c(10,3)
)

# === 12. Display ===
print(final_plot)
