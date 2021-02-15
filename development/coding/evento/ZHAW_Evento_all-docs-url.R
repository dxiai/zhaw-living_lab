#' 
#' | Date       | Friday Feb 12 2021
#' | Author     | Daniel Bajka, bajk@zhaw.ch
#' | Name       | ZHAW_Evento_all-doc-urls.R
#' | Purpose    | Gather the urls of the whole evento document moduls and courses library
#'                and store the urls along with the course ids and short descriptions into
#'                a dataframe as a source for the documents content extraction.    
#' | Input      | None 
#' | Output     | "ZHAW_Evento_all-docs-url.Rda"
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
courses <- links %>% html_text("href")

# transform the XML data into R usable raw dataframes
dfUrls <- as.data.frame((urls))
dfCourses <- as.data.frame((courses))

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
saveRDS(mydf[1:nrow(mydf),], file = paste0(getwd(),"/ZHAW_Evento_all-docs-url.Rda"))

# Crosscheck the saved output
# Load the above generated Evento dataframe into memory 
# evento <- readRDS(file = paste0(getwd(),"/ZHAW_Evento_all-docs-url.Rda"))
