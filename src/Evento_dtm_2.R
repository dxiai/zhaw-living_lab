
############# CREATE DICTIONARY I >>>>>>>>>>
# Load the above generated Evento dataframe into memory
mydict <- read_delim(file = paste0(tmpDir,"/SDG1_DE.csv"),delim = ";")
mydict[1]
paste(mydict$Stichwort,mydict$Stichwort_1) %>%
    strsplit("[[:space:]]",) %>%
    as.list()  -> s

for (i in 1:length(s)){
    s[[i]] <- s[[i]][!duplicated(s[[i]])]
}
print(s)
as.data.frame() ->s
distinct() -> s

############# CREATE DICTIONARY  I <<<<<<<<<<<<




#
############# CREATE DICTIONARY  II <<<<<<<<<<<<

##################################################################
##################################################################
# dtm  sdg wordcloud comparison
##################################################################

# Load all required libraries and if not yet installed, install them
if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
if (!require('quanteda')) install.packages('quanteda'); library(quanteda)
if (!require('methods')) install.packages('methods'); library(methods)
if (!require('rockchalk')) install.packages('rockchalk'); library(rockchalk)
if (!require('stringi')) install.packages('stringi'); library(stringi)
if (!require('purrr')) install.packages('purrr'); library(purrr)

devtools::install_github("quanteda/quanteda.corpora")
devtools::install_github("kbenoit/LIWCalike")

# Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# temporary working directory
tmpDir = paste0(getwd(),"/tmp")
# set the director< path for the data that shall be shared
setwd("..")
dataDir =   paste0(getwd(),"/data")
# Reset the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

meta_data <- c("studiengang","lernziele","lerninhalt","gruppenunterricht","beschreibung","bezeichnung","kurs","modul","hinweis","system","modulbeschreibungstext","stichdatum")

############# FUNCTIONS  >>>>>>>>>>
# ngram function with three inout parateters
# text: a type char,
# n: type int, stating the number of words in the n-gram
# features_only; type bool, default FALSE, returns the whole dtm
n_gram <- function(text, n=1, features_only = F){
    text %>%
        as.character() %>%
        char_tolower() %>%
        tokens(remove_punct = TRUE) %>%
        tokens_remove(padding = TRUE) %>%
        tokens_wordstem(language = "german") %>%
        tokens_ngrams(n) -> t
    if(features_only){featnames(dfm(t))}else{dfm(t)}
}
############# FUNCTIONS  <<<<<<<<<<<<

############# DATA PREPARATION >>>>>>>>>>
# Load the above generated Evento dataframe into memory
mydf <- readRDS(file = paste0(tmpDir,"/ZHAW_Evento_all_preprocessed.Rda"))

corp = corpus(mydf,text_field = 'text')

# Initialisation of the main dataframe where all document features are collected
myn_gram =  data.frame(matrix(data = NA, nrow = 0, ncol = 2))

# creating the n-gram over the whole dataset, returns the complete n_gram
ngram = 5
for (i in 1:1){
    # for (i in 1:length(corp)){
    tempn_gram <- convert(t(n_gram(text=corp[[i]],n=ngram, features_only=F)), to = "data.frame")
    myn_gram <- rbind(myn_gram,tempn_gram)
    print(i)
}

# renames the n-gram columns
names(myn_gram) <- c("text","freq")

myn_gram %>%
    mutate_at(1, as.factor) %>%
    count(text, sort = T) -> temp2

barplot(temp2$n[1:100], las=2)

############# EXPORT CFM >>>>>>>>>>
write_csv(temp2,paste0(tmpDir,paste0("/ZHAW_Evento_",ngram,"_ngram.csv")))
############# EXPORT CFM <<<<<<<<<<<<

###############################
# corp <- corpus(txt)
# corp_stopwords <- featnames(dfm(corp, select = stopwords("german")))
# removing stopwords before constructing ngrams
toks1 <- tokens(char_tolower(txt), remove_punct = TRUE)
toks2 <- tokens_remove(toks1, stopwords("english"), padding = TRUE)
#################
# 1-gram
toks3 <- tokens_ngrams(toks2, 1)
# Document frequency matrix 1-gram
dfm_1_gram = dfm(toks3)
# feature names only: Document frequency matrix 1-gram
featnames(dfm(toks3))

#################
# 2-gram




dtm = dfm(mydf$text, tolower=T, remove = stopwords('de'), stem = F, remove_punct=T)
head(dtm,2)

##################################################################
##################################################################
# Corpus generation
corp = corpus(mydf, text_field = "text")
# corp
dtm_corp = dfm(corp, stem=F, remove = stopwords("de"), remove_punct=T)

##################################################################
# Word cloud funtion
selection_word_cloud <- function(s,n){
    # s: substring to search for
    # n: number of terms in the worldcloud
    mysub <- grepl(s,(docvars(dtm_corp)$id))
    mysub_dtm = dtm[mysub,]
    textplot_wordcloud(mysub_dtm, max_words = n)
}
# Word cloud from of the corpus selection
selection_word_cloud("g.BA.ER.",20)

##################################################################
# relative frequency comparison between a selection and the corpus
selection_word_comparison <- function(s,n=10, head = T, textplot = F){
    # s: substring to search for
    # n: number of terms being printed
    # h: show hearder (T) or tail (F)
    mysub <- grepl(s,(docvars(dtm_corp)$id))
    ts = textstat_keyness(dtm_corp,mysub)
    if(head){head(ts,n)}
    else{tail(ts,n)}
    if(textplot){textplot_keyness(ts)}
}
selection_word_comparison("g.BA.ER.",20, textplot = T)
##################################################################

# focused world cloud
sustain <- kwic(corp, "sustainability", window = 5)
sustain_corp <- corpus(sustain)
sustain_dtm = dfm(sustain_corp,tolower=T, remove = stopwords("de"), remove_punct=T)
textplot_wordcloud(sustain_dtm, max_words = 50)
head(sustain, 10)

##################################################################
##################################################################

####60321 ##############################################################


####60321 ##############################################################
# convert line separated string into a list
sdg_1_de <- as.list(el(strsplit(sdg,"\n")))%>%
    lapply(tolower)
str(sdg_1_de)

# Load the above generated Evento dataframe into memory
mydict <- read_delim(file = paste0(tmpDir,"/SDG1_DE.csv"),delim = ";")
sdg_1 = unlist(mydict[1])

sdg_1 = c('basis*','*dienstleistung*','finanz*','armut*','*bekämpfung')
sdg_2 =c('akut','*ernährung', 'verfälscht', 'essen', 'landwirtschaft*','*vielfalt','nachhaltig*')
sdg_3 = c('sustainable')

dict = dictionary(list(
    sdg1 = sdg_1,
    sdg2 = sdg_2,
    sdg3 = sdg_3)
)
dict_dtm = dfm_lookup(dtm,dict, exclusive = TRUE)
dict_dtm
textplot_wordcloud(dict_dtm, max_words = 50)

##################################################################
# Corpus generation
corp = corpus(mydf, text_field = "text")

# Word cloud function
selection_word_dict <- function(mylist, myhead= 10, mywords = 10, mywindow = 5, mytextplot = F){
    # dictionary based word cloud
    corp_dict <- kwic(corp, mylist, mywindow)
    corp_selection <- corpus(corp_dict)
    dict_dtm = dfm(corp_selection,tolower=T, remove = stopwords("de"), remove_punct=T)
    if(mytextplot){textplot_wordcloud(dict_dtm, max_words = mywords)}
    return(if(myhead>0){head(as.data.frame(corp_dict),myhead)}else{as.data.frame(corp_dict)})
}

sdg_context <- selection_word_dict(dict$sdg2, myhead = 0, mywindow = 3, mytextplot = T)
write_csv(sdg_context,paste0(tmpDir,"/ZHAW_Evento_term_sdg_context.csv"))
##################################################################


# Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# temporary working directory
tmpDir = paste0(getwd(),"/tmp")
# set the director< path for the data that shall be shared
setwd("..")
dataDir =   paste0(getwd(),"/data")
# Reset the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

library(readxl)
dataset <- read_xlsx(paste0(tmpDir,"/SDG1_DE1.xlsx"),sheet = "SDG1_DE")
x <- dataset[2:5,2:3]
l <- list(x[1,2])
x2 <- lapply(seq_len(ncol(x)), function(i) as.list(x[,i]))
x3 <- as.data.frame(x2)
rbind.data.frame(x[1],)

sdg_1_de_revised = dictionary(list(
    Zugang_zu_Basisdienstleistung = c('zugang','basis*','*dienstleistung'),
    altenativ_Finanzdienstleistung = c('alternativ*','finanz*','*dienstleistung'),
))


