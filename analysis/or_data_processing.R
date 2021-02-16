
# Paper Data Processing -----------------------------------------------------

# Packages
library(tidyverse)

# 1 Import data -----------------------------------------------------------
or_data <- read.csv("data/or_data.csv")

# 2 Data Processing ---------------------------------------------------------

# 2.1 Take just means
means_data <- map(or_data[,-1], substr, start= 1, stop = 4)
means_data <- as.data.frame(means_data)
colnames(means_data) <- c("0.5", "1", "2", "4", "12", "24", "48", "72")

means_data <- means_data %>% 
  mutate(MET = or_data[,1]) %>% 
  relocate(MET)

# 2.2 Save data frame for means (demonstrative purposes)
write.csv(means_data, "data/means_data.csv", row.names = FALSE)

# 2.3 Take just sds
sd_data <- map(or_data[,-1], substr, start=8, stop=12)
sd_data <- as.data.frame(sd_data)
colnames(sd_data) <- c("0.5", "1", "2", "4", "12", "24", "48", "72")

sd_data <- sd_data %>% 
  mutate(MET = or_data[,1]) %>% 
  relocate(MET)

# 3 Gather data ------------------------------------------------------------

# 3.1 Means
mg_data <- pivot_longer(means_data, `0.5`:`72`, 
                        names_to = "TIME", values_to = "MEAN")

# 3.2 SDs
sdg_data <- pivot_longer(sd_data, `0.5`:`72`,
                         names_to = "TIME", values_to = "SD")

# 3.3 Join means ans sd 
cp_data <- full_join(mg_data, sdg_data, by = c("TIME", "MET"))

# 3.4 Save cp_data (to simulation)
write.csv(cp_data, "data/cp_data.csv", row.names = FALSE)
