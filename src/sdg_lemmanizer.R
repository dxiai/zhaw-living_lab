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
Betteln
Community-Banking-Modelle
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
sdg_1_de <- as.list(el(strsplit(sdg,"\n")))
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
library(udpipe)
x <- c(doc_a = "In our last meeting, someone said that we are meeting again tomorrow",
       doc_b = "It's better to be good at being the best")
str(x)
anno <- udpipe(sdg, "german")
anno[, c("doc_id", "sentence_id", "token", "lemma", "upos")]



sdg_1_de_list = list()
tt = list()
elements <- c("Verwundbarkeitsindex","Preisstaffelung")
for (ele in 1:length(elements)){
    ele = "Verwundbarkeitsindex"
    terms <- (lemm(ele))
    for (i in 2:length(terms)){
        if (grepl(terms[i-1], terms[i], fixed = TRUE) == FALSE){
            print(terms[i-1])
            typeof(terms[i-1])
            tt <- c(tt,terms[i-1])
        }
    }
}
tt
sdg_1_de_list [[1]] <- c(sdg_1_de_list,tt)
sdg_1_de_list
#####################################
lemm <- function(s){
    t =  list() # data.frame(matrix(data = NA, nrow = 0, ncol = 0))
        for (i in 1:nchar(s)){
        str_sub(s,i,nchar(s)) %>%    
            lapply(tolower) %>%
            intersect(dict_de$terms) -> u
        if(length(u)>0){
            # j = i
            t <- append(t,u)
            # print(paste("i: ",i,"j: ",j,u,typeof(u), nchar(u),t)) 
        }
        str_sub(s,1,i) %>%    
            lapply(tolower) %>%
            intersect(dict_de$terms) -> u
        if(length(u)>0){
            # j = i
            t <- append(t,u)
            # print(paste("i: ",i,"j: ",j,u,typeof(u), nchar(u))) 
        }
    }
    return (t)
}
#####################################
dict_de <- read_csv(file = paste0(tmpDir,"/wordlist-german.txt")) %>%
    lapply(tolower)
# str(dict_de)
# 
# t <- as.data.frame(dict_de[[1]])%>%
#     mutate_at(1, as.character)

# names(t) <- "terms"
# z <- t %>% filter(nchar(expressions) > 3)


names(dict_de) <- "terms"
a <- str_detect("verwundbarkeitsindex",dict_de$terms)
dict_de$terms[a]
b <- str_detect("barackensiedlung",dict_de$terms)
dict_de$terms[b]

b <- str_detect("Eingliederung",dict_de$terms)
dict_de$terms[b]



####################################3


head(t[1])
names(t) <- "expressions"

w <- t %>% filter(nchar(expressions) > 3)
nchar(t$expressions[1])

u <- as.data.frame(t)
str(u)

v <- as.data.frame(t(u)) %>%
    mutate_at(1, as.character) 
str(v$V1)
w <- filter(v,v$V1 > 3)

e <- t(as.data.frame(t))
df <- as.list(el(strsplit(dict_de,"' '")))
df - as.list(dict_de)
dd <- df[]

names(dict_de) <- c("terms")


s = "barackensiedlung"


dict_de[mapply(function(x, y) {any(x %in% y)}, tolower(sdg_1_de),"Slum")]

l <- as.list(sdg_1_de)
typeof(sdg_1_de)
t <- as.data.frame(l)
"Slum" %in% sdg_1_de
