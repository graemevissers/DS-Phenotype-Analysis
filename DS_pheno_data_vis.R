# Dry Season Data Vis, High and Low Nitrogen Conditions
# author: Graeme Vissers

library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(tools)

source("./src/high_n_data_clean.R")
source("./src/low_n_data_clean.R")

# Function for creating 4 x 4 bar plots
plot_bars <- function(df.low.n, df.high.n, ylabel) {
  
  # Combine the low N and high N conditions into one DF
  df <- rbind(df.low.n, df.high.n)
  
  # Create string for variable of interest)
  mean.col.name <- colnames(df)[
    which(substr(colnames(df), 1, 4) == "MEAN")
    ]
  
  # Add labels of facets
  condition_names <- c(`VS` = "Low W",
                       `WW` = "High W",
                       `High_N` = "High N",
                       `Low_N` = "Low N")
  
  # Plot a 4x4 data frame that shows the levels of our variable of interest
  # under each condition
  ggplot(df,
         mapping = aes_string(x = "DESIGNATION",
                       y = mean.col.name,
                       fill = "DESIGNATION")) +
    geom_bar(stat = "identity",
             color = "black") +
     geom_errorbar(aes_string(x = "DESIGNATION",
                       y = mean.col.name,
                       ymin = "POS_STDERR",
                       ymax = "NEG_STDERR")) +
    facet_grid(col = vars(TRT), rows = vars(N_CONDITION),
               labeller = as_labeller(condition_names)) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
    xlab("Accession") +
    ylab(ylabel) +
    labs(fill = "Accession") +
    scale_fill_brewer(palette = "Dark2")
} 

# ------------------  Leaf Water Potential (LWP) -----------------------

lwp_bars <- plot_bars(low.n.lwp, high.n.lwp, "LWP (bars)")

# ------------------------- Porometer -----------------------------------

porometer_bars <- plot_bars(low.n.porometer, high.n.porometer,
                            expression(paste("Conductance (mmol /", "m"^"2","s"^"2",")")))

# ------------------------- Crownroot -----------------------------------

crownroot_bars <- plot_bars(low.n.crownroot, high.n.crownroot,
                            "Crown Root Count")

# ---------------------Shoot Dry Weight (SDW) ----------------------------

sdw_bars <- plot_bars(low.n.sdw, high.n.sdw,
                      "Shoot Dry Weight (g)")

# --------------------------- Tiller -------------------------------------

tiller_bars <- plot_bars(low.n.tiller, high.n.tiller,
                         "Tiller Count")

# ------------------------- Plant Height ----------------------------------

plantht_bars <- plot_bars(low.n.plantht, high.n.plantht,
                          "Plant Height (cm)")

# --------------------- Days to Flowering (DTF) ---------------------------

dtf_bars <- plot_bars(low.n.dtf, high.n.dtf,
                      "Days to Flowering")


