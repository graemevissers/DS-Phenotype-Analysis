# Dry Season Data Clean, High Nitrogen Conditions
# author: Graeme Vissers

library(dplyr)
library(readxl)
library(stringr)
library(gmodels)

source("./src/data_clean_functions.r")
N_CONDITION = "High_N"

# ------------------------------------------------------------------------------#


# Import sheets (path is relative to project location)
high.n.pheno <- read_excel_allsheets("./data/2021DS 3_NYU_Nipponbare_HighN.xlsx")


# ------------------  Leaf Water Potential (LWP) ------------------

# Add Trt column
high.n.pheno[["LWP"]] <- high.n.pheno[["LWP"]] %>% 
  mutate(Trt = ifelse(STUDY == "3vs-21DS", "VS", "WW"))

high.n.lwp <- extract_and_clean("LWP", Ave_LWP, N_CONDITION)


# ------------------------- Porometer -----------------------------------

colnames(high.n.pheno$Porometer)[colnames(high.n.pheno$Porometer) == "Plot"] <- "PLOTNO"
high.n.porometer <- extract_and_clean("Porometer", Conduct., N_CONDITION)


# ------------------------- Crownroot -----------------------------------

# Change char values to double
class(high.n.pheno[["Crownroot"]][["Crown root #"]]) <- "double"

#Remove the 'notes' column
high.n.pheno[["Crownroot"]][["Notes"]] <- NULL

high.n.crownroot <- extract_and_clean("Crownroot", Crown_root_N, N_CONDITION)

# ---------------------Shoot Dry Weight (SDW) ------------------------------

high.n.sdw <- extract_and_clean("Crownroot", SDW, N_CONDITION)

# --------------------- Tiller ------------------------------

# Drop 'Pan' column and last column
high.n.pheno[["Tiller"]][["Pan"]] <- NULL

high.n.tiller <- extract_and_clean("Tiller", Tiller_N, N_CONDITION)

# --------------------- Plant Height ------------------------------

# Add Trt column
high.n.pheno[["Plantht"]] <- high.n.pheno[["Plantht"]] %>% 
  mutate(Trt = ifelse(STUDY == "3vs-21DS", "VS", "WW"))

high.n.plantht <- extract_and_clean("Plantht", PLHT, N_CONDITION)


# --------------------- Days to Flowering (DTF) ------------------------------

# Add Trt column
high.n.pheno[["DTF"]] <- high.n.pheno[["DTF"]] %>% 
  mutate(Trt = ifelse(STUDY == "3vs-21DS", "VS", "WW"))

high.n.dtf <- extract_and_clean("DTF", DTF, N_CONDITION)


# MISSING DATA FOR GRAIN YIELD, BIOMASS, AND HARVEST INDEX
# NEED HARVEST AREA TO COMPUTE DATA
