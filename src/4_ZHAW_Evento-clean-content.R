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
if (!require('plyr')) install.packages('plyr'); library(plyr)

# Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# temporary working directory
dir.tmp = paste0(getwd(),"/tmp")
# set the director< path for the data that shall be shared
setwd("..")
dir.data =   paste0(getwd(),"/data")
# Reset the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
getwd()

# Function that transfroms the earlier labeled raw text into a dataframe
ModuleDataPreprocessed <- function (my.input){  #,mySelection = c("lernziele","lerninhalt")){

    # debug only
    my.input = modules.text[i]

    my.dataFrame =  data.frame(matrix(data = NA, nrow = 0, ncol = 0))
    # my.text <- modulesText[1]
    my.input %>%
        strsplit("///") %>%
        unlist() %>%
        matrix(byrow=TRUE) %>%
        data.frame(stringsAsFactors=FALSE) -> my.dataSet

    ## Features in rows
    # my.dataframe =  data.frame(matrix(data = NA, nrow = 0, ncol = 0))
    # start wirh row 2 because row one always is " "
    for(i in 2:nrow(my.dataSet)){
        my.dataSet[i,] %>%
            strsplit(":") -> x
            if(is.na(x)==FALSE){
                as.data.frame(x) -> my.dataSetSplit
                names(my.dataSetSplit) = ""
                as.data.frame(t(my.dataSetSplit)) -> my.dataSetSplit
                my.dataFrame <- rbind.fill(my.dataFrame,my.dataSetSplit)
            }
            else{
                break
            }
    }
    if(!is.na(x)){
        my.dataFrame %>%
            filter(is.na(V1)|is.na(V2)|is.null(V2)|V2 != " ") %>%
            group_by(V1) %>%
            # across(~paste(., collapse = "//"))  %>%
            summarise_each(funs(paste(., collapse = "//"))) %>%
            pivot_wider(names_from = V1, values_from = V2) -> my.dataFrame

        id.title = as.data.frame(c(evento.txt[i,1],evento.txt[i,2])) %>%
            t() %>%
            as.data.frame()
        row.names(id.title) = ""
        names(id.title) = c("id","title")

        my.dataFrame <- cbind(id.title,my.dataFrame)
    }
    return(my.dataFrame)
}

# This function is still a working prototype and does not stucture the JSON in a pretty formt yet
CreateJSONSubstructure <- function(my.input){
    my.dataTable <- as.data.table(my.input) %>%
        mutate_at(1,as.character) %>%
        mutate_at(2,as.character)

    my.modulList = my.courselist = {}
    # List of all labels
    my.inputLabels <- as.character(unique(my.input$V1))

    my.modulLabels <- c("Modul","Datum","Credits","Beschreibung")
    my.modulList <- sapply(my.modulLabels, function(x){
        my.dataTable.x <- my.dataTable[V1==x, .(V2)]
        my.dataTable.x
    })
    names(my.modulList) <- my.modulLabels

    # Create list of all modul related courses
    my.courseLabels <- my.inputLabels[!(my.inputLabels %in% my.modulLabels)]
    my.courseList <- sapply(my.courseLabels, function(x){
        my.dataTable.x <- my.dataTable[V1==x, .(V2)]
        my.dataTable.x
    })

    # combine list content with list labels
    names(my.courseList) <- my.courseLabels
    # create a list in a list by appending the courses as one new Kurse sublist to the module items
    my.modulList$Kurse <- my.courseList
    # transform the list structure into JSON for further cross plöattform use
    df.json <- toJSON(my.modulList,pretty = TRUE, na="null")
    # Export the created Evento JSON file
    write(df.json,  file = paste0(dir.tmp,"/df.JSON"))
}

################################################################################
# Main Programm
#########################################################
# Read the proprocessed Evento raw data and remove duplicates
evento.txt <- readRDS(file = paste0(getwd(),"/2_ZHAW_Evento-content-structured.RDA")) %>% distinct()
# Data filter: remove all modules without content
modules.noDesc <- filter(evento.txt, grepl('NA', text))
# Data filter: keep all modules with content
modules.withDesc <- filter(evento.txt, !grepl('NA', text))
# Data filter: remove all modules defined as Nachprüfung
modules.nachPrfg <- filter(modules.withDesc, grepl('Nachprüfung', text))
# Data filter: all remaining datasets are valid and used for further analysis
modules.regular <- filter(modules.withDesc, !grepl('Nachprüfung', text))
# Select the column with text
modules.text <- modules.regular[,3]
# Prepare an empty dataframe for the collected and cleaned evento data
modules.dataFrame =  data.frame(matrix(data = NA, nrow = 0, ncol = 0))
# for (i in 1:100){
for (i in 1:floor(nrow(modules.regular)/15)){
    modules.dataFrame <- rbind.fill(modules.dataFrame,ModuleDataPreprocessed(modules.text[i]))
    # modules.dataFrame <- rbind.fill(modules.dataFrame,as.data.frame(modules.text[i]))
    if(round(i/20) == i/20){print(i)}
}
# Transform the dataframe into a JSON structure
evento.mtxJson <- toJSON(as.list(modules.dataFrame[1:16]))
# Save the JSON File: Not YET the FINAL PRETTY JSON structure
write(evento.mtxJson,  file = paste0(dir.tmp,"/3_ZHAW_Evento-content-cleaned.JSON"))

# Store the digital collection as dataframe into the hidden temp directory
# saveRDS(modules.dataFrame, file = paste0(dir.tmp,"/ZHAW_Evento_all_cleaned.Rda"))
saveRDS(modules.dataFrame, file = paste0(getwd(),"/3_ZHAW_Evento-content-cleaned.RDA"))
