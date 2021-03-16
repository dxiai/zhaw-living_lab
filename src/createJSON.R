if (!require('jsonlite')) install.packages('jsonlite'); library(jsonlite)

ID=c(100,110,200)
Title=c("aa","bb","cc")

df <- data.frame(ID, Title)
more=data.frame(Interesting=c("yes","no","yes"),new=c("no","yes","yes"),original=c("yes","yes","no"))
df$more <- more

################################### main loop   
df_json <- toJSON(df)
write(df_json,  file = paste0(tmpDir,"/df.JSON"))

myDataset
id_title = as.data.frame(c(evento_txt[i,1],evento_txt[i,2])) %>%
    t() %>%
    as.data.frame()
row.names(id_title) = ""
names(id_title) = c("id","title")

modul <- data.frame()



df <- data.frame('ArtId' = rep(c(50,70),each=4), 
                 'Year' = rep(1990:1993,times=2), 
                 'IndexBV' = c(132,94,83,101,100,100,67,133), 
                 'SE' = c(20,15,12,13,NA,NA,NA,NA))

df
str(df)
# I find data.table easier
library(data.table)
dt <- as.data.table(df)

# manually can do it, find levels of L, split data and name
L <- unique(df$ArtId)
str(df$ArtId)
ArtList <- lapply(L, function(x){
    print(x)
    x.dt <- dt[ArtId == x, .(IndexBV, SE)]
    # x.dt
})
names(ArtList) <- L

# combine in to one list
X <- list(Year=unique(dt$Year),
          ArtId = ArtList)


################################3
moduleDataframe =  data.frame(matrix(data = NA, nrow = 0, ncol = 0))

myText <- modulesText[1]
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


dt <- as.data.table(moduleDataframe) %>%
    mutate_at(1,as.character) %>%
    mutate_at(2,as.character)

###########################################################################################
modul_list = course_list = {}
# List of all labels
labels <- as.character(unique(moduleDataframe$V1))

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
