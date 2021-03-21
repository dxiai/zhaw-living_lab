# Load all required libraries and if not yet installed, install them
if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
if (!require('jsonlite')) install.packages('jsonlite'); library(jsonlite)
if (!require('data.table')) install.packages('data.table'); library(data.table)
if (!require('quanteda')) install.packages('quanteda'); library(quanteda)
if (!require('methods')) install.packages('methods'); library(methods)
# if (!require('rockchalk')) install.packages('rockchalk'); library(rockchalk)
if (!require('stringi')) install.packages('stringi'); library(stringi)
if (!require('stringr')) install.packages('stringr'); library(stringr)
if (!require('rlang')) install.packages('rlang'); library(rlang)

# Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# temporary working directory
tmp.dir = paste0(getwd(),"/tmp")
# set the director< path for the data that shall be shared
setwd("..")
data.dir =   paste0(getwd(),"/data")
# Reset the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Function that transfroms the earlier labeled raw text into a dataframe
ModuleDataPreprocessed <- function (my.input){  #,mySelection = c("lernziele","lerninhalt")){

    my.dataframe =  data.frame(matrix(data = NA, nrow = 0, ncol = 0))
    # my.text <- modulesText[1]
    my.input %>%
        strsplit("///") %>%
        unlist() %>%
        matrix(byrow=TRUE) %>%
        data.frame(stringsAsFactors=FALSE) -> my.dataset

    ## Features in rows
    my.dataframe =  data.frame(matrix(data = NA, nrow = 0, ncol = 0))
    # start wirh row 2 because row one always is " "
    for(i in 2:nrow(my.dataset)){
        my.dataset[i,] %>%
            strsplit(":") -> x
            if(is.na(x)==FALSE){
                as.data.frame(x) -> my.dataset.split
                names(my.dataset.split) = ""
                as.data.frame(t(my.dataset.split)) -> my.dataset.split
                my.dataframe <- rbindFill(my.dataframe,my.dataset.split)
            }
            else{
                break
            }
    }
    if(!is.na(x)){
        my.dataframe %>%
            filter(is.na(V1)|is.na(V2)|is.null(V2)|V2 != " ") %>%
            group_by(V1) %>%
            summarise_each(funs(paste(., collapse = "//"))) %>%
            pivot_wider(names_from = V1, values_from = V2) -> my.dataframe

        id.title = as.data.frame(c(evento.txt[i,1],evento.txt[i,2])) %>%
            t() %>%
            as.data.frame()
        row.names(id.title) = ""
        names(id.title) = c("id","title")

        my.dataframe <- cbind(id.title,my.dataframe)
    }
    return(my.dataframe)
}

# This function is still a working prototype and does not stucture the JSON in a pretty formt yet
CreateJSONSubstructure <- function(my.input){
    my.datatable <- as.data.table(df) %>%
        mutate_at(1,as.character) %>%
        mutate_at(2,as.character)

    my.modul.list = my.course.list = {}
    # List of all labels
    labels <- as.character(unique(my.input$V1))

    my.modul.labels <- c("Modul","Datum","Credits","Beschreibung")
    my.modul.list <- sapply(my.modul.labels, function(x){
        my.datatable.x <- my.datatable[V1==x, .(V2)]
        my.datatable.x
    })
    names(my.modul.list) <- my.modul.labels

    # Create list of all modul related courses
    my.course.labels <- labels[!(labels %in% my.modul.labels)]
    my.course.list <- sapply(my.course.labels, function(x){
        my.datatable.x <- my.datatable[V1==x, .(V2)]
        my.datatable.x
    })

    # combine list content with list labels
    names(my.course.list) <- my.course.labels
    # create a list in a list by appending the courses as one new Kurse sublist to the module items
    my.modul.list$Kurse <- my.course.list
    # transform the list structure into JSON for further cross plöattform use
    df.json <- toJSON(my.modul.list,pretty = TRUE, na="null")
    # Export the created Evento JSON file
    write(df.json,  file = paste0(tmp.dir,"/df.JSON"))
}

################################################################################
# Main Programm
#########################################################
# Read the proprocessed Evento raw data and remove duplicates
evento_txt <- readRDS(file = paste0(tmp.dir,"/ZHAW_Evento_all_preprocessed.Rda")) %>% distinct()
# Data filter: remove all modules without content
modulesNoDesc <- filter(evento.txt, grepl('NA', text))
# Data filter: keep all modules with content
modulesWithDesc <- filter(evento.txt, !grepl('NA', text))
# Data filter: remove all modules defined as Nachprüfung
modulesNachprfg <- filter(modulesWithDesc, grepl('Nachprüfung', text))
# Data filter: all remaining datasets are valid and used for further analysis
modulesRegular <- filter(modulesWithDesc, !grepl('Nachprüfung', text))
# Select the column with text
modulesText <- modulesRegular[,3]
# Prepare an empty dataframe for the collected and cleaned evento data
moduleDataframe =  data.frame(matrix(data = NA, nrow = 0, ncol = 0))
# for (i in 1:10){
for (i in 1:nrow(modulesRegular)){
    moduleDataframe <- rbindFill(moduleDataframe,moduleDataPreprocessed(modulesText[i]))
    if(round(i/20) == i/20){print(i)}
}
# Transform the dataframe into a JSON structure
ev_mtx_json <- toJSON(as.list(moduleDataframe[1:16]))
# Save the JSON File: Not YET the FINAL PRETTY JSON structure
write(ev_mtx_json,  file = paste0(tmp.dir,"/ZHAW_Evento_all_cleaned.JSON"))

# Store the digital collection as dataframe into the hidden temp directory
saveRDS(moduleDataframe, file = paste0(tmp.dir,"/ZHAW_Evento_all_cleaned.Rda"))
