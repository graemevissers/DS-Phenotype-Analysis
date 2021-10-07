# Dry Season Data Clean, Low Nitrogen Conditions
# author: Graeme Vissers

library(dplyr)
library(readxl)
library(stringr)
library(gmodels)

source("./src/data_clean_functions.r")
N_CONDITION = "Low_N"

# ------------------------------------------------------------------------------#


# Import sheets (path is relative to project location)
low.n.pheno <- read_excel_allsheets("./data/2021DS 2_NYU_Nipponbare_LowN.xlsx")

  
# ------------------  Leaf Water Potential (LWP) -----------------------

low.n.lwp <- extract_and_clean("LWP", Ave_LWP, N_CONDITION)


# ------------------------- Porometer -----------------------------------

colnames(low.n.pheno$Porometer)[colnames(low.n.pheno$Porometer) == "Plot"] <- "PLOTNO"
low.n.porometer <- extract_and_clean("Porometer", Conduct., N_CONDITION)


# ------------------------- Crownroot -----------------------------------

# Change char values to double
class(low.n.pheno[["Crownroot"]][["Crown root #"]]) <- "double"

#Remove the 'notes' column
low.n.pheno[["Crownroot"]][["Notes"]] <- NULL

low.n.crownroot <- extract_and_clean("Crownroot", Crown_root_N, N_CONDITION)

# ---------------------Shoot Dry Weight (SDW) ------------------------------

low.n.sdw <- extract_and_clean("Crownroot", SDW, N_CONDITION)

# --------------------- Tiller ------------------------------

# Drop 'Pan' column and last column
low.n.pheno[["Tiller"]][["Pan"]] <- NULL
low.n.pheno[["Tiller"]][["...11"]] <- NULL

low.n.tiller <- extract_and_clean("Tiller", Tiller_N, N_CONDITION)

# --------------------- Plant Height ------------------------------

low.n.plantht <- extract_and_clean("Plantht", PLHT, N_CONDITION)


# --------------------- Days to Flowering (DTF) ----------------------

low.n.dtf <- extract_and_clean("DTF", DTF, N_CONDITION)


# MISSING DATA FOR GRAIN YIELD, BIOMASS, AND HARVEST INDEX
# NEED HARVEST AREA TO COMPUTE DATA
