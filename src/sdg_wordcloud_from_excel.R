# dtm  sdg wordcloud comparison
##################################################################
#
# # connect the sustainability package
# setwd("~/.R/library/dxiaiR")
# # connect the sustainability package
# devtools::document()
# # Restart R Session
# .rs.restartR()

# # Load all required libraries and if not yet installed, install them
if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
if (!require('quanteda')) install.packages('quanteda'); library(quanteda)

# variables initialisation
tmpDir = ""; dataDir = ""; dataFile = ""; d = ""; sdg_1 = {}

# Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# temporary working directory
tmpDir = paste0(getwd(),"/tmp")
# set the director< path for the data that shall be shared
setwd('..')
dataDir =  paste0(getwd(),'/data')
# Load preprocessed Evento dataframe into memory
dataFile <- readRDS(file = paste0(tmpDir,"/ZHAW_Evento_all_preprocessed.Rda"))
# No stemming since the words should be compared in their full lenght
dtm = dfm(dataFile$text, tolower=T, remove = stopwords('de'), stem = F, remove_punct=T)


############################ Single list search from Excel original
read_sdg_xlsx <- function(mypath, lang, sdgNo){
    library(readxl)
    lang="de"

    tmp <-read_xlsx(paste0(dataDir,eval(paste0("/SDG",sdgNo,".xlsx"))),sheet = lang, na = 'NULL')[2:nrow(dataset),paste0(lang,"_full")] %>%
        as_tibble() %>%
    # clean the column by replacing NAs to ""
        mutate_at(c(1:1), ~replace(., is.na(.), ''))
    # rename column 1
    names(tmp) = "key"# %>%
    # duplicate column, first key, second value -> display key as name in the wordcloud
    tmp <- mutate(tmp,"value" = key) #%>%
    # # create an sdg_x dictionary
    return(dictionary(setNames(as.list(tmp$key), tmp$value)))
}

# Loop over n SDG Excel files and save the created wordclouds
for (no in 1:16){
    tryCatch(
        {
            assign(paste0("sdg_",no),read_sdg_xlsx(dataDir,"de",no))
            # create the wordcloud
            dict_dtm = dfm_lookup(dtm,eval(parse(text=paste0("sdg_",no))), exclusive = TRUE)
            # create a dtm dataframe
            d <- convert(dict_dtm, to = "data.frame")
            # prepare to save the wordcloud
            png(paste0(tmpDir,"/sdg_",no,".png"), width=4, height=4, units="in", res=300)
            # plot a wordcloud containing the most frequent found sdg expressions in the corpus

            textplot_wordcloud(dict_dtm, max_words = 30)
            ############################
            dev.off()
            print(no)
            Sys.sleep(1)
        },
        error=function(cond) {
            message("Here's the original error message:")
            message(cond)
            # Choose a return value in case of error
            return(NA)
        },
        warning=function(cond) {
            message("Here's the original warning message:")
            message(cond)
            # Choose a return value in case of warning
            return(NULL)
        },
        finally={
            # NOTE:
            # Here goes everything that should be executed at the end,
            # regardless of success or error.
            # If you want more than one expression to be executed, then you
            # need to wrap them in curly brackets ({...}); otherwise you could
            # just have written 'finally=<expression>'
            message("Some other message at the end")
        }
    )
}
