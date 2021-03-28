# Load all required libraries and if not yet installed, install them
if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
if (!require('stringi')) install.packages('stringi'); library(stringi)


#' Extract an Evento Course ID
#'
#' This function extracts the courseID from an Evento course file.
#'
#' @param evento_txt Evento chr datafield containing the course id.
#'
#' @keywords courseDescriptor
#' @return Evento course identifier
#' EventoModId()
#'
Evento_Module_Id <- function(fEvento_course){
    # if (!require('stringi')) install.packages('stringi'); library(stringi)
   result <- tryCatch(
        {
            fEvento_course %>% stri_extract(regex = "^[^ ]*")
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
Evento_Module_Title <- function(fEvento_course){
    # if (!require('stringi')) install.packages('stringi'); library(stringi)
    result <- tryCatch(
        {
            fEvento_course %>% stri_replace_all(" ", regex = "(^.* \\()") %>%
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
Evento_Module_Text <- function(fEvento_txt){
    # if (!require('stringi')) install.packages('stringi'); library(stringi)
    tryCatch(
        {
            # s = dd$text[i]
            fEvento_txt %>%
                stri_replace_all("and", regex = "\\&")  %>%
                stri_replace_all(" ", regex = "(\\r|\\n|\\t|\\+|\\.\\.\\.|:)")  %>%
                stri_replace_first(" ///Modul: ", regex = "Modul ")  %>%
                stri_replace_first(" ///Erstellungsdatum: ", regex = "Diese Information wurde generiert am ")  %>%
                stri_replace_all(" ///Nr: ", regex = "Nr")  %>%
                stri_replace_all(" ///Bezeichnung: ", regex = "Bezeichnung")   %>%
                stri_replace_all(" ///Veranstalter: ", regex = "Veranstalter")  %>%
                stri_replace_all(" ///Studiengang: ", regex = "Studiengang")  %>%
                stri_replace_all(" ///Modulverantwortung/Leitung: ", regex = "Modulverantwortung")  %>%
                stri_replace_all(" ///Credits: ", regex = "Credits") %>%
                stri_replace_all(" ///Version: ", regex = "Beschreibung *Version")  %>%
                stri_replace_all(" ///Gueltigkeitsdatum: ", regex = "gültig ab ")   %>%
                stri_replace_all(" ///Kurs: ", regex = "Kurs ")   %>%
                stri_replace_all(" ///Kurs: ", regex = "Kurzbeschrieb ")   %>%
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
Generate_Evento_DataFrame <- function(fDataset){
    defaultW <- getOption("warn")
    options(warn = -1)
    if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
    options(warn = defaultW)

    tryCatch(
        {
          #  Initialisation of the main dataframe where all document fetures are collected
            fDataframe =  data.frame(matrix(data = NA, nrow = 0, ncol = 3))
            names(fDataframe) <- c("id","title", "text")
            fDataset <- fDataset %>%
                mutate_at(1,as.character) %>%
                mutate_at(2,as.character)
            # concateate id, title and text into a dataframe
            # for (i in 1:20){
                # i=1
            rowsDataset = nrow(fDataset)
            for (i in 1:rowsDataset){
                fDataframe[i,1] <- Evento_Module_Id(fDataset$course[i])
                fDataframe[i,2] <- Evento_Module_Title(fDataset$course[i])
                fDataframe[i,3] <- Evento_Module_Text(fDataset$text[i])
                if(round(i/50) == i/50){print(paste(i,"of",rowsDataset,"records processed"))}
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
    return(fDataframe)
}
