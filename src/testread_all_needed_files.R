



evento_urls <- readRDS(file = paste0(getwd(),"/1_ZHAW_Evento-fetched-urls.Rda"))

digital_collection_txt <- readRDS(file = paste0(tmpDir,"/ZHAW_DC_All_Records.Rda"))

evento_txt <- readRDS(file = paste0(tmpDir,"/ZHAW_Evento-scrape-content.Rda"))

evento_dtm <- read_csv(file = paste0(dataDir,"/ZHAW_Evento_term_freq_matrix.csv"))

evento_ngram <- read_csv(file = paste0(dataDir,"/ZHAW_Evento_term_sdg_context.csv"))
