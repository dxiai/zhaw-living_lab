#'
#' | Date       | Friday Feb 12 2021
#' | Author     | Daniel Bajka, bajk@zhaw.ch
#' | Name       | ZHAW_Evento_all-doc-contents.R
#' | Purpose    | Gather the documents content of all in the Input dataframe defined courses
#'                and store the contents along with the course ids and short descriptions.
#' | Input      | "ZHAW_Evento_all-docs-url.Rda"
#' | Output     | "ZHAW_Evento_all-docs-content.Rda"
#' | Error      | internally handled


# Load all required libraries and if not yet installed, install them
if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
if (!require('rvest')) install.packages('rvest'); library(rvest)
if (!require('qpcR')) install.packages('qpcR'); library(qpcR)
if (!require('XML')) install.packages('XML'); library(XML)
if (!require('svMisc')) install.packages('svMisc'); library(svMisc)

# Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# temporary working directory
tmpDir = paste0(getwd(),"/tmp")
# set the director< path for the data that shall be shared
setwd("..")
dataDir =   paste0(getwd(),"/data")
# Reset the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Set the url pathes for the evento courses main page.
# This page contains all document urls to be scraped!
urlMain <- "https://eventoweb.zhaw.ch/"
eventoweb_urls <- readRDS(file = paste0(tmpDir,"/ZHAW_Evento_all-docs-url.Rda"))

urlExt <- as.data.frame(eventoweb_urls[,1]) %>%
    mutate_at(1,as.character)
names(urlExt) = c("urls")

# initialization of a temporary dataframe used while scraping the evento database
dd <-  data.frame(matrix(data = NA, nrow = 0, ncol = 2))
# setting the column names
names(dd) =  c("course","text")

# Parameter 'myDocStartPntr' and 'myDocEndPntr' can be adjusted to the individual goal
# Furthermore the from evento gained list of all actual document URLs 'urlExt'
# can be organized prior looping over all or a subset of the in evento stored document library.
myDocStartPntr = 1
myDocEndPntr = 2 # nrow(urlExt)

# Main loop to read in [1:nrow(urlExt)] documents
for (i in myDocStartPntr:myDocEndPntr){ # nrow(urlExt)){
    myURL <- tryCatch(urlExt[i,], error = function(e) returnValue())
    if(!is.null(myURL)){
        print(paste0(urlMain,myURL))
        html_data <- tryCatch(read_html(paste0(urlMain,myURL)) %>% html_table(fill = TRUE), error = function(e) returnValue())
        if(!is.null(html_data)){
            t <- as.data.frame(t(c(str_extract(html_data[[10]][["X1"]][1],"^.*"), html_data[[10]][1][5,])))
            names(t) = c("course","text")
            dd <- rbind(dd,t)
        }
    }
    # Used to bypass a Robot detection. 'myTimeStrecher' can be adapted according to the Robot sensitivity
    # myTimeStrecher = 3
    # Sys.sleep(abs(rnorm(1))* myTimeStrecher)

    # While scraping the printout of the record number used as a visual progress control
    print(nrow(dd))
}

# Store the digital collection as dataframe into the visible data directory
write.csv(dd,file = paste0(dataDir,"/ZHAW_Evento_all-docs-content.csv"))


############################################################################
# Save the scraped documents content into the hidee3n temp directory for the next step; text wrangling
saveRDS(dd, file = paste0(tmpDir,"/ZHAW_Evento_all-docs-content.Rda"))


############################################################################
# Crosscheck the saved output
# Load the above generated Evento dataframe into memory

digital_collection_txt <- readRDS(file = paste0(tmpDir,"/ZHAW_DC_All_Records.Rda"))

evento_txt <- readRDS(file = paste0(tmpDir,"/ZHAW_Evento_all-docs-content.Rda"))

evento_dtm <- read_csv(file = paste0(dataDir,"/ZHAW_Evento_term_freq_matrix.csv"))
evento_ngram <- read_csv(file = paste0(dataDir,"/ZHAW_Evento_term_sdg_context.csv"))

