
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

# Load the above generated Evento dataframe into memory
mydf <- readRDS(file = paste0(tmpDir,"/ZHAW_Evento_all_preprocessed.Rda"))

# No stemming since the words should be compared in their full lenght
dtm = dfm(mydf$text, tolower=T, remove = stopwords('de'), stem = F, remove_punct=T)

############ CREATE DICTIONARY II >>>>>>>>>>


sdg = dictionary(list(
Zugang_zu_Basisdienstleistungen = "zugang zu basisdienstleistungen",
alternative_Finanzdienstleistung = "alternative finanzdienstleistung",
Armutsbekämpfung = "armutsbekämpfung",
Aporophobie = "aporophobie",
Grundbedürfnisse = "grundbedürfnisse",
Betteln = "betteln",
Community_Banking_Modelle = "community-banking-modelle",
konzentrierte_Benachteiligung = "konzentrierte benachteiligung",
descamisado = "descamisado",
Entwicklungszusammenarbeit = "entwicklungszusammenarbeit",
Katastrophenrisikominderung = "katastrophenrisikominderung",
Diskriminierung = "diskriminierung",
entrechtet = "entrechtet",
Müllsammeln = "müllsammeln",
Einkommen = "einkommen",
Gleichberechtigung = "gleichberechtigung",
finanzielle_Eingliederung = "finanzielle eingliederung",
frugale_Innovation = "frugale innovation",
Ghetto_Steuer = "ghetto-steuer",
Staatsausgaben_für_Bildung = "staatsausgaben für bildung",
Staatliche_Ausgaben_für_Gesundheit = "staatliche ausgaben für gesundheit",
Staatliche_Ausgaben_für_soziale_Sicherung = "staatliche ausgaben für soziale sicherung",
Härtefall = "härtefall",
Mikrokrankenversicherung = "mikrokrankenversicherung",
Landstreicher = "landstreicher",
Obdachlos = "obdachlos",
Obdachlosigkeit = "obdachlosigkeit",
Haushaltseinkommen = "haushaltseinkommen",
verarmt = "verarmt",
inklusives_Wachstum = "inklusives wachstum",
Einkommen = "einkommen",
Einkommensdefizit = "einkommensdefizit",
Einkommensgleichheit = "einkommensgleichheit",
Einkommensungleichheit = "einkommensungleichheit",
Einkommensniveau = "einkommensniveau",
niedriges_Einkommen = "niedriges einkommen",
Ungleichheit = "ungleichheit",
einkommensschwache_Familien = "einkommensschwache familien",
Haushalte_mit_niedrigem_Einkommen = "haushalte mit niedrigem einkommen",
niedriges_Einkommen = "niedriges einkommen",
Lumpenproletariat = "lumpenproletariat",
ausgegrenzt = "ausgegrenzt",
materielle_Deprivation = "materielle Ddeprivation",
Mikro_Kredit = "mikro-kredit",
Mikro_Finanzierung = "mikro-finanzierung",
Mikrokredit = "mikrokredit",
Mikrofinanzierung = "mikrofinanzierung",
Mikrofinanzierung = "mikrofinanzierung",
Mikrozuschuss = "mikrozuschuss",
Mikro_Versicherung = "mikro-versicherung",
Migranten = "migranten",
neue_Geschäftsmärkte = "neue geschäftsmärkte",
Nicht_Diskriminierung = "nicht-diskriminierung",
Bürgersteigbewohner = "bürgersteigbewohner",
rente = "rente",
Arme = "arme",
arme_Familien = "arme familien",
arme_Haushalte = "arme haushalte",
arme_Menschen = "arme menschen",
arme_Person = "arme person",
Ärmste = "ärmste",
Armut = "armut",
Pro_Arm = "pro-arm",
armutsorientierte_Entwicklung = "armutsorientierte entwicklung",
Pro_Arm_Wachstum = "pro-arm-wachstum",
Proletariat = "proletariat",
Wohlstand = "wohlstand",
Lebensqualität = "lebensqualität",
Umverteilung = "umverteilung",
umverteilender_Wandel = "umverteilender wandel",
relative_Deprivation = "relative deprivation",
Forschung_und_Entwicklung = "forschung und entwicklung",
Einzelhändler = "einzelhändler",
ländliches_Ghetto = "ländliches ghetto",
Barackensiedlung = "barackensiedlung",
Elendsviertel = "elendsviertel",
Slum = "slum",
Slumlord = "slumlord",
Sozialhilfe = "sozialhilfe",
soziale_Eingliederung = "soziale eingliederung",
soziale_Isolation = "soziale isolation",
soziale_Gerechtigkeit = "soziale gerechtigkeit",
Sozialpolitik = "sozialpolitik",
Sozialpolitik = "sozialpolitik",
Sozialschutz = "sozialschutz",
Sozialfürsorge = "sozialfürsorge",
Solidaritätskredit = "solidaritätskredit",
Anbieter = "anbieter",
Zeltstadt = "zeltstadt",
Besitzrechte_an_Land = "besitzrechte an land",
Preisstaffelng = "preisstaffelung",
unbanked = "unbanked",
underbanked = "underbanked",
Unterschicht = "unterschicht",
Dorfbanking = "dorfbanking",
Verwundbarkeitsindex = "verwundbarkeitsindex",
verwundbar = "verwundbar",
gefährdete_Haushalte = "gefährdete haushalte",
Vermögen = "vermögen",
Wohlfahrtssysteme = "wohlfahrtssysteme",
erwerbstätige_Arme = "erwerbstätige arme"
))

# convert line separated string into a list
sdg_1_raw <- as.list(el(strsplit(sdg,"\n")))%>%
    lapply(tolower)
str(sdg_1_raw)

sdg_1_de = dictionary(list(
    Zugang_zu_Basisdienstleistung = c('zugang','basis*','*dienst*','*leistung'),
    alternative_Finanzdienstleistung = c('alternativ*','finanz*','*dienst*','*leistung'),
    Armutbekämpfung = c('armut*',regex('*k?+mpf*')),
    Aporophobie = c('aporophobie'),
    Grundbedürfnis = c('grund*','*bedürfnis*'),
    Betteln = 'bettel*',
    Community_Banking_Modelle = c('communit*','*banking*','*model*'),
    konzentrierte_Benachteiligung = c('konzentr*','*nachteil*'),
    descamisado = c('descamisado'),
    Entwicklungszusammenarbeit = c('entwicklung*','*zusammen*'),
    Katastrophenrisikominderung = c('katastro*','*risko*','*minder*'),
    Diskriminierung = c('diskriminierung'),
    entrechtet = c('ent*','*recht*'),
    Müllsammeln = c(regex('m*ll*','*sammel*')),
    Einkommen = c('einkommen'),
    Gleichberechtigung = c('gleich*','*berechtig*'),
    finanzielle_Eingliederung = c('*finanz*','*ein*','glieder*'),
    frugale_Innovation = c('frugal*','innov*'),
    Ghetto_Steuer = c('ghetto','*steuer'),
    Staatsausgaben_für_Bildung = c('staat*','*ausgabe*','bildung'),
    Staatsausgaben_für_Gesundheit = c('staat*','*ausgabe*','gesundheit'),
    Staatsausgaben_für_soziale_Sicherung = c('staat*','*ausgabe*','sozial*','*sicher*'),
    Härtefall = c(regex('h?+rtefall')),
    Mikrokrankversicherung = c('micro*','*krankenvericher*'),
    Landstreicher = c('landstreicher'),
    Obdachlos = c('obdachlos'),
    Haushaltseinkommen = c('haushaltseinkommen'),
    verarmt = c('veramrmt'),
    inklusives_Wachstum = c('inklusiv*','wachstum'),
    Einkommen = c('einkommen'),
    Einkommensdefizit = c('einkommen','*defizit'),
    Einkommensgleichheit = c('einkommen','*gleichheit'),
    Einkommensungleichheit = c('einkommen','*ungleichheit'),
    Einkommensniveau = c('einkommen','*niveau'),
    Ungleichheit = c('ungleich*'),
    niedriges_Einkommen = c('neidrig*','*einkommen'),
    einkommensschwache_Familien = c('einkommen*','*schwach*','familie*'),
    Haushalt_mit_niedrigem_Einkommen = c('haushalt',"niedrig*",'*einkommen*'),
    niedriges_Einkommen = c('niedrig*','*einkommen*'),
    Lumpenproletariat = c('lumpen*','*proletariat'),
    ausgegrenzt = c('aus*','*grenz*'),
    materielle_Deprivation = c('materiel*','deprivation'),
    Mikrokredit = c('mikro*','*kredit'),
    Mikrofinanzierung = c('mikro*','*finanz*'),
    Mikrozuschuss = c('mikro*','*zusch*'),
    Mikroversicherung = c('micro*','versicherung*'),
    Migrant = c('migrant'),
    neue_Geschäftsmärkte = c('neu*',regex('gesch?+ft*'),'*model*'),
    Nicht_Diskriminierung = c('nicht','keine','diskriminier*'),
    Bürgersteigbewohner = c('bürgersteig*','*bewohner'),
    Rente = c('rente'),
    Arme = c('arme'),
    arme_Familie = c('arme','familie*'),
    armer_Haushalt = c('arme*','haushalt*'),
    armer_Mensch = c('arme*','mensch'),
    arme_Person = c('arme*','person*'),
    Ärmste = c(regex('?+rmst*')),
    Armut = c('armut'),
    Pro_Arm = c('pro-arm'),
    armutorientierte_Entwicklung = c('armut*','orientiert*','entwicklung*'),
    Pro_Arm_Wachstum = c('pro-arm','wachstum'),
    Proletariat = c('proletariat'),
    Wohlstand = c('wohlstand'),
    Lebensqualität = c('lebensqualit*'),
    Umverteilung = c('umverteilung*'),
    umverteilender_Wandel = c('umverteil*','wandel'),
    relative_Deprivation = c('relativ*','deprivation'),
    Forschung_und_Entwicklung = c('forschung und entwicklung'),
    Einzelhändler = c('einzelh*nd'),
    ländliches_Ghetto = c('ländlich*','ghetto'),
    Barackensiedlung = c('baracke*','*siedlung*'),
    Elendsviertel = c('elend*','*viertel'),
    Slum = c('slum'),
    Slumlord = c('slumlord'),
    Sozialhilfe = c('sozialhilfe'),
    soziale_Eingliederung = c('sozial*','eingliederung'),
    soziale_Isolation = c('sozial*','isolation*'),
    soziale_Gerechtigkeit = c('sozial*',"gerechtigkeit"),
    Sozialpolitik = c('sozial*','*politik'),
    Sozialschutz = c('sozial*','*schutz'),
    Sozialfürsorge = c(regex('sozialf?+rsorge*')),
    Solidaritätskredit = c('solidarität*','*kredit'),
    Anbieter = c('anbieter'),
    Zeltstadt = c('zeltstadt'),
    Besitzrecht_an_Land = c('besitzrecht*','land'),
    Preisstaffelung = c('preisstaffelung'),
    unbanked = c(regex('un?+banked')),
    Unterschicht = c('unterschicht'),
    Dorfbanking = c('dorfbank*'),
    Verwundbarkeitsindex = c('verwundbarkeit*','*index'),
    verwundbar = c('verwundbar'),
    gefährdete_Haushalt = c('gefährdet*','haushalt'),
    Vermögen = c('vermögen'),
    Wohlfahrtssystem = c('wohlfahrtssystem*'),
    erwerbstätige_Arme = c(regex('erwerbst?+tig*'),'arme')
))

sdg_1 = sdg_1_de
# sdg_1 = sdg
sdg_2 =c(regex('alter*t*'))
sdg_3 = c('sustainable')

dict = dictionary(list(
    sdg1 = sdg_1,
    sdg2 = sdg_2,
    sdg3 = sdg_3)
)

dict_dtm = dfm_lookup(dtm,dict, exclusive = TRUE)
dict_dtm
d <- convert(dict_dtm, to = "data.frame")
textplot_wordcloud(dict_dtm, max_words = 50)

setwd("~/.R/library/dxiaiR")
# connect the sustainability package
devtools::document()
# Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

sdg.dict(1,"de","rev")


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



