# Load all required libraries and if not yet installed, install them
if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
if (!require('jsonlite')) install.packages('jsonlite'); library(jsonlite)
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

# Function that cleans the rw data and marks labels/keywords like "Kurs" in order to transform this data to a dataset
course_text <- function(x){
    x %>% 
        stri_replace_all("and", regex = "\\&") %>%
        stri_replace_all("", regex = "(\\r|\\n|\\t|[[:punct:]]|\\+)")%>%
        stri_replace_all(":Studiengang,", regex = "Studiengang") %>%
        stri_replace_all(':Modul,', regex = "Modul") %>%
        stri_replace_all(":Kurs,", regex = "Kurs") %>%
        stri_replace_all(":Gruppenunterricht,", regex = "Gruppenunterricht") %>%
        stri_replace_all(":Lerninhalt,", regex = "Lerninhalt") %>%
        stri_replace_all(":Lernziele,", regex = "Lernziele") %>%
        stri_replace_all(":Veranstalter,", regex = "Veranstalter") %>%
        stri_replace_all(":Beschreibung,", regex = "Beschreibung") %>%
        stri_replace_all(":Bezeichnung,", regex = "Bezeichnung") %>%
        stri_replace_all(" ", regex = "[[:digit:]]") %>%
        stri_replace_all(" ", regex = "[[:upper:]]{1,}(?=([[:upper:]]{1}[[:lower:]]{1}))") %>%
        stri_replace_all(" ", regex = " [[:alnum:]] {1,3}") %>%
        stri_replace_all(" ", regex = "[[:upper:]]{2}") %>%
        stri_replace_all(" ", regex = "( \\w{1,2}) ") %>%
        stri_replace_all(" ", regex = " \\w{1,2} ") %>%
        stri_replace_all(" ", regex = "[[:blank:]]{2,}") %>%
        stri_replace_all(",", regex = " ,")
}

myText = evento_txt
myText[26,]
# Function that transfroms the earlier labeled raw text into a dataframe 
myDataFrameFromRawText <- function (myText,mySelection = c("lernziele","lerninhalt")){
    myDataframe =  data.frame(matrix(data = NA, nrow = 1, ncol = 0))
    
    course_text(myText[,3]) %>%
        strsplit(":") %>%
        unlist() %>%
        matrix(byrow=TRUE) %>%
        data.frame(stringsAsFactors=FALSE) -> myDataset
        # data.frame(matrix(unlist(b), byrow=TRUE),stringsAsFactors=FALSE)
        # mutate_at(1,as.character) -> myDataset
    

    ## Features in columns
    # for(i in 2:nrow(myDataset)){
    #     myDataset[i,] %>%
    #         strsplit(",") %>% 
    #         as.data.frame() -> myDatasetSplit
    #     if (tolower(myDatasetSplit[1,1]) %in% mySelection){
    #         names(myDatasetSplit) = myDatasetSplit[1,1]
    #         # t(myDatasetSplit) -> myDatasetSplit %>%
    #         slice(myDatasetSplit, 2) -> myDatasetSplit
    #         # print(myDatasetSplit)
    #         myDataframe <- cbind(myDataframe,myDatasetSplit)
    #     
    #     }
    # }
    
    ## Features in rows
    # for(i in 923:925){
    for(i in 2:nrow(myDataset)){
        myDataset[i,] %>%
            strsplit(",") %>% 
            as.data.frame() -> myDatasetSplit
            names(myDatasetSplit) = ""
            t(myDatasetSplit) -> myDatasetSplit
            myDataframe <- rbind(myDataframe,myDatasetSplit)
    # }
    if(is.na.data.frame(myDataframe) == FALSE){
        myDataframe %>% 
            group_by(V1) %>%
            summarise_each(funs(paste(., collapse = "//"))) %>%
            pivot_wider(names_from = V1, values_from = V2) -> myDataframe
        
        id_title = as.data.frame(c(evento_txt[i,1],evento_txt[i,2])) %>%
            t() %>%
            as.data.frame()
        row.names(id_title) = ""
        names(id_title) = c("id","title")
        
        myDataframe <- cbind(id_title,myDataframe)
    }
    
    }
    return(myDataframe)
}



#########################################################
# Read the proprocessed Evento raw data.
evento_txt <- readRDS(file = paste0(tmpDir,"/ZHAW_Evento_all_preprocessed.Rda"))
ev_id <-evento_txt[1,1];ev_id
ev_title <-evento_txt[1,2];ev_title
ev_text <-evento_txt[1,3];ev_text
# ev_text <-evento_txt[3,3];ev_text


myData =  data.frame(matrix(data = NA, nrow = 0, ncol = 0))
for (i in 1:100){
    # for (i in 1:nrow(evento_txt)){
    myData <- rbindFill(myData,myDataFrameFromRawText(evento_txt[i,]))
    print(i)
}
   
ev_mtx_json <- toJSON(myData)
write(ev_mtx_json,  file = paste0(tmpDir,"//ZHAW_EV_Test_3.JSON"))




str(ev_df)
ev_df[2,]

#########################################
my_text <- course_text(ev_text_list);my_text
#########################################
l <- list(my_text);l
# Load the above generated Evento dataframe into memory 

digital_collection_txt <- readRDS(file = paste0(tmpDir,"/ZHAW_DC_All_Records.Rda"))
one_line <- digital_collection_txt[5:6,]
my_dc_json <- toJSON(one_line);my_dc_json
## Save the JSON to file
write(my_dc_json,  file = paste0(tmpDir,"//ZHAW_DC_Test_2.JSON"))


# Store the digital collection as dataframe into the hidden temp directory
saveRDS(mydf, file = paste0(tmpDir,"/ZHAW_Evento_all_preprocessed.Rda"))



s = c(list('Modul', 'Architektur und Städtebaugeschichte Diese Information wurde generiert'))
a <- as.data.frame(list(s));a
names(a) <- c("id","cont")
my_ev_json <- toJSON(a);my_ev_json
write(my_ev_json, file = paste0(tmpDir,"//Test_3.JSON"))






evento_dtm <- read_csv(file = paste0(dataDir,"/ZHAW_Evento_term_freq_matrix.csv"))
evento_ngram <- read_csv(file = paste0(dataDir,"/ZHAW_Evento_term_sdg_context.csv"))

