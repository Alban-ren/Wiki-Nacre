# install.packages(c("vegan","reshape2","ggplot2","ggdendro","cowplot","scales","ggtext"))

library(vegan)
library(reshape2)
library(ggplot2)
library(ggdendro)
library(cowplot)
library(scales)
library(ggtext)

# 1. Lecture & transposition
df  <- read.table(
  "taxa_abundance_normalized_top50_families_name.tsv",
  header    = TRUE, sep = "\t",
  row.names = 1, check.names = FALSE
)
mat <- t(as.matrix(df))  # échantillons × familles

# 2. Bray–Curtis + clustering
dist_bc <- vegdist(mat, method = "bray")
hc      <- hclust(dist_bc, method = "average")

# 3. Préparation du dendrogramme
dend  <- as.dendrogram(hc)
ddata <- dendro_data(dend, type = "rectangle")

# 4. Ordre des échantillons
order_labels <- ddata$labels$label
mat_ord      <- mat[order_labels, , drop = FALSE]
n_samp       <- length(order_labels)

# 5. Passage en pourcentage
mat_pct <- mat_ord * 100

# 6. Format long + position continue
plot_df <- as.data.frame(mat_pct)
plot_df$Sample <- rownames(plot_df)
molten <- melt(
  plot_df,
  id.vars       = "Sample",
  variable.name = "Family",
  value.name    = "Abundance"
)
molten$Sample <- factor(molten$Sample, levels = order_labels)
molten$SampleNum <- as.numeric(molten$Sample)

# 7. Regrouper familles rares en "Other"
abundances <- aggregate(Abundance ~ Family, data = molten, sum)
abundances <- abundances[order(-abundances$Abundance), ]
top_n <- 25
top_families <- abundances$Family[1:top_n]

molten$Family <- as.character(molten$Family)
molten$Family[!(molten$Family %in% top_families)] <- "Other"

# 8. Ordre alphabétique + "Other" à la fin
families <- sort(setdiff(unique(molten$Family), "Other"))
families <- c(families, "Other")
molten$Family <- factor(molten$Family, levels = families)

# 9. Palette personnalisée
custom_cols <- c(
  "red","black","green","blue","#ff3366","#ff6699","#ff66cc","#003300","#006600",
  "#336633","#66cc66","#669933","#66cc00","#33cc00","#00cc33","#33ff66","#66ff99",
  "#ccff99","#99ff33","#ffccff","#990000","#cc0000","#cc3300","#ff0000","#cc3333",
  "#ff6666","#ff9999","#ffcccc","#663300","#996633","#000033","#000066","#000099",
  "#0000cc","#0000ff","#0033cc","#3300ff","#3300cc","#0033ff","#3333ff","#3366ff",
  "#0066ff","#3366cc","#6699ff","#3399ff","#00ccff","#3399cc","#66ccff","#33ccff",
  "#0099cc","#00ffff","#336666","#9900ff","#9933cc","#ccffff","#006633","#669966",
  "#666699","#ccccff","#ff99ff","#ccffcc","#99cc99","#99ffcc","#ff9966","#ff9900",
  "#ffcc66","#cccccc"
)
pal_cols <- custom_cols[1:length(families)]
pal <- setNames(pal_cols, families)
pal["Other"] <- "grey70"

# 10. Légendes en italique sauf "Other"
families_labels <- sapply(families, function(fam) {
  if (fam == "Other") fam else paste0("<i>", fam, "</i>")
})
names(families_labels) <- families

# 11. Barplot
p_bar <- ggplot(molten, aes(
  x = Abundance,
  y = SampleNum,
  fill = Family
)) +
  geom_bar(
    stat = "identity",
    orientation = "y",
    width = 0.7,
    colour = "white",
    size = 0.1
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
  scale_fill_manual(
    values = pal,
    labels = families_labels
  ) +
  guides(fill = guide_legend(
    title = "Class Family",
    nrow  = 3,
    byrow = FALSE,
    override.aes = list(
      shape  = 22,
      size   = 6,
      colour = NA
    )
  )) +
  labs(x = "Relative abundance (%)", y = NULL) +
  theme_minimal() +
  theme(
    axis.text.y        = element_text(size = 7, face = "bold"),
    axis.text.x        = element_text(size = 7),
    legend.position    = "bottom",
    legend.direction   = "horizontal",
    legend.box         = "horizontal",
    legend.key.width   = unit(1.2, "lines"),
    legend.key.height  = unit(0.8, "lines"),
    legend.title       = element_text(size = 8, face = "bold"),
    legend.text        = element_markdown(size = 8),
    legend.margin      = margin(t = 5, b = 5),
    panel.grid.major.y = element_blank()
  )

# 12. Dendrogramme
max_h <- max(segment(ddata)$y)
p_dend <- ggplot(segment(ddata),
                 aes(x = y, y = x, xend = yend, yend = xend)) +
  geom_segment(size = 0.6, color = "black") +
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

# 13. Assemblage final
legend      <- get_plot_component(p_bar, "guide-box-bottom")
p_bar_clean <- p_bar + theme(legend.position = "none")

combined <- plot_grid(
  p_dend      + theme(plot.margin = margin(5, 0, 5, 5)),
  p_bar_clean + theme(plot.margin = margin(5, 5, 5, 0)),
  ncol       = 2,
  rel_widths = c(0.8, 3.2)
)

final_plot <- plot_grid(
  combined, legend,
  ncol        = 1,
  rel_heights = c(6, 2.5)
)

print(final_plot)

