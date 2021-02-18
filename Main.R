# Main script to run the analysis -----------------------------------------

# Preferably, before you run this script restart your R session: 
# Ctrl+Shift+F10 if you are using RStudio

# Packages
library(ggplot2) # To make graphs
library(dplyr) # To make some data transformations

# 1 Simulating the data
source("analysis/data_simulation.R")

# 2 AOV analysis
source("analysis/aov_analysis.R")

# 3 HSD test
source("analysis/hsd_test.R")

# 4 Summary data 
source("analysis/sum_data.R")

# 5 Plots
source("analysis/bar_plot.R")
source("analysis/point_plot.R")
source("analysis/bar_point_plot.R")

# 5 Session info
capture.output(sessionInfo(), file = "Session_Info.txt")