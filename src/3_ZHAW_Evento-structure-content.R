#'
#' | Date       | Saturday Mrz 27 2021
#' | Author     | Daniel Bajka, bajk@zhaw.ch
#' | Name       | ZHAW_Evento-structure-contents.R
#' | Purpose    | .....
#' | Input      | "2_ZHAW_Evento-scraped-content.Rda"
#' | Output     | "3_ZHAW_Evento-structured-content.Rda"
#' | Error      | internally handled


#### Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
#### temporary working directory
tmpDir = paste0(getwd(),"/tmp")
#### set the director< path for the data that shall be shared
setwd("..")
dataDir =   paste0(getwd(),"/data")
#### Reset the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))


#### load required webscraping libraries
source(paste0(getwd(),"/library_sustainability.R"))


#### input file name, has to be of type RDA  #Generation of this file to be checked!!!!! 270321
inputFile = "1_ZHAW_Evento-docs-content.Rda"
#### input file name, has to be of type RDA
outputFile = "3_ZHAW_Evento-structured-content.Rda"


######### Main routine
#### import the raw evento_docs content as .rda
evento_txt <- readRDS(file = paste0(tmpDir,"/",inputFile))
#### generate an id, title and text containing dataframe
evento_id_title_text_df <-  Generate_Evento_DataFrame(evento_txt)
#### save the generated evento id, title and text dataframe
saveRDS(evento_id_title_text_df, file = paste0(tmpDir,"/",outputFile))
