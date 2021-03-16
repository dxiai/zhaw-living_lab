# Load all required libraries and if not yet installed, install them
if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
if (!require('quanteda')) install.packages('quanteda'); library(quanteda)
if (!require('methods')) install.packages('methods'); library(methods)
if (!require('rockchalk')) install.packages('rockchalk'); library(rockchalk)
if (!require('stringi')) install.packages('stringi'); library(stringi)
if (!require('stringr')) install.packages('stringr'); library(stringr)

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
getwd()

course_ID <- function(x){
    x %>% stri_extract(regex = "^[^ ]*")
}

course_title <- function(x){
    x %>% stri_replace_all(" ", regex = "(^.* \\()") %>%
    stri_replace_all("", regex = "\\).*$") %>%
        trimws(which = "both")
}

course_text <- function(x){
    x %>% 
        stri_replace_all("and", regex = "\\&") %>%
        stri_replace_all(" ", regex = "(\\r|\\n|\\t|\\+|\\.\\.\\.|:)")%>%
        stri_replace_first(" ///Modul: ", regex = "Modul ") %>%
        stri_replace_all(" ///Modul.Kurs: ", regex = "Nr") %>%
        stri_replace_all(" ///Modul.Kurs.Bezeichnung: ", regex = "Bezeichnung") %>%
        stri_replace_all(" ///Modul.Kurs.Veranstalter: ", regex = "Veranstalter") %>%
        stri_replace_all(" ///Modul.Kurs.Studiengang: ", regex = "Studiengang") %>%
        stri_replace_all(" ///Modul.Kurs.Credits: ", regex = "Credits") %>%
        stri_replace_all(" ///Modul.Kurs.Version: ", regex = "Version") %>%
        stri_replace_all(" ///Modul.Kurs.Beschreibung: ", regex = "Beschreibung") %>%
        stri_replace_all(" ///Modul.Kurs.Title: ", regex = "Kurs ") %>%
        stri_replace_all(" ///Modul.Kurs.Lerninhalt: ", regex = "Lerninhalt") %>%
        stri_replace_all(" ///Modul.Kurs.Lernziele: ", regex = "Lernziele") %>%
        stri_replace_all(" ///Modul.Kurs.Seminar: ", regex = "Seminar") %>%
        stri_replace_all(" ///Modul.Kurs.Werkplan: ", regex = "Werkplan") %>%
        stri_replace_all("Modul.Kurs.Version", regex = "Beschreibung *Version") %>%
        stri_replace_all(" ///Modul.Datum: Diese Information", regex = "Diese Information") %>%
        stri_replace_all(" ", regex = "[[:blank:]]{2,}") %>%
        stri_replace_all(",", regex = " ,") -> x
        y <- stri_locate_all(x,regex = "(?<=[[:digit:]]{4})[[:upper:]]")
        for (i in 1:length(y[[1]][,2])){
            x <- paste0(substr(x,1,y[[1]][i,2]-1)," ///Beschreibung: ",substr(x,y[[1]][i,2],nchar(x[1])))
        }
        return(x)
}

# Load the above generated Evento dataframe into memory 
dd <- readRDS(file = paste0(tmpDir,"/ZHAW_Evento_all-docs-content.Rda")) %>%
    mutate_at(1,as.character) %>%
    mutate_at(2,as.character)

# Initialisation of the main dataframe where all document fetures are collected 
mydf =  data.frame(matrix(data = NA, nrow = 0, ncol = 3))
names(mydf) <- c("id","title", "text")

# preprocess the text
for (i in 1:10){
    # for (i in 1:nrow(dd)){
    mydf[i,1] <- course_ID(dd$course[i])
    mydf[i,2] <- course_title(dd$course[i])
    x <- dd$text[i]
    my_text <- course_text(x)
    pos <- str_locate_all(my_text, "[[:lower:]][[:upper:]]")[[1]]
    mydf[i,3] <- my_text
    if (nrow(pos)>0){
        for (j in 1:nrow(pos)){
            my_text <- paste(substr(my_text,0,pos[j,1]+j-1),substr(my_text,pos[j,2]+j-1,nchar(my_text)))
        }
        mydf[i,3] <- my_text
    }
    if(round(i/20) == i/20){print(i)}
}

###########################################################################
# Store the digital collection as dataframe into the hidden temp directory
saveRDS(mydf, file = paste0(tmpDir,"/ZHAW_Evento_all_preprocessed_T1.Rda"))








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

corp = corpus(mydf,text_field = 'text')
head(corp)

stopwords <- c(stopwords('de'),meta_data)

# No stemming since the words should be compared in their full lenght
dtm = dfm(corp, tolower=T, remove = stopwords, stem = F, remove_punct=T)
# dtm = dfm(corp, tolower=T, remove = stopwords('de'), stem = F, remove_punct=T)
head(dtm)

############# DATA PREPARATION  <<<<<<<<<<<<

############# FULL CORPUS >>>>>>>>>>
# create a frequency matrix based on the full corpus
cfm <- textstat_frequency(dtm);
head(cfm,10)
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


##################################################################
##################################################################
# n-grams
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
ngram = 3
for (i in 1:length(corp)){
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
# Load the above generated Evento dataframe into memory 
mydf <- readRDS(file = paste0(tmpDir,"/ZHAW_Evento_all_preprocessed.Rda"))

# No stemming since the words should be compared in their full lenght
dtm = dfm(mydf$text, tolower=T, remove = stopwords('de'), stem = F, remove_punct=T)

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


