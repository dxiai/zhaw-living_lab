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


###########################################################################
#' Scrape the Evento module and course urls list
#'
#' This function scrapes the evento urls.
#'
#' @param eventoMainUrl,eventoExtension main evento url and
#' its modules archive specific extension.
#'
#' @keywords evento,webscraping,
#' @return The raw list of all found evento module urls
#' evento_scrape_module_urls()
#'
EVENTO_SCRAPE_MODULE_URLS <- function(eventoUrl){
    # Load the main evento webpage into memory
    if (!require('rvest')) install.packages('rvest'); library(rvest)
    fWebResponse <- read_html(eventoUrl)

    # gather all document urls and the corresponding course ids and titles
    # ATTENTION ONLINE SCRAPING - CAN TAKE SOME TIME - preferrably over night
    fHtmlNodes <- fWebResponse %>% html_nodes("a")
    # extract the URLs
    fHtmlHref <- fHtmlNodes %>% html_attr("href")

    # transform the XML data into R usable raw dataframes
    if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
    fUrlListRaw <- as.data.frame((fHtmlHref)) %>%
        mutate_at(1,as.character)
    return(fUrlListRaw)
}


###########################################################################
#' Clean the scraped list of Evento module and course URLs
#'
#' This function prepares the evento urls list for further data processing.
#'
#' @param eventoUrlRawDf raw list of provided evento urls.
#'
#' @keywords evento,webscraping,url_extraction,
#' @return a clean eventoUrlList
#' evento_clean_url_list()
#'
evento_clean_url_list <- function(eventoUrlRawDf){
    if (!require('stringi')) install.packages('stringi'); library(stringi)
    # initiate the return dataset
    eventoUrlCleanDf =  data.frame(matrix(data = NA, nrow = 0, ncol = 1))
    # count the numbers of scraped Evento URLs
    eventoUrlRawDfRows = nrow(eventoUrlRawDf)

    # Check and clean all elements of the scraped list of Evento URL's
    for (i in 1:eventoUrlRawDfRows){
        fUrlItem = eventoUrlRawDf[i,1]
        if(stri_detect_regex(fUrlItem,"^\\.{2}") == T){
            eventoUrlCleanDf[i,1] = paste0(eventoMainUrl,fUrlItem)
            if(stri_detect_regex(fUrlItem,"^javascript") == F){
                eventoUrlCleanDf[i,1] = paste0(eventoMainUrl,fUrlItem)
            }
        }
        if(round(i/500) == i/500){print(paste(i,"of",eventoUrlRawDfRows,"records processed"))}
    }

    # delete all rows containing NA
    names(eventoUrlCleanDf) = "value"
    # provide the finally cleaned list of Evento URL's
    eventoUrlCleanDf %>% drop_na(value) -> eventoUrlCleanDf
}


######### function ############################
evento_extract_module_content <- function(myURL){
    # myURL = "https://eventoweb.zhaw.ch/Evt_Pages/Brn_ModulDetailAZ.aspx?node=c594e3e5-cd9a-4204-9a61-de1e43ccb7b0&IDAnlass=619066"
    # myURL = dfUrlsCleaned[1,1]
    fDataset = {}
    fDataset <- read_html(myURL) %>%
        # html_nodes(css = css_selector1) %>%
        html_nodes(css = css_selector2) %>%
        html_text() %>%
        as_tibble() %>%
        filter(tolower(value) != "beschreibung")
    return(fDataset)
}
###############################################

######### function ############################
evento_generate_content_item_key_df <- function(fscrapedDatasets){
    # scrapedDatasets = eventoScrapedContent
    # extract the labels from the gathered dataset
    fDataDict = {}
    fKeyList = {}
    fKey =  data.frame(matrix(data = NA, nrow = 0, ncol = 1))
    fKeyList = c("diese information wurde generiert am:","datum","modul-nr.bezeichnung","nr.", "bezeichnung","veranstalter","credits","version:")
    for (i in 1:nrow(fscrapedDatasets)){
        q <- tolower(fscrapedDatasets[i,]) %>% stri_detect_regex(fKeyList)
        if(length(fKeyList[q])>0){
            fKey[i,1] = fKeyList[q][[1]]
        } else{
            fKey[i,1] = NA
        }
    }
    fDataDict <- fKey %>% mutate(fscrapedDatasets,)
    names(fDataDict) = c("key","value")
    return(fDataDict)
}


###########################################################################
#' Extract the keys from the concateneted key value pairs of an evento dataset
#'
#' This function separates key and values of an evento dataset record into two
#' distinct columns
#' @param fItemKeyValue The concatenated key-value pair.
#'
#' @keywords evento_modules, evento_courses, data extraction, preprocessing
#' @return Evento key-value pairs
#' evento_key_value_content_labeled_df()
#'
# extract keys from value vectors in order to get a clean value(column 2) per key (column 1)
evento_key_value_content_labeled_df <- function(fItemKeyValue){
    stri_trans_tolower(fItemKeyValue[,2]) %>%
        stri_replace_all_regex(fItemKeyValue[,1],"") %>%
        stri_trim_both() %>%
        as_tibble()-> fItemKeyValue[,2]
    return(fItemKeyValue)
}


###########################################################################
#' WEBSCRAPE and preprocess the Evento module and its courses text
#'
#' This function scrapes the evento module text from the ZHAW EVENTO server,
#' extracts the module and course relevant sections and uniform the structure
#' where all records are in single dataframe column for further data processing.
#'
#' @param eventoUrlCleanDf The cleaned list of all module/course evento urls.
#'
#' @keywords evento_modules, evento_courses, scaping, data extraction, preprocessing
#' @return Evento module and course content
#' EVENTO_CONTENT_DF()
#'
EVENTO_SCRAPE_MODULE_CONTENT <- function(feventoUrlCleanD, fdebug = T){
    feventoContentDf=  data.frame(matrix(data = NA, nrow = 0, ncol = 2))
    feventoUrlCleanDfRows = nrow(feventoUrlCleanDf)
    # Web scraping of each single module - VERY TIME CONSUMING - hours !!!
    # upperLimit = 1
    if(fdebug==T){upperLimit =10}else{ upperLimit =nrow(eventoUrlCleanDf)}
    for (i in 1:upperLimit){
        feventoScrapedContent = evento_extract_module_content(feventoUrlCleanDf[i,1])
        # in case of an URL without an IDAnlass
        if(nrow(feventoScrapedContent)>0){
            feventoGeneratedContentItemKeyDf = evento_generate_content_item_key_df(feventoScrapedContent)
            evento_key_value_content_labeled_df(feventoGeneratedContentItemKeyDf) %>%
                      rbind(feventoContentDf) -> feventoContentDf
            if(round(i/1) == i/1){print(paste(i,"of",feventoUrlCleanDfRows,"records processed"))}
        }
    }
    return(feventoContentDf)
}


#####################################################################################
###### Main routine part 1 ##########################################################
# Set the directory to the application path and check it
setwd(dirname(rstudioapi::getSourceEditorContext()$path)); getwd()

# to be implemented
# Set debug mode ON/OFF. If ON, only 6 evento documents are taken to perform all functions.
#     The several outputs are stored in a debug folder

# Set the url pathes for the evento courses main page.
eventoMainUrl <- "https://eventoweb.zhaw.ch/"

# This page contains all document urls to be scraped!
eventoExtension <- "EVT_Pages/SuchResultat.aspx?node=c594e3e5-cd9a-4204-9a61-de1e43ccb7b0&Tabkey=WebTab_ModuleSuchenZHAW&Print=true"


# Evento url extraction usually takes about 70 sec.
ptm <- proc.time() # Start the clock!
eventoUrlRawDf <- EVENTO_SCRAPE_MODULE_URLS(paste0(eventoMainUrl,eventoExtension))
cat(paste("URL scraping from evento took",(proc.time() - ptm)[[3]], "secs")) # Stop the clock

# Clean the scraped list of raw evento URLs
ptm <- proc.time() # Start the clock!
eventoUrlCleanDf <- evento_clean_url_list(eventoUrlRawDf)
cat(paste("URL scraping from evento took",(proc.time() - ptm)[[3]], "secs")) # Stop the clock

# count the numbers of cleaned Evento URLs
eventoUrlCleanDfRows = nrow(eventoUrlCleanDf)

# Evento css_selector indicating the module description section
css_selector2 <- ".EditDialog_FormRow"

# web scrape the evento content, based on the cleaned evento url list
# IN order to scrape THE WHOLE EVENTO DATABASE set 'fdebug' to FALSE
eventoScrapedModuleContent = EVENTO_SCRAPE_MODULE_CONTENT(eventoUrlCleanDf, fdebug = TRUE)

######################################################################################
# Save the scraped documents content into the hidee3n temp directory for the next step; text wrangling
# saveRDS(eventoScrapedModuleContent, file = paste0(getwd(),"/ZHAW_Evento-content-basic-df.Rda"))
eventoScrapedModuleContent2 <- readRDS(file = paste0(getwd(),"/ZHAW_Evento-content-basic-df.Rda"))
######################################################################################

saveRDS(eventoScrapedModuleContent, file = paste0(getwd(),"/ZHAW_Evento-content-basic-df-DEBUG.Rda"))
eventoScrapedModuleContent <- readRDS(file = paste0(getwd(),"/ZHAW_Evento-content-basic-df-DEBUG.Rda"))
######################################################################################


# name the pre-evaluated data records
names(eventoContentDf) <- c("datum","nr", "bezeichnung","veranstalter","credits","beschreibung")




    # group_by_all()
    t() %>%
        as_tibble()
    names(fDataset) <- c("datum","nr","bezeichnung","veranstalter","credits","beschreibung")
    return (fDataset)
}


dfUrlsCleaned[1,]
w = scrape_data(dfUrlsCleaned[1,1])



# for (i in 1:rowsURLCleaned){
for (i in 1:1){
    scrape_datasets(dfUrlsCleaned[i,1]) %>%
        rbind(eventoContentDf)
    if(round(i/50) == i/50){print(paste(i,"of",rowsURL,"records processed"))}
}





############
# extract the labels from the gathered dataset
fKey =  data.frame(matrix(data = NA, nrow = 0, ncol = 1))
fKeyList = c("diese information","datum","Modul-Nr.Bezeichnung","nr.", "bezeichnung","veranstalter","credits","version:","beschreibung")

for (i in 1:nrow(fDataset)){
    # i = 1
    q <- tolower(fDataset[i,]) %>% stri_detect_regex(fKeyList);q
    fKey[i,1] = fKeyList[q]
}
fDataDict <- fKey %>% mutate(fDataset)
names(fDataDict) = c("key","value")

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


