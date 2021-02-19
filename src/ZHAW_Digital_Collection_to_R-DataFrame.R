# Load all required libraries and if not yet installed, install them
if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
if (!require('curl')) install.packages('curl'); library(curl)
if (!require('urltools')) install.packages('urltools'); library(urltools)
if (!require('XML')) install.packages('XML'); library(XML)
if (!require('svMisc')) install.packages('svMisc'); library(svMisc)
if (!require('plyr')) install.packages('plyr'); library(plyr)

# Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# temporary working directory
tmpDir = paste0(getwd(),"/tmp")
# set the director< path for the data that shall be shared
setwd("..")
dataDir =   paste0(getwd(),"/data")
# Reset the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))


# initialise the OAI resumption pointer
resumptionPointer = ""
# Number of read cycles, gained on from running "for (i in 1:1){...}
myNoReads = 213
# Initialisation of the main dataframe where all document fetures are collected 
mydf =  data.frame(matrix(data = NA, nrow = 0, ncol = 0))
# Start the clock!
ptm <- proc.time()
# Loop over the number of readcycles to get all documents in the digital collection
for (i in 1:myNoReads) {
    # Define remote database URL
    myURL <- "https://digitalcollection.zhaw.ch/oai/request/"
    # define file location and file name of the temporary xml documents block, read from digital collection
    myfile <- tempfile()
    # extend myURL by the OAI parameters 
    myURL <- param_set(myURL, key = "verb", value = "ListRecords") %>%
    param_set(key = ifelse((resumptionPointer ==""),paste0("metadataPrefix"), paste0("resumptionToken")), value = ifelse((resumptionPointer ==""),paste0("oai_dc"), paste0("oai_dc////",resumptionPointer)))
    # Download 100 records (default) from the above defined URL
    curl_download(url= myURL, myfile, quiet = TRUE, mode = "w", handle = new_handle())
    # Document Metadata of one readcycle, in XML format 
    myRoot <- xmlParse(file = myfile) %>% xmlRoot();myRoot
    # Total number of documents in the digitl collection
    myNoDocs = as.numeric(xmlGetAttr(node = myRoot[["ListRecords"]][["resumptionToken"]],
                    name = "completeListSize"))
    # Total number of documents/records per read cycle
    myNoDocsPerRead = xmlSize(myRoot[["ListRecords"]])-1
    # Number of Readcycles in order to read in all documents
    myNoReads = floor(myNoDocs / myNoDocsPerRead)
    # resumtionpointer Update has to come AFTER the first function call
    resumptionPointer = i*myNoDocsPerRead
    # read in and transform all records collected in one read cycle. 
    for (j in 1 : myNoDocsPerRead){
        # extract the XML elements
        myTreeRecord <-myRoot[["ListRecords"]][[j]]
        myTreeHeader <- myTreeRecord[["header"]]
        myTreeMetadata <- myTreeRecord[["metadata"]][["dc"]]
        # Check if document is valid
        if (length(myTreeMetadata) > 0){       
            # Create dataframe from header and metadata
            dfHeader <- as_tibble(ldply(xmlToList(myTreeHeader, addAttributes = FALSE, simplify = TRUE), data.frame))
            dfMetadata = as_tibble(ldply(xmlToList(myTreeMetadata, addAttributes = TRUE, simplify = FALSE), data.frame))
            # concatenate dfHeader and dfMetadata    
            dfTemp <-  data.frame(matrix(data = NA, nrow = 0, ncol = 0)) %>%
                rbind.fill(dfHeader,dfMetadata) %>% 
                mutate_at(2,as.character) %>% 
                mutate_at(1,as.factor)
            # collect the values of the same levels into one list per level, transpose and transform it 
            mydf <- rbind.fill(mydf,tapply(dfTemp[,2],dfTemp[,1],lst) %>%
                t() %>%
                as.data.frame())
        } 
    }
    # Stop the clock and display the actual status
    print(paste("Docs:",i*myNoDocsPerRead,"of",myNoReads*myNoDocsPerRead,"elapsed secs:",as.character((proc.time() - ptm)[3][[1]])))
}

# Store the digital collection as dataframe into the visible data directory
# write_tsv(mydf,path = paste0(dataDir,"/ZHAW_DC_all_records.tsv"))

###########################################################################
# Store the digital collection as dataframe into the hidden temp directory
saveRDS(mydf, file = paste0(tmpDir,"/ZHAW_DC_all_records.Rda"))

# Crosscheck the saved output
# Load the above generated Evento dataframe into memory 
mydf <- readRDS(file = paste0(tmpDir,"/ZHAW_DC_all_records.Rda"))


