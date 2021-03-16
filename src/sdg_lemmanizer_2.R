# Load all required libraries and if not yet installed, install them
if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
if (!require('stringr')) install.packages('stringr'); library(stringr)
if (!require('stringi')) install.packages('stringi'); library(stringi)
if (!require('sjmisc')) install.packages('sjmisc'); library(sjmisc)

# Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# temporary working directory
tmpDir = paste0(getwd(),"/tmp")
# set the director< path for the data that shall be shared
setwd("..")
dataDir =   paste0(getwd(),"/data")
# Reset the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

sdg <- "Stichwort
Zugang zu Basisdienstleistungen
alternative Finanzdienstleistung
Armutsbekämpfung
Aporophobie
Grundbedürfnisse
Betteln"

"Community-Banking-Modelle
konzentrierte Benachteiligung
descamisado
Entwicklungszusammenarbeit
Katastrophenrisikominderung
Diskriminierung
entrechtet
Müllsammeln
Einkommen
Gleichberechtigung
finanzielle Eingliederung
frugale Innovation
Ghetto-Steuer
Staatsausgaben für Bildung
Staatliche Ausgaben für Gesundheit
Staatliche Ausgaben für soziale Sicherung
Härtefall
Mikrokrankenversicherung
Landstreicher
Obdachlos
Obdachlosigkeit
Haushaltseinkommen
verarmt
inklusives Wachstum
Einkommen
Einkommensdefizit
Einkommensgleichheit
Einkommensungleichheit
Einkommensniveau
Ungleichheit
niedriges Einkommen
einkommensschwache Familien
Haushalte mit niedrigem Einkommen
niedriges Einkommen
Lumpenproletariat
ausgegrenzt
materielle Deprivation
Mikro-Kredit
Mikro-Finanzierung
Mikrokredit
Mikrofinanzierung
Mikrofinanzierung
Mikrozuschuss
Mikro-Versicherung
Migranten
neue Geschäftsmärkte
Nicht-Diskriminierung
Bürgersteigbewohner
rente
Arme
arme Familien
arme Haushalte
arme Menschen
arme Person
Ärmste
Armut
Pro-Arm
armutsorientierte Entwicklung
Pro-Arm-Wachstum
Proletariat
Wohlstand
Lebensqualität
Umverteilung
umverteilender Wandel
relative Deprivation
Forschung und Entwicklung
Einzelhändler
ländliches Ghetto
Barackensiedlung
Elendsviertel
Slum
Slumlord
Sozialhilfe
soziale Eingliederung
soziale Isolation
soziale Gerechtigkeit
Sozialpolitik
Sozialpolitik
Sozialschutz
Sozialfürsorge
Solidaritätskredit
Anbieter
Zeltstadt
Besitzrechte an Land
Preisstaffelung 
unbanked
underbanked
Unterschicht
Dorfbanking
Verwundbarkeitsindex
verwundbar
gefährdete Haushalte
Vermögen
Wohlfahrtssysteme
erwerbstätige Arme"

# convert line separated string into a list
sdg_1_de <- as.list(el(strsplit(sdg,"\n")))%>%
    lapply(tolower)
str(sdg_1_de)
# 
# sdg_1_de %in% "SlumVermögen" 
# "Slum" %in% "SlumVermögen" 
# str_contains("SlumVermögen","Slum")
# str_locate("SlumVermögen","Slum")
# s = "verwundbarkeitsindex"
# dict_de$terms
# a <- str_detect("verwundbarkeitsindex",dict_de$terms)
# dict_de$terms[a]
# b <- str_detect("zugang zu basisdienstleistungen",dict_de$terms)
# dict_de$terms[b]
# 
# dict_de$terms[a]
# dict_de[mapply(function(x, y) {any(x %in% y)}, tolower(sdg_1_de),"Slum")]
# 
# sdg_1_de <- sdg %>% stri_replace_all(",", regex = "\\n")
# typeof(sdg_1_de)
# summary(sdg_1_de)
# 
# l <- as.list(sdg_1_de);l
# # typeof(sdg_1_de)
# t <- as.data.frame(l);t
# "Slum" %in% sdg_1_de

#########################################################
# library(udpipe)
# x <- c(doc_a = "In our last meeting, someone said that we are meeting again tomorrow",
#        doc_b = "It's better to be good at being the best")
# str(x)
# anno <- udpipe(elements, "german")
# anno[, c("doc_id", "sentence_id", "token", "lemma", "upos")]

#####################################
dict_de <- read_csv(file = paste0(tmpDir,"/wordlist-german.txt")) %>%
    lapply(tolower)
names(dict_de) <- "terms"

# sdg_1_de_list = list()
# tt = list()

sdg_abc <- generate_terms_list(sdg_1_de)
sdg_abc <- generate_terms_list("zugangzubasisdienstleistungen")
sdg_abc <- generate_terms_list("basisdienstleistungen")


sdg_m <- as.matrix(sdg_abc)
sdg_m[[2]]
#####################################
generate_terms_list <- function(elements){
    sdg_1_de_list = list()
    for (i in 1:length(elements)){
        l = list()
        l_res = list()
        l <- (lemm(elements[i]))
        for (j in 2:length(l)){
            if (grepl(l[j-1], l[j], fixed = TRUE) == FALSE){
                print(paste(l[j-1],l[j]))
                # typeof(l[j-1])
                l_res <- c(l_res,l[j-1])
            }
        }
        l_res <- c(l_res,elements[i]) %>%
            unlist() %>%
            unique() %>%
            as.list()
        sdg_1_de_list[[i]] <- l_res
        # print(i)
    }
    l = l_res = list()
    return(sdg_1_de_list)
}

lemm("zugangzubasisdienstleistungen")
#####################################
lemm <- function(s){
    t = list() # data.frame(matrix(data = NA, nrow = 0, ncol = 0))
    for (i in 1:nchar(s)){
        str_sub(s,i,nchar(s)) %>%    
            lapply(tolower) %>%
            intersect(dict_de$terms) -> u
        if(length(u)>0){
            # j = i
            t <- append(t,u)
            # print(t)
            # readline(prompt="Press [enter] to continue")
            # print(paste("i: ",i,u,typeof(u), nchar(u)))
        }
        str_sub(s,1,i) %>%    
            lapply(tolower) %>%
            intersect(dict_de$terms) -> u
        if(length(u)>0){
            # j = i
            t <- append(t,u)
            # print(paste("i: ",i,u,typeof(u), nchar(u)))
        }
    }
    # t = list()
    return (t)
}

##########################################################3
s = "zugangzubasisdienstleistungen"
j = 1
for (i in j:nchar(s)){
    str_sub(s,j,i) %>%    
        lapply(tolower) %>%
        intersect(dict_de$terms) -> u
    if(length(u)>0){
        print(u)
        j = i + 1
    }
}
s = "zugangzubasisdienstleistungen"
j = nchar(s)
for (i in j:1){
    print(i)
    str_sub(s,i,j) %>%    
        lapply(tolower) %>%
        intersect(dict_de$terms) -> u
    if(length(u)>0){
        if(nchar(u)>3){
        s <- str_remove(s,u)
        print(paste(u,s))
        j = nchar(s)+1
        }
    }
}




#####################################
lemm_orig <- function(s){
    t = list() # data.frame(matrix(data = NA, nrow = 0, ncol = 0))
    for (i in 1:nchar(s)){
        str_sub(s,i,nchar(s)) %>%    
            lapply(tolower) %>%
            intersect(dict_de$terms) -> u
        if(length(u)>0){
            # j = i
            t <- append(t,u)
            # print(paste("i: ",i,u,typeof(u), nchar(u)))
        }
        str_sub(s,1,i) %>%    
            lapply(tolower) %>%
            intersect(dict_de$terms) -> u
        if(length(u)>0){
            # j = i
            t <- append(t,u)
            # print(paste("i: ",i,u,typeof(u), nchar(u)))
        }
    }
    # t = list()
    return (t)
}
#####################################
#####################################
