# Dry Season Data Clean FUNCTIONS
# Author: Graeme Vissers

library(dplyr)
library(readxl)
library(stringr)
library(gmodels)

# Import Low Nitrogen excel document as a CSV

# Function borrowed from stackoverflow for reading multiple sheets in a large
# excel file
read_excel_allsheets <- function(filename, tibble = FALSE) {
  sheets <- excel_sheets(filename)
  dfs <- lapply(sheets, function(X) read_excel(filename, sheet = X))
  if(!tibble) dfs <- lapply(dfs, as.data.frame)
  names(dfs) <- sheets
  dfs
}

# Dataframe extraction and cleaning

extract_and_clean <- function(df.name, var, n.condition) {
  
  # Pull the data frame from the list of DFs
  if (n.condition == "Low_N") {
    df.full  <- low.n.pheno[[df.name]]
  } else {
    df.full  <- high.n.pheno[[df.name]]
  }
  
  # Replace white space from column names with '_' and '#' with 'N'
  colnames(df.full) <- lapply(colnames(df.full),
                              function (X) str_replace_all(X, c(" "="_", "#"="N")))
  
  # Remove rows with NA values
  df.full.noNA <- df.full[complete.cases(df.full),]
  
  # 1) Remove all plot numbers greater than nine
  # 2) Group by plot, designation, and treatment and find the mean val
  #    at each plot
  df.full.filtered.byplot <- df.full.noNA %>%
    filter(PLOTNO <= 9) %>%
    group_by(PLOTNO, DESIGNATION, Trt) %>%
    summarize(Mean_Val = mean( {{ var }} ))
  
  # Find the mean val and std. err for each species of rice
  df <- df.full.filtered.byplot %>% 
    group_by(DESIGNATION, Trt) %>% 
    summarize(Mean = ci(Mean_Val)[1],
              Stderr = ci(Mean_Val)[4],
              CI_LOWER = ci(Mean_Val)[2],
              CI_UPPER = ci(Mean_Val)[3]) %>% 
    mutate(POS_STDERR = Mean + Stderr,
           NEG_STDERR = Mean - Stderr,
           N_CONDITION = n.condition)
  
  # Change the column names to represent the variables of interest. SDW is a special
  # case because it was in the crownroot DF
  colnames(df) <- c("DESIGNATION", "TRT", paste("MEAN", toupper(deparse(substitute(var))), sep="_"),
                    paste("STDERR", toupper(deparse(substitute(var))), sep="_"), "CI_LOWER",
                    "CI_UPPER", "POS_STDERR", "NEG_STDERR", "N_CONDITION")
  df
}