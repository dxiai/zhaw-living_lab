# dtm  sdg wordcloud comparison
##################################################################


#>>>>>>>>>>>>>>>>>>>> Load required libraries and if not yet installed, install them
if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
if (!require('quanteda')) install.packages('quanteda'); library(quanteda)
if (!require('stringi')) install.packages('stringi'); library(stringi)


#>>>>>>>>>>>>>>>>>>>> variables initialisation
tmp.dir = ""; data.dir = ""; data.file = ""; d = ""; sdg_1 = {}


#>>>>>>>>>>>>>>>>>>>> directories initialization
# Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# temporary working directory
tmp.dir = paste0(getwd(),"/tmp")
# set the director< path for the data that shall be shared
setwd('..')
data.dir =  paste0(getwd(),'/data')
# Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# reset all open dev channels
graphics.off()


#>>>>>>>>>>>>>>>>>>>> Single sdg read from Excel original
ReadSdgXlsx <- function(my.path, my.lang, my.sdgNo){
    tryCatch(
        {
            # debugging only
            # my.path = data.dir; my.lang = "de"; my.sdgNo = 1
            library(readxl)
            my.tmp <-read_xlsx(paste0(data.dir,eval(paste0("/SDG",my.sdgNo,".xlsx"))),sheet = my.lang, na = 'NULL')[-1,paste0(my.lang,"_full")] %>%
                # tmp <-read_xlsx(paste0(dataDir,eval(paste0("/SDG",sdgNo,".xlsx"))),sheet = lang, na = 'NULL')[2:nrow(dataset),paste0(lang,"_full")] %>%
                as_tibble() %>%
                # clean the column by replacing NAs to ""
                mutate_at(c(1:1), ~replace(., is.na(.), ''))
            # rename column 1
            names(my.tmp) = "key"# %>%
            # duplicate column, first key, second value -> display key as name in the wordcloud
            my.tmp <- mutate(my.tmp,"value" = key) #%>%
        },
        error=function(cond) {
            # dev.off()
            message("Here's the original error message:")
            message(cond)
            # Choose a return value in case of error
            return(NA)
        },
        warning=function(cond) {
            # dev.off()
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

            # # create an sdg_x dictionary
            return(dictionary(setNames(as.list(my.tmp$key), my.tmp$value)))
        }
    )
}


#>>>>>>>>>>>>>>>>>>>>Load preprocessed Evento dataframe into memory
# data.file <- readRDS(file = paste0(tmp.dir,"/ZHAW_Evento_all_preprocessed.Rda"))
data.file <- readRDS(file = paste0(getwd(),"/3_ZHAW_Evento-content-cleaned.RDA"))
# crerate the corpus
corp = corpus(data.file,text_field = "text") # , docvars = "id")

doc.vars = docvars(corp)
head(doc.vars)
# No stemming since the words should be compared in their full lenght
dtm.full = dfm(corp, tolower=T, remove = stopwords('de'), stem = F, remove_punct=T)
# replace feacture counts per document > 1 to 1. Achieve a boolean dtm
dtm.bool <- dfm_weight(dtm.full, scheme = "boolean")
# dtm = dfm_trim(dtm_bool, min_termfreq = 1000 )

#>>>>>>>>>>>>>>>>>>>> Loop over n SDG Excel files and save the created wordclouds
for (no in 1:1){
    tryCatch(
        {
            # assign the result of function read_sdg_xlsx to a dymamically generated variable
            assign(paste0("sdg_",no),ReadSdgXlsx(data.dir,"de",no))
            # create the wordcloud
            dict.dtm = dfm_lookup(dtm.full,eval(parse(text=paste0("sdg_",no))), exclusive = TRUE)
            # dict.dtm = dfm_lookup(dtm.bool,eval(parse(text=paste0("sdg_",no))), exclusive = TRUE)
            dict.trl = convert(dict.dtm, to = "tripletlist") %>%
                as_tibble() %>%
                # add column with a reference to the line numbers corresponding to doc_vars
                mutate(idx = str_replace_all(document,"text",''))

            dd = cbind(dict.trl,doc.vars[as.numeric(dict.trl$idx),])
            # assign(paste0("df_sdg_",no),read_sdg_xlsx(data.dir,"de",no))


                # # create a dtm dataframe
                # d <- convert(dict_dtm, to = "data.frame")
            # prepare to save the wordcloud
            # png(paste0(dataDir,"/sdg_",no,".png"), width=4, height=4, units="in", res=300)
            # plot a wordcloud containing the most frequent found sdg expressions in the corpus

            # textplot_wordcloud(dict_dtm, max_words = 30)
            ############################
            # dev.off()
            # print(paste("sdg_",no,"processed, plot generated and saved as:",paste0(dataDir,"/sdg_",no,".png")))
            # Sys.sleep(1)
        },
        error=function(cond) {
            # dev.off()
            message("Here's the original error message:")
            message(cond)
            # Choose a return value in case of error
            return(NA)
        },
        warning=function(cond) {
            # dev.off()
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




df2 = group_by(dd,"document")
