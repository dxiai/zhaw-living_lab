# Load all required libraries and if not yet installed, install them
if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
if (!require('jsonlite')) install.packages('jsonlite'); library(jsonlite)
if (!require('data.table')) install.packages('data.table'); library(data.table)
if (!require('quanteda')) install.packages('quanteda'); library(quanteda)
if (!require('methods')) install.packages('methods'); library(methods)
if (!require('rockchalk')) install.packages('rockchalk'); library(rockchalk)
if (!require('stringi')) install.packages('stringi'); library(stringi)
if (!require('stringr')) install.packages('stringr'); library(stringr)
if (!require('rlang')) install.packages('rlang'); library(rlang)

# Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# temporary working directory
tmpDir = paste0(getwd(),"/tmp")
# set the director< path for the data that shall be shared
setwd("..")
dataDir =   paste0(getwd(),"/data")
# Reset the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))


# Function that transfroms the earlier labeled raw text into a dataframe 
moduleDataPreprocessed <- function (myText){  #,mySelection = c("lernziele","lerninhalt")){

    moduleDataframe =  data.frame(matrix(data = NA, nrow = 0, ncol = 0))
    # myText <- modulesText[1]
    myText %>%
        strsplit("///") %>%
        unlist() %>%
        matrix(byrow=TRUE) %>%
        data.frame(stringsAsFactors=FALSE) -> myDataset

    ## Features in rows
    moduleDataframe =  data.frame(matrix(data = NA, nrow = 0, ncol = 0))
    # start wirh row 2 because row one always is " "
    for(i in 2:nrow(myDataset)){
        myDataset[i,] %>%
            strsplit(":") -> x
            if(is.na(x)==FALSE){
                as.data.frame(x) -> myDatasetSplit
                names(myDatasetSplit) = ""
                as.data.frame(t(myDatasetSplit)) -> myDatasetSplit
                moduleDataframe <- rbindFill(moduleDataframe,myDatasetSplit) 
            }
            else{
                break
            }
    }
    if(!is.na(x)){
        moduleDataframe %>% 
            filter(is.na(V1)|is.na(V2)|is.null(V2)|V2 != " ") %>%
            group_by(V1) %>%
            summarise_each(funs(paste(., collapse = "//"))) %>%
            pivot_wider(names_from = V1, values_from = V2) -> moduleDataframe

        id_title = as.data.frame(c(evento_txt[i,1],evento_txt[i,2])) %>%
            t() %>%
            as.data.frame()
        row.names(id_title) = ""
        names(id_title) = c("id","title")

        moduleDataframe <- cbind(id_title,moduleDataframe)
    }
    return(moduleDataframe)
}

# This function is still a working prototype and does not stucture the JSON in a pretty formt yet
create_JSON_substructure <- function(df){
    dt <- as.data.table(df) %>%
        mutate_at(1,as.character) %>%
        mutate_at(2,as.character)
    
    modul_list = course_list = {}
    # List of all labels
    labels <- as.character(unique(df$V1))
    
    modul_labels <- c("Modul","Datum","Credits","Beschreibung")
    modul_list <- sapply(modul_labels, function(x){
        x.dt <- dt[V1==x, .(V2)]
        x.dt
    })
    names(modul_list) <- modul_labels
    
    # Create list of all modul related courses    
    course_labels <- labels[!(labels %in% modul_labels)]
    course_list <- sapply(course_labels, function(x){
        x.dt <- dt[V1==x, .(V2)]
        x.dt
    })
    
    # combine list content with list labels
    names(course_list) <- course_labels
    # create a list in a list by appending the courses as one new Kurse sublist to the module items
    modul_list$Kurse <- course_list
    # transform the list structure into JSON for further cross plöattform use 
    df_json <- toJSON(modul_list,pretty = TRUE, na="null")
    # Export the created Evento JSON file
    write(df_json,  file = paste0(tmpDir,"/df.JSON"))
}

################################################################################
# Main Programm
#########################################################
# Read the proprocessed Evento raw data and remove duplicates
evento_txt <- readRDS(file = paste0(tmpDir,"/ZHAW_Evento_all_preprocessed.Rda")) %>% distinct()
# Data filter: remove all modules without content
modulesNoDesc <- filter(evento_txt, grepl('NA', text))
# Data filter: keep all modules with content
modulesWithDesc <- filter(evento_txt, !grepl('NA', text))
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
ev_mtx_json <- toJSON(as.list(moduleDataframe))
# Save the JSON File: Not YET the FINAL PRETTY JSON structure
write(ev_mtx_json,  file = paste0(tmpDir,"/ZHAW_Evento_all_cleaned.JSON"))

# Store the digital collection as dataframe into the hidden temp directory
saveRDS(moduleDataframe, file = paste0(tmpDir,"/ZHAW_Evento_all_cleaned.Rda"))
