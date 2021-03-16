################################################################################### 2
#### include webDataExtractoR libraries
# if (file.exists("~/.Renviron")) {
#     message("~/.Renviron already exists!")
# } else {
#     file.create("~/.Renviron")
#     message("created ~/.Renviron")
# }
#### include webDataExtractoR libraries to .libPaths()
if (!file.exists("~/.Renviron")) {file.create("~/.Renviron")}
# append the webDataExtractoR library path to to R
cat(paste0("R_LIBS=",paste0(getwd(),"/webDataExtractoR")), file = "~/.Renviron", append = TRUE)
# Restart R Session
.rs.restartR()
####


################################################################################### 2
# Compile library
# install.packages("devtools")
library("devtools")
# devtools::install_github("klutometis/roxygen")
library(roxygen2)

# Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))# Change working directora to package folder
getwd()
setwd("~/.R")
# if library does not exists in the R main folder, create it
ifelse(!dir.exists(file.path("~/.R", "library")), dir.create(file.path("~/.R", "library")), FALSE)
# Create custom library 'dxiaiR'
ifelse(!dir.exists(file.path("~/.R/library", "webDataExtractoR")), create(file.path("~/.R/library", "webDataExtractoR")), FALSE)

setwd("~/.R/library/webDataExtractoR")
# connect the sustainability package
devtools::document()
# Set the directory to the application path
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
################################################################################### 2


# # Set the directory to the application path
# setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# getwd()
# # Create package directory
# dir.create(file.path(dirname(getwd()), "dxiaiR"))
# # Change working directora to package folder
# setwd(paste0(getwd(),"/dxiaiR"))
# getwd()
# document()

