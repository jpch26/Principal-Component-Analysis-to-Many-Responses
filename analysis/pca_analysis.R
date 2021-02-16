
# PCA Analysis on Main Data ------------------------------------------------

# Packages
if (!"tidyverse" %in% .packages()) library(tidyverse)

# 1 Import Data -----------------------------------------------------------
main_data <- read_csv("data/main_data.csv")

# 2 Formatting Data for PCA ---------------------------------------------------

# 2.1 Obtain wide data 
main_data_wd <- main_data %>% 
  mutate(SAMPLE_TIME = paste0(SAMPLE, "-", TIME)) %>% 
  pivot_wider(names_from = SAMPLE_TIME, values_from = QT, -TIME:-SAMPLE)

# 2.2 Transposing just quantity values
qt_data <- t(main_data_wd[, -1])

# 3 PCA analysis ----------------------------------------------------------
qt_pca <- prcomp(qt_data, scale. = FALSE)

# 3.1 PCA data
pca_data <- as_tibble(qt_pca$x) %>% 
  mutate(TIME = as_factor(substr(rownames(qt_pca$x), start = 3, stop =5))) %>% 
  relocate(TIME)

# 3.2 Loadings
compound_names <- filter(main_data, SAMPLE == 1, TIME == 0.5) %>% 
  select(MET) %>% 
  unlist()          # Compound names

loadigns_data <- as_tibble(qt_pca$rotation) %>% 
  signif(3) %>% 
  mutate(MET = compound_names) %>% 
  relocate(MET) 

# 3.3 Variation percentage per PC
var_pca <- qt_pca$sdev^2
per_var_pca <- round((var_pca / sum(var_pca))*100, 2)
per_var_pca <- tibble(
  PC = 1:length(per_var_pca),
  PER_VAR = per_var_pca
)

# 2.4 Save results
write_csv(pca_data, "data/pca_data.csv")
write_csv(loadigns_data, "data/loadings_data.csv")
write_csv(per_var_pca, "data/per_var_pca.csv")

# 3 Plots ------------------------------------------------------------------

# 3.1 Scree Plot
bar_pca <- per_var_pca %>% 
  ggplot(aes(x = as.factor(PC), y = PER_VAR)) +
  geom_col() + 
  xlab("PC") +
  ylab("% of total variance") +
  theme_classic() +
  theme(
    axis.text.x = element_text(color = "black", size = 13),
    axis.text.y = element_text(color = "black", size = 13),
    axis.title = element_text(color = "black", size = 15)
  ) 

# 3.2 Score plot PC1 vs PC2
pca_plot <- pca_data %>% 
  ggplot(aes(x = PC1, y = PC2, color = TIME)) +
  geom_point(size = 3) +
  xlab(paste0("PC1-", per_var_pca$PER_VAR[1], "%")) +
  ylab(paste0("PC2-", per_var_pca$PER_VAR[2], "%")) +
  theme_classic() +
  theme(
    axis.text.x = element_text(color = "black", size = 13),
    axis.text.y = element_text(color = "black", size = 13),
    axis.title = element_text(color = "black", size = 15)
  ) +
  scale_color_brewer(palette = "Dark2")


# 3.3 Save plots
ggsave("graphs/scree_plot.jpeg", plot = bar_pca)
ggsave("graphs/pca_plot.jpeg", plot = pca_plot)
