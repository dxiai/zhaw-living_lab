# dtm  sdg wordcloud comparison
##################################################################

# connect the sustainability package
setwd("~/.R/library/dxiaiR")
# connect the sustainability package
devtools::document()
# Restart R Session
# .rs.restartR()

# # Load all required libraries and if not yet installed, install them
if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
if (!require('quanteda')) install.packages('quanteda'); library(quanteda)

# variables initialisation
tmpDir = ""; dataDir = ""; dataFile = ""; d = ""; sdg_1 = {}

# Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# temporary working directory
tmpDir = paste0(getwd(),"/tmp")
# set the director< path for the data that shall be shared
dataDir =   paste0(getwd(),"/data")

# Load preprocessed Evento dataframe into memory
dataFile <- readRDS(file = paste0(tmpDir,"/ZHAW_Evento_all_preprocessed.Rda"))
# No stemming since the words should be compared in their full lenght
dtm = dfm(dataFile$text, tolower=T, remove = stopwords('de'), stem = F, remove_punct=T)


############################ Single list search from Excel original
library(readxl)
dataset <- read_xlsx(paste0(tmpDir,"/SDG1_DE1.xlsx"),sheet = "SDG1_DE",na = 'NULL')
# filter out all decomposed NA rows
sdg_1 <- dataset[2:nrow(dataset),2:3] %>%
    as_tibble() %>%
    filter(!is.na(decomposed)) %>%
    as.list() #%>%
    # dictionary()

dict_dtm = dfm_lookup(dtm,sdg_3, exclusive = TRUE)
# create a dtm dataframe
d <- convert(dict_dtm, to = "data.frame")
# plot a wordcloud containing the most frequent found sdg expressions in the corpus
textplot_wordcloud(dict_dtm, max_words = 30)
############################

sdg_3 = dictionary(list(
    Zugang_zu_Basisdienstleistung = c('zugang','basis*','*dienstleistung'),
    altenativ_Finanzdienstleistung = c('alternativ*','finanz*','*dienstleistung')
))



############################ Single list search from Excel decomposed
library(readxl)
dataset <- read_xlsx(paste0(tmpDir,"/SDG1_DE1.xlsx"),sheet = "SDG1_DE")
x <- as_tibble(dataset) %>%
    mutate_at(c(3:3), ~replace(., is.na(.), ''))
# x <- dataset[2:5,2:3]
x2 <- lapply(seq_len(ncol(x)), function(i) as.list(x[,"decomposed"]))[2]
names(x2) = x[,1]
sdg_2 <- dictionary(x2)
# create a dtm
dict_dtm = dfm_lookup(dtm,sdg_2, exclusive = TRUE)
# create a dtm dataframe
d <- convert(dict_dtm, to = "data.frame")
# plot a wordcloud containing the most frequent found sdg expressions in the corpus
textplot_wordcloud(dict_dtm, max_words = 30)
############################


############################ Single list search from library
# call external sdg language oriented function
sdg_1 = sdg.dict(1,"de","revised")
# create a dtm
dict_dtm = dfm_lookup(dtm,sdg_1, exclusive = TRUE)
# create a dtm dataframe
d <- convert(dict_dtm, to = "data.frame")
# plot a wordcloud containing the most frequent found sdg expressions in the corpus
textplot_wordcloud(dict_dtm, max_words = 100)


############################ version for simultaniously multiple sdgs lists search
# call external sdg language oriented function
sdg_1 = sdg.dict(1,"de","revised")
# Compose the dictionary as list of more than one sdgs
dict = dictionary(list(
    '1' = sdg_1,
    '2' = list(),
    '3' = list()
    ))

# create a dtm
dict_dtm = dfm_lookup(dtm,dict, exclusive = TRUE)
# create a dtm dataframe
d <- convert(dict_dtm, to = "data.frame")
# plot a wordcloud containing the most frequent found sdg expressions in the corpus
textplot_wordcloud(dict_dtm, max_words = 30)
