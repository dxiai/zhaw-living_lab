
# https://r-pkgs.org/whole-game.html


library(devtools)
packageVersion("devtools")

library(tidyverse)
library(fs)
mydir = "/Users/bajk/.R"
# Set the directory to the application path
setwd(mydir)
getwd()

create_package(paste0(mydir,"/datascraper"))

use_git()

dir_info(all = TRUE, regexp = "^[.]git$") %>% select(path, type)


datascraper = paste0(mydir,"/datascraper")
load_all(datascraper)

setwd(datascraper)
use_mit_license("Daniel Bajka")
check(datascraper)
document()
check(datascraper)
install()
