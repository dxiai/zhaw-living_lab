#'
#' | Date       | Friday Feb 12 2021
#' | Author     | Daniel Bajka, bajk@zhaw.ch
#' | Name       | ZHAW_Evento-fetch-urls.R
#' | Purpose    | Gather the urls of the whole evento document moduls and courses library
#'                and store the urls along with the course ids and short descriptions into
#'                a dataframe as a source for the documents content extraction.
#' | Input      | None
#' | Output     | "1_ZHAW_Evento-fetched-urls.Rda"
#' | Error      | internally handled

# Set the directory to the application path and check it
setwd(dirname(rstudioapi::getSourceEditorContext()$path)); getwd()

# Load all required libraries and if not yet installed, install them
if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
if (!require('rvest')) install.packages('rvest'); library(rvest)
if (!require('qpcR')) install.packages('qpcR'); library(qpcR)
if (!require('XML')) install.packages('XML'); library(XML)
if (!require('svMisc')) install.packages('svMisc'); library(svMisc)

# Set the url pathes for the evento courses main page.
# This page contains all document urls to be scraped!
eventoweb_url <- "https://eventoweb.zhaw.ch/"
eventoweb_ext <- "EVT_Pages/SuchResultat.aspx?node=c594e3e5-cd9a-4204-9a61-de1e43ccb7b0&Tabkey=WebTab_ModuleSuchenZHAW&Print=true"
# Load the main evento webpage into memory
response <- read_html(paste0(eventoweb_url,eventoweb_ext))

# gather all document urls and the corresponding course ids and titles
links <- response %>% html_nodes("a")
urls <- links %>% html_attr("href")

# transform the XML data into R usable raw dataframes
dfUrls <- as.data.frame((urls)) %>%
    mutate_at(1,as.character)

#****************************************
# courses <- links %>% html_text("href")

# gather all course content, given the url
 # url_data <- paste0(urlMain,myURL)
 # myURL = "Evt_Pages/Brn_ModulDetailAZ.aspx?node=c594e3e5-cd9a-4204-9a61-de1e43ccb7b0&IDAnlass=1558689"
#****************************************
#*

# Evento css_selectors indicating the module description section
css_selector1 <- "#ctl00_WebPartManager1_gwpctlModulDetail_ctlModulDetail_ctlModulDetail_edbAnlassWebAnsicht1558689slc_container"
css_selector2 <- ".EditDialog_FormRow"


fDataset = {}


# Clean the gathered URL-list
missingURL = "../Evt_pages/"
mainURL = "https://eventoweb.zhaw.ch/"
dfUrlsCleaned =  data.frame(matrix(data = NA, nrow = 0, ncol = 1))
rowsURLs = nrow(dfUrls)

for (i in 1:rowsURLs){
# for (i in 1:3){
    fEvento_url = dfUrls[i,1]
    if(stri_detect_regex(fEvento_url,"^\\.{2}") == T){
        dfUrlsCleaned[i,1] = paste0(mainURL,fEvento_url)

        if(stri_detect_regex(fEvento_url,"^javascript") == F){
            dfUrlsCleaned[i,1] = paste0(mainURL,missingURL,fEvento_url)
        }
    }
    if(round(i/500) == i/500){print(paste(i,"of",rowsURLs,"records processed"))}
}
# delete all rows containing NA
names(dfUrlsCleaned) = "value"
dfUrlsCleaned %>% drop_na(value) -> dfUrlsCleaned




rowsURLCleaned = nrow(dfUrlsCleaned)
fDataframe =  data.frame(matrix(data = NA, nrow = 0, ncol = 6))
names(fDataframe) <- c("datum","nr", "bezeichnung","veranstalter","credits","beschreibung")

dfUrlsCleaned[1,]
w = scrape_data(dfUrlsCleaned[1,1])

# for (i in 1:rowsURLCleaned){
for (i in 1:1){
    scrape_data(dfUrlsCleaned[i,1]) %>%
                    rbind(fDataframe)
    if(round(i/50) == i/50){print(paste(i,"of",rowsURL,"records processed"))}
}

scrape_data <- function(myURL){
    myURL = "https://eventoweb.zhaw.ch/Evt_Pages/Brn_ModulDetailAZ.aspx?node=c594e3e5-cd9a-4204-9a61-de1e43ccb7b0&IDAnlass=619066"
    fDataset <- read_html(myURL) %>%
        # html_nodes(css = css_selector1) %>%
        html_nodes(css = css_selector2) %>%
        html_text() %>%
        as_tibble() %>%
        filter(tolower(value) != "beschreibung")
        t() %>%
        as_tibble()
    names(fDataset) <- c("datum","nr","bezeichnung","veranstalter","credits","beschreibung")
    return (fDataset)
}

a = {}
a = scrape_data(paste0(urlMain,myURL))

#**********************************

# transform the XML data into R usable raw dataframes
dfUrls <- as.data.frame((urls))
# dfCourses <- as.data.frame((courses))

# re-organize the document links and descriptions into one single dataframe
mydd <- as.data.frame(cbind(dfUrls,dfCourses)) %>%
    mutate_at(1,as.character) %>%
    mutate_at(2,as.character) %>%
    mutate_at(2,function(x) trimws(x,"b"))

# set the column names according to their content
names(mydd) <- c("urls","courses")

# filter rows with valid urls only. This step is the last before saving the Evento document list
mydf <- subset(mydd,courses !="") %>%
    filter(str_detect(urls,"^..\\/"))

# Store the digital collection as dataframe into the application directory
saveRDS(mydf[1:nrow(mydf),], file = paste0(getwd(),"/1_ZHAW_Evento-fetched-urls.Rda"))


