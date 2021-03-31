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



# Load all required libraries and if not yet installed, install them
# if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
# if (!require('rvest')) install.packages('rvest'); library(rvest)
# if (!require('qpcR')) install.packages('qpcR'); library(qpcR)
# if (!require('XML')) install.packages('XML'); library(XML)
# if (!require('svMisc')) install.packages('svMisc'); library(svMisc)
# if (!require('rlist')) install.packages('rlist'); library(rlist)


# Set the directory to the application path and check it
setwd(dirname(rstudioapi::getSourceEditorContext()$path)); getwd()
# Set the url pathes for the evento courses main page.
eventoMainUrl <- "https://eventoweb.zhaw.ch/"
# This page contains all document urls to be scraped!
eventoExtension <- "EVT_Pages/SuchResultat.aspx?node=c594e3e5-cd9a-4204-9a61-de1e43ccb7b0&Tabkey=WebTab_ModuleSuchenZHAW&Print=true"


#' Scrape the Evento module and course urls list
#'
#' This function scrapes the evento urls.
#'
#' @param eventoMainUrl,eventoExtension main evento url and its modules archive specific extension.
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


#############

#' Clean the scraped list of Evento module and course urls
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
                eventoUrlCleanDf[i,1] = paste0(eventoMainURL,fUrlItem)
            }
        }
        if(round(i/500) == i/500){print(paste(i,"of",eventoUrlRawDfRows,"records processed"))}
    }

    # delete all rows containing NA
    names(eventoUrlCleanDf) = "value"
    # provide the finally cleaned list of Evento URL's
    eventoUrlCleanDf %>% drop_na(value) -> eventoUrlCleanDf
}

###### Main routine part 1
#Start the clock!
ptm <- proc.time()
eventoUrlRawDf <- EVENTO_SCRAPE_MODULE_URLS(paste0(eventoMainUrl,eventoExtension))
# Stop the clock
cat(paste("URL scraping from evento took",(proc.time() - ptm)[[3]], "secs"))
eventoUrlCleanDf <- evento_clean_url_list(eventoUrlRawDf)

# count the numbers of cleaned Evento URLs
eventoUrlCleanDfRows = nrow(eventoUrlCleanDf)
# initiate the dataframe containing the module/course content


# Evento css_selectors indicating the module description section
# css_selector1 <- "#ctl00_WebPartManager1_gwpctlModulDetail_ctlModulDetail_ctlModulDetail_edbAnlassWebAnsicht1558689slc_container"
css_selector2 <- ".EditDialog_FormRow"


######### function ############################
EVENTO_SCRAPE_MODULE_CONTENT <- function(myURL){
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
evento_generate_content_item_key_df <- function(scrapedDatasets){
    scrapedDatasets = eventoScrapedContent
    # extract the labels from the gathered dataset
    fDataDict = {}
    fKeyList = {}
    fKey =  data.frame(matrix(data = NA, nrow = 0, ncol = 1))
    fKeyList = c("diese information wurde generiert am:","datum","modul-nr.bezeichnung","nr.", "bezeichnung","veranstalter","credits","version:")
    for (i in 1:nrow(scrapedDatasets)){
        q <- tolower(scrapedDatasets[i,]) %>% stri_detect_regex(fKeyList)
        if(length(fKeyList[q])>0){
            fKey[i,1] = fKeyList[q][[1]]
        } else{
            fKey[i,1] = NA
        }
    }
    fDataDict <- fKey %>% mutate(scrapedDatasets,)
    names(fDataDict) = c("key","value")
    return(fDataDict)
}
###############################################

###### Main routine part 2
# name the pre-evaluated data records
names(eventoContentDf) <- c("datum","nr", "bezeichnung","veranstalter","credits","beschreibung")
eventoUrlCleanDf[4,]
eventoScrapedContent = EVENTO_SCRAPE_MODULE_CONTENT(eventoUrlCleanDf[2,1])
eventoGeneratedContentItemKeyDf = evento_generate_content_item_key_df(eventoScrapedContent)

# extract keys from value vectors in order to get a clean value(column 2) per key (column 1)
evento_key_value_content_labeled_df <- function(fItemKeyValue){
    stri_trans_tolower(fItemKeyValue[,2]) %>%
        stri_replace_all_regex(fItemKeyValue[,1],"") %>%
        stri_trim_both() %>%
        as_tibble()-> fItemKeyValue[,2]
    return(fItemKeyValue)
}

eventoContentDf=  data.frame(matrix(data = NA, nrow = 0, ncol = 2))
for (i in 20001:28765){
    # for (i in 1:nrow(eventoUrlCleanDf)){
    eventoScrapedContent = EVENTO_SCRAPE_MODULE_CONTENT(eventoUrlCleanDf[i,1])
    # in case of an URL without an IDAnlass
    if(nrow(eventoScrapedContent)>0){
        eventoGeneratedContentItemKeyDf = evento_generate_content_item_key_df(eventoScrapedContent)
        evento_key_value_content_labeled_df(eventoGeneratedContentItemKeyDf) %>%
                  rbind(eventoContentDf) -> eventoContentDf
        if(round(i/1) == i/1){print(paste(i,"of",eventoUrlCleanDfRows,"records processed"))}
    }
}

# Save the scraped documents content into the hidee3n temp directory for the next step; text wrangling
saveRDS(eventoContentDf, file = paste0(getwd(),"/ZHAW_Evento-content-basic-df.Rda"))

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


