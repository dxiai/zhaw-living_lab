# Load all required libraries and if not yet installed, install them
if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
# if (!require('rvest')) install.packages('rvest'); library(rvest)
# if (!require('qpcR')) install.packages('qpcR'); library(qpcR)
# if (!require('XML')) install.packages('XML'); library(XML)
# if (!require('svMisc')) install.packages('svMisc'); library(svMisc)
if (!require('stringi')) install.packages('stringi'); library(stringi)


#' Extract an Evento Course ID
#'
#' This function extracts the courseID from an Evento course file.
#'
#' @param s Evento chr datafield containing the course id.
#'
#' @keywords courseDescriptor
#' @return Evento course identifier
#' EventoModId()
#'
EventoModId <- function(s){
    # if (!require('stringi')) install.packages('stringi'); library(stringi)
   result <- tryCatch(
        {
            s %>% stri_extract(regex = "^[^ ]*")
        },
        error=function(cond) {
            # dev.off()
            message("Here's the original EventoModId error message:")
            message(cond)
            # Choose a return value in case of error
            return(NA)
        },
        warning=function(cond) {
            # dev.off()
            message("Here's the original EventoModId warning message:")
            message(cond)
            # Choose a return value in case of warning
            # return(NA)
        },
        finally={
            # NOTE:
            # Here goes everything that should be executed at the end,
            # regardless of success or error.
            # If you want more than one expression to be executed, then you
            # need to wrap them in curly brackets ({...}); otherwise you could
            # just have written 'finally=<expression>'

            # # create an sdg_x dictionary

        }
    )
    return(result)
}


#' Extract an Evento Course Title
#'
#' This function extracts the course title from an Evento course file.
#'
#' @param s Evento chr datafield containing the course id.
#'
#' @keywords courseDescriptor
#' @return Evento course title
#' EventoModTitle()
#'
EventoModTitle <- function(s){
    # if (!require('stringi')) install.packages('stringi'); library(stringi)
    result <- tryCatch(
        {
            s %>% stri_replace_all(" ", regex = "(^.* \\()") %>%
                stri_replace_all("", regex = "\\).*$") %>%
                trimws(which = "both")
        },
        error=function(cond) {
            # dev.off()
            message("Here's the original EventoModTitle error message:")
            message(cond)
            # Choose a return value in case of error
            return(NA)
        },
        warning=function(cond) {
            # dev.off()
            message("Here's the original EventoModTitle warning message:")
            message(cond)
            # Choose a return value in case of warning
            # return(NA)
        },
        finally={
            # NOTE:
            # Here goes everything that should be executed at the end,
            # regardless of success or error.
            # If you want more than one expression to be executed, then you
            # need to wrap them in curly brackets ({...}); otherwise you could
            # just have written 'finally=<expression>'

            # # create an sdg_x dictionary
        }
    )
    return(result)
}



#' Extract and preprocess the Evento module and its courses text
#'
#' This function prepares the evento module text for further data processing.
#'
#' @param s Evento chr datafield containing the course id.
#'
#' @keywords moduleDescriptor
#' @return Evento module and course text
#' EventoModText()
#'
EventoModText <- function(s){
    # if (!require('stringi')) install.packages('stringi'); library(stringi)
    tryCatch(
        {
            # s = dd$text[i]
        s %>%
            stri_replace_all("and", regex = "\\&")  %>%
            stri_replace_all(" ", regex = "(\\r|\\n|\\t|\\+|\\.\\.\\.|:)")  %>%
            stri_replace_first(" ///Modul: ", regex = "Modul ")  %>%
            stri_replace_first(" ///Erstellungsdatum: ", regex = "Diese Information wurde generiert am ")  %>%
            stri_replace_all(" ///Nr: ", regex = "Nr")  %>%
            stri_replace_all(" ///Bezeichnung: ", regex = "Bezeichnung")   %>%
            stri_replace_all(" ///Veranstalter: ", regex = "Veranstalter")  %>%
            stri_replace_all(" ///Studiengang: ", regex = "Studiengang")  %>%
            stri_replace_all(" ///Credits: ", regex = "Credits") %>%
            stri_replace_all(" ///Version: ", regex = "Beschreibung *Version")  %>%
            stri_replace_all(" ///Gueltigkeitsdatum: ", regex = "gültig ab ")   %>%
            stri_replace_all(" ///Kurs: ", regex = "Kurs ")   %>%
            stri_replace_all(" ///Credits: ", regex = "Credits")   %>%
            stri_replace_all(" ///Lerninhalt: ", regex = "Lerninhalt")  %>%
            stri_replace_all(" ///Lernziele: ", regex = "Lernziele")    %>%
            stri_replace_all(" ///Seminar: ", regex = "Seminar")  %>%
            stri_replace_all(" ///Werkplan: ", regex = "Werkplan")   %>%
            stri_replace_all(" ", regex = "[[:blank:]]{2,}") %>%
            stri_replace_all(",", regex = " ,") -> s1

            s2 <- stri_locate_all(s1,regex = "(?<=[[:digit:]]{4})[[:upper:]]")
            for (i in 1:length(s2[[1]][,2])){
               s3 <- paste0(substr(s1,1,s2[[1]][i,2]-1)," ///Beschreibung: ",substr(s1,s2[[1]][i,2],nchar(s1[1])))
            }
        },
        error=function(cond) {
            # dev.off()
            message("Here's the original EventoModText error message:")
            message(cond)
            # Choose a return value in case of error
            return(NA)
        },
        warning=function(cond) {
            # dev.off()
            message("Here's the original EventoModText warning message:")
            message(cond)
            # Choose a return value in case of warning
            return(NA)
        },
        finally={
            # NOTE:
            # Here goes everything that should be executed at the end,
            # regardless of success or error.
            # If you want more than one expression to be executed, then you
            # need to wrap them in curly brackets ({...}); otherwise you could
            # just have written 'finally=<expression>'

            # # create an sdg_x dictionary
        }
    )
    return(s3)
}


#' Create a data frame from the preprocessed Evento Web content
#'
#' This function prepares the evento module text for further data processing.
#'
#' @param x number of documents to transfer into a dataset.
#' @param dd preprocessed dataset.
#'
#' @keywords moduleDescriptor
#' @return Evento module and course data frame
#' EventoDataFrame()
#'
GenerateEventoDataFrame <- function(dd){
    # dd = evento_txt

    defaultW <- getOption("warn")
    options(warn = -1)
    if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
    options(warn = defaultW)

    tryCatch(
        {
          #  Initialisation of the main dataframe where all document fetures are collected
            df =  data.frame(matrix(data = NA, nrow = 0, ncol = 3))
            names(df) <- c("id","title", "text")
            dd <- dd %>%
                mutate_at(1,as.character) %>%
                mutate_at(2,as.character)
            # concateate id, title and text into a dataframe
            for (i in 1:20){
            # for (i in 1:nrow(dd)){
                # i=1
                df[i,1] <- EventoModId(dd$course[i])
                df[i,2] <- EventoModTitle(dd$course[i])
                df[i,3] <- EventoModText(dd$text[i])
                if(round(i/50) == i/50){print(paste("records processed:",i))}
            }
        },
        error=function(cond) {
            # dev.off()
            message("Here's the original GenerateEventoDataFrame error message:")
            message(cond)
            # Choose a return value in case of error
            return(NA)
        },
        warning=function(cond) {
            # dev.off()
            message("Here's the original GenerateEventoDataFrame warning message:")
            message(cond)
            # Choose a return value in case of warning
            # return(NA)
        },
        finally={
            # NOTE:
            # Here goes everything that should be executed at the end,
            # regardless of success or error.
            # If you want more than one expression to be executed, then you
            # need to wrap them in curly brackets ({...}); otherwise you could
            # just have written 'finally=<expression>'

            # # create an sdg_x dictionary

        }
    )
    return(df)
}



#### MAIN code ######################

# Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# temporary working directory
tmpDir = paste0(getwd(),"/tmp")
# set the director< path for the data that shall be shared
setwd("..")
dataDir =   paste0(getwd(),"/data")
# Reset the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# input file name, has to be of type RDA  #Generation of this file to be checked!!!!! 270321
inputFile = "1_ZHAW_Evento-docs-content.Rda"
# input file name, has to be of type RDA
outputFile = "2_ZHAW_Evento-id-title-text.Rda"

evento_txt <- readRDS(file = paste0(tmpDir,"/",inputFile))
evento_id_title_text_df <-  GenerateEventoDataFrame(evento_txt)
saveRDS(evento_id_title_text_df, file = paste0(tmpDir,"/",outputFile))





#### DEBUG only ######################
DEBUG_EventoModText <- function(s){
    if (!require('stringi')) install.packages('stringi'); library(stringi)
    s %>%
        stri_replace_all("and", regex = "\\&") -> t1; df_temp = as.data.frame(t1)
        t1 %>% stri_replace_all(" ", regex = "(\\r|\\n|\\t|\\+|\\.\\.\\.|:)") -> t2; df_temp = as.data.frame(t2)
        t2 %>% stri_replace_first(" ///Modul: ", regex = "Modul ") -> t3; df_temp = as.data.frame(t3)
        t3 %>% stri_replace_first(" ///Erstellungsdatum: ", regex = "Diese Information wurde generiert am ") -> t4; df_temp = as.data.frame(t4)
        t4 %>%stri_replace_all(" ///Nr: ", regex = "Nr") -> t5; df_temp = as.data.frame(t5)
        t5 %>% stri_replace_all(" ///Bezeichnung: ", regex = "Bezeichnung")  -> t6; df_temp = as.data.frame(t6)
        t6 %>% stri_replace_all(" ///Veranstalter: ", regex = "Veranstalter") -> t7; df_temp = as.data.frame(t7)
        t7 %>% stri_replace_all(" ///Studiengang: ", regex = "Studiengang") -> t8; df_temp = as.data.frame(t8)
        t8 %>% stri_replace_all(" ///Credits: ", regex = "Credits") -> t9; df_temp = as.data.frame(t9)
        t9 %>% stri_replace_all(" ///Version: ", regex = "Beschreibung *Version")  -> t10; df_temp = as.data.frame(t10)
        t10 %>% stri_replace_all(" ///Gueltigkeitsdatum: ", regex = "gültig ab ")  -> t11; df_temp = as.data.frame(t11)
        t11 %>% stri_replace_all(" ///Kurs: ", regex = "Kurs ")  -> t12; df_temp = as.data.frame(t12)
        t12 %>% stri_replace_all(" ///Credits: ", regex = "Credits")  -> t13; df_temp = as.data.frame(t13)
        t13 %>% stri_replace_all(" ///Lerninhalt: ", regex = "Lerninhalt")  -> t14; df_temp = as.data.frame(t14)
        t14 %>% stri_replace_all(" ///Lernziele: ", regex = "Lernziele")   -> t15; df_temp = as.data.frame(t15)
        t15 %>% stri_replace_all(" ///Seminar: ", regex = "Seminar")  -> t16; df_temp = as.data.frame(t16)
        t16 %>% stri_replace_all(" ///Werkplan: ", regex = "Werkplan")  -> t17; df_temp = as.data.frame(t17)
        t17 %>% stri_replace_all(" ", regex = "[[:blank:]]{2,}")  -> t18; df_temp = as.data.frame(t18)
        t18 %>% stri_replace_all(",", regex = " ,")   -> t19; df_temp = as.data.frame(t19)

    y <- stri_locate_all(t19,regex = "(?<=[[:digit:]]{4})[[:upper:]]")
    for (i in 1:length(y[[1]][,2])){
        t20 <- paste0(substr(t19,1,y[[1]][i,2]-1)," ///Beschreibung: ",substr(t19,y[[1]][i,2],nchar(t19[1])))
    }
}
