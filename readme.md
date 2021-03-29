# Data harvesting from ZHAW data archives
For this project data from four ZHAW data archives shall be extracted and analysed.
Structure and acessibility of all four archives is different. Therefore different data harvesting merthods will be used. Each of them will be explained
in the course of this project.

The four steps that I will follow in this project are: Obtaining data Preparing data, Analysing data, Validation

## Coding in R
There are several options with regard to good software frameworks for this project. Python, Matlab and R have a large community and development support, even when it comes to text mining. I choose R. The language is very compact and many libraries allow clear and clean development.

### Organization of the individual scripts
Every script has the same structure.
- General description 
- External Libraries needed in the script
- External Scripts written as part of the project
- General definitions and variables
- Local functions
- Main routine

**Naming conventions:** 
- script names: e.g. '1_ZHAW_Evento-fetch-data.R' The first character is the number indicating the logical sequence of the scripts
- Global variable: e.g. 'eventoURLsList'; concatenation of 'evento'(source specific term), URLs(value description), 'List'(type of variable). The first character of each term is written in upper letters to make the variables better readable.  
- function specific variable: eg. fDataset; 'f' is the first character of each function specific variable. The names are short and because there are only used within the function often not that self-explanatory as the global variables.
- Function name: 'evento_generate_raw_dataframe'; like the global variables, the function names are self-explanatory, but this time each term is seperated

## Evento database
To extract module and course decriptions from the Evento database I choose the webscraping approach. 
The first step is the harvesting of all modules and course related urls. Function `evento_scrape_module_urls` performs this task. The resulting list needs to be cleaned and preprocessed. This is done in the function `evento_clean_url_list`. The result of the second step is used to scrape the evento database, one url after the other in order to harvest the modules content. This time consuming and preferrably overnight batch job is coxed in function `evento_scrape_module_content`
...

## Sources

For structuring, developing and documentation the following sources have been used. 
- Warwick masterclass R text analysis paert one. "Kasper Welbers, VU University Amsterdam"
