#'
#' | Date       | Friday Feb 12 2021
#' | Author     | Daniel Bajka, bajk@zhaw.ch
#' | Name       | ZHAW_Evento-scrape-contents.R
#' | Purpose    | Gather the documents content of all in the Input dataframe defined courses
#'                and store the contents along with the course ids and short descriptions.
#' | Input      | "1_ZHAW_Evento-fetched-urls.Rda"
#' | Output     | "2_ZHAW_Evento-scraped-content.Rda"
#' | Error      | internally handled


# Load all required libraries and if not yet installed, install them
if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
if (!require('rvest')) install.packages('rvest'); library(rvest)
if (!require('qpcR')) install.packages('qpcR'); library(qpcR)
if (!require('XML')) install.packages('XML'); library(XML)
if (!require('svMisc')) install.packages('svMisc'); library(svMisc)
if (!requireNamespace("remotes")) install.packages("remotes")
remotes::install_github("rstudio/renv")

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
eventoweb_urls <- readRDS(file = paste0(tmpDir,"/1_ZHAW_Evento-fetched-urls.Rda"))

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
    i = 1
    myURL <- tryCatch(urlExt[i,], error = function(e) returnValue())
    if(!is.null(myURL)){
        print(paste0(urlMain,myURL))
        myURL = "Evt_Pages/Brn_ModulDetailAZ.aspx?node=c594e3e5-cd9a-4204-9a61-de1e43ccb7b0&IDAnlass=1558689"
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


############################################################################
# Save the scraped documents content into the hidee3n temp directory for the next step; text wrangling
saveRDS(dd, file = paste0(tmpDir,"/A2_ZHAW_Evento-scraped-content.Rda"))

# Store the digital collection as dataframe into the visible data directory
# write.csv(dd,file = paste0(dataDir,"/2_ZHAW_Evento_scrape-content.csv"))




