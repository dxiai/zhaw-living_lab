##################################################################
# generate Evento document term frequency matrix
##################################################################
# Load all required libraries and if not yet installed, install them
if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
if (!require('quanteda')) install.packages('quanteda'); library(quanteda)
if (!require('methods')) install.packages('methods'); library(methods)
if (!require('rockchalk')) install.packages('rockchalk'); library(rockchalk)
if (!require('stringi')) install.packages('stringi'); library(stringi)
if (!require('purrr')) install.packages('purrr'); library(purrr)
if (!require('readxl')) install.packages('readxl'); library(readxl)

devtools::install_github("quanteda/quanteda.corpora")
devtools::install_github("kbenoit/LIWCalike")

# Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# temporary working directory
tmpDir = paste0(getwd(),"/tmp")
# set the director< path for the data that shall be shared
# setwd("..")
dataDir =   paste0(getwd(),"/data")
# Reset the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

meta_data <- c("studiengang","lernziele","lerninhalt","gruppenunterricht","beschreibung","bezeichnung","kurs","modul","hinweis","system","modulbeschreibungstext","stichdatum")

############# FUNCTIONS  >>>>>>>>>>
# create a dtm subset based on a search expression starting with
dtm_sub <- function(dtm_full,course_ID){
    dtm_full[docvars(dtm_full)$id %>%
                 startsWith(course_ID),]
}

`%notin%` = function(x,y) !(x %in% y)

############# FUNCTIONS  <<<<<<<<<<<<

############# DATA PREPARATION >>>>>>>>>>
# Load the above generated Evento dataframe into memory
mydf <- readRDS(file = paste0(tmpDir,"/ZHAW_Evento_all_preprocessed.Rda"))

head(mydf$text)
corp = corpus(mydf,text_field = 'text')
head(corp)

stopwords <- c(stopwords('de'),meta_data)

# No stemming since the words should be compared in their full lenght
dtm = dfm(corp, tolower=T, remove = stopwords, stem = F, remove_punct=T, thesaurus = )
# dtm = dfm(corp, tolower=T, remove = stopwords('de'), stem = F, remove_punct=T)
head(dtm)

############# DATA PREPARATION  <<<<<<<<<<<<



############# FULL CORPUS >>>>>>>>>>
# create a frequency matrix based on the full corpus
cfm <- textstat_frequency(dtm);
head(cfm,10)
tail(cfm,100)
cfm %>%
    group_by(docfreq) %>%
    head()
head(cfm[cfm$docfreq<10,],100)
# log-log plot of rank and frequency to detect a potential split point
plot(log10(cfm$rank),log10(cfm$frequency))

# filter the dtm for furter and optimized computation
# dtm = dfm_trim(dtm, min_termfreq = 1000)
# dtm = dfm_trim(dtm, max_termfreq = 1200)

# plot a workcloud with regard to the subset
textplot_wordcloud(dtm_subet, max_words = 10)

############# FULL CORPUS <<<<<<<<<<<<

############# SUBSET CORPUS >>>>>>>>>>
dtm_subet <- dtm_sub(dtm = dtm,course_ID = 'g.BA.HB.15.12HS')
head(t(dtm_subet))

# filter the dtm for furter and optimized computation
# dtm = dfm_trim(dtm, min_termfreq = 1000)
# dtm = dfm_trim(dtm, max_termfreq = 1200)

# plot a workcloud with regard to the subset
textplot_wordcloud(dtm_subet, max_words = 10)

# create a frequency matrix based on the subset
cfm_sub <- textstat_frequency(dtm_subet);
cfm_sub <- cfm_sub %>% filter(feature %notin% meta_data)
head(cfm_sub,10)

# log-log plot of rank and frequency to detect a potential split point
plot(log10(cfm_sub$rank),log10(cfm_sub$frequency))
############# SUBSET CORPUS <<<<<<<<<<<<

############# EXPORT CFM >>>>>>>>>>
write_csv(cfm,paste0(tmpDir,"/ZHAW_Evento_term_freq_matrix.csv"))
############# EXPORT CFM <<<<<<<<<<<<
