# 0. Packages
library(tidyverse)
library(vegan)
library(scales)    # for percent_format()

# ── 1. Data preparation ────────────────────────────────────────────────
mat <- read_tsv("taxa_presence_absence_min10.tsv", col_types = cols()) %>%
  column_to_rownames(var = names(.)[1]) %>% t() %>% as.data.frame()
mat_t <- mat %>% select_if(~ any(. != 0))
if (ncol(mat_t)==0) stop("Aucun taxon présent dans aucun échantillon.")

df_plot <- mat_t %>%
  rownames_to_column("Sample") %>%
  mutate(
    Number         = as.integer(str_extract(Sample, "(?<=P)\\d+")),
    Group          = case_when(
      Number %in% 1:7   ~ "F",
      Number %in% 8:20  ~ "G",
      Number %in% 21:34 ~ "I",
      Number %in% 35:43 ~ "S",
      TRUE              ~ NA_character_),
    Subgroup       = case_when(
      Group=="G" & Number %in% 8:14   ~ "dead",
      Group=="G" & Number %in% 15:20  ~ "alive",
      Group=="I" & Number %in% 21:25  ~ "w/o_SoD",
      Group=="I" & Number %in% 26:34  ~ "w_SoD",
      Group=="S" & Number %in% 35:36  ~ "sensitive",
      Group=="S" & Number %in% 37:43  ~ "resistant",
      TRUE                            ~ NA_character_),
    Group_Subgroup = paste0(Group, "_", Subgroup),
    Country        = recode(Group,
                            "F"="France","G"="Greece",
                            "I"="Italia","S"="Spain"),
    RegionGroup    = case_when(
      Country %in% c("France","Spain") ~ "France_Spain",
      Country=="Greece"                ~ "Greece",
      Country=="Italia"                ~ "Italia",
      TRUE                             ~ NA_character_)
  ) %>%
  filter(!is.na(Country) & (!is.na(Subgroup) | !is.na(RegionGroup)))

# ── 2. Function SIMPER + plotting ─────────────────────────────────────────────
run_simper <- function(df_plot, mat_t,
                       grouping_col, groups,
                       out_csv, out_fig,
                       title, subtitle) {
  df_sub <- df_plot %>% filter(.data[[grouping_col]] %in% groups)
  if (any(table(df_sub[[grouping_col]]) < 2)) {
    stop("Un groupe a < 2 échantillons — impossible.")
  }
  mat_sub <- mat_t[df_sub$Sample, ] %>% select_if(~ length(unique(.)) > 1)
  res <- simper(mat_sub, df_sub[[grouping_col]], permutations = 0)
  sim_df <- purrr::imap_dfr(res, \(x, comp) {
    tibble(species     = names(x$average),
           mean_contrib = as.numeric(x$average))
  }) %>%
    group_by(species) %>%
    summarise(mean_contrib = mean(mean_contrib), .groups="drop") %>%
    arrange(desc(mean_contrib)) %>%
    slice_head(n=20)
  
  # plot construction
  mx <- max(sim_df$mean_contrib)
  p <- ggplot(sim_df, aes(x=mean_contrib, y=fct_reorder(species, mean_contrib))) +
    geom_col(fill="#4C72B0", width=0.6) +
    geom_text(aes(label=percent(mean_contrib, accuracy=0.001)),
              hjust=-0.02, size=3) +
    scale_x_continuous(labels=percent_format(accuracy=0.001),
                       limits=c(0,mx*1.05), expand=c(0,0)) +
    scale_y_discrete(labels=\(x) parse(text=paste0("italic('",x,"')")),
                     limits=rev(sim_df$species)) +
    labs(title=title, subtitle=subtitle,
         x="Average contribution", y="Taxa") +
    theme_bw(base_size=12) +
    theme(
      panel.grid.major.x=element_line(color="grey85", linewidth=0.3),
      panel.grid.major.y=element_blank(),
      panel.border=element_rect(color="black", fill=NA, linewidth=0.7),
      plot.title=element_text(face="bold", hjust=0.5),
      plot.subtitle=element_text(hjust=0.5),
      legend.position="none"
    )
  
  # view
  print(p)
  
  # save
  write_csv(sim_df, out_csv)
  ggsave(out_fig, p, width=6.5, height=5)
  
  return(p)
}

# ── 3. Choice of scenario ────────────────────────────────────────────────────────
scenario <- "regional" 
# options : "gi_subgroups","country","italy_subgroups","greece_subgroups","regional"

if (scenario=="gi_subgroups") {
  run_simper(df_plot, mat_t,
             "Group_Subgroup", c("G_dead","G_alive","I_w/o_SoD","I_w_SoD"),
             "GI_subgroups.csv","GI_subgroups.pdf",
             "Top 20 Taxa (dead_ind_gr/alive_ind_gr vs Ind_without_sign_of_disease/Ind_with_sign_of_disease)",
             "Average contribution (%) — Greek & Italian subgroups")
} else if (scenario=="country") {
  run_simper(df_plot, mat_t,
             "Country", c("Greece","Italia"),
             "Greece_vs_Italy.csv","Greece_vs_Italy.pdf",
             "Top 20 Taxa (Greece vs Italy)",
             "Average contribution (%) — by country")
} else if (scenario=="italy_subgroups") {
  run_simper(df_plot, mat_t,
             "Group_Subgroup", c("I_w/o_SoD","I_w_SoD"),
             "Italy_subgroups.csv","Italy_subgroups.pdf",
             "Top 20 Taxa (Ind_without_sign_of_disease vs Ind_with_sign_of_disease)",
             "Average contribution (%) — Italian subgroups")
} else if (scenario=="greece_subgroups") {
  run_simper(df_plot, mat_t,
             "Group_Subgroup", c("G_dead","G_alive"),
             "Greece_subgroups.csv","Greece_subgroups.pdf",
             "Top 20 Taxa (dead_ind vs alive_ind)",
             "Average contribution (%) — Greek subgroups")
} else if (scenario=="regional") {
  run_simper(df_plot, mat_t,
             "RegionGroup", c("France_Spain","Greece","Italia"),
             "Regions.csv","Regions.pdf",
             "Top 20 Taxa (FRANCE+SPAIN vs GREECE vs ITALIA)",
             "Average contribution (%) — regional groups")
} else {
  stop("Scénario inconnu.")
