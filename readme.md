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
- Script names: e.g. `1_ZHAW_Evento-fetch-data.R` The first character is the number indicating the logical sequence of the scripts
- Global variable: e.g. `eventoURLsList`; concatenation of `evento`(source specific term), `URLs`(value description), `List`(type of variable). The first character of each term is written in upper letters to make the variables better readable.  
- Function specific variable: eg. `fDataset`; `f` is the first character of each function specific variable. The names are short and because there are only used within the function often not that self-explanatory as the global variables.
- Function name (lowercase): `evento_generate_raw_dataframe`; like the global variables, the function names are self-explanatory, but this time each term is seperated
- Function name(uppercase): `EVENTO_SCRAPE_MODULE_CONTENT` All uppercase means that this function can have an impact on the runtime behavior of third-party systems such as web servers and thus negatively influence the work of third parties during the required function execution time.

## Evento database
Evento Webdata extaction has to be done by using webscraping. There is no API available that would support this process. That is the reason why webscraping is chosen to gather the evento modules and courses data.  
The first step is the harvesting of all modules and course related urls. Function `evento_scrape_module_urls` performs this task. The resulting list containd not only the required urls and therefore needs to be cleaned. This is done in the function `evento_clean_url_list`. The cleaned urls list is then used to scrape the evento database, one url after the other in order to harvest the modules content. This time intense process is also computational intense and might slow down the works of others actually interacting with Evento. That the reason, why Webscraping should preferrably be done overnight. This crutual functions are `EVENTO_SCRAPE_MODULE_CONTENT`. Default a debug flag is set to `TRUE`, limiting the data scraping to 10 documents. 

| index| key | value |
|------|-----|-------|
| 1 | diese information wurde generiert am: | 31.03.2021 |
| 2 | nr. | a.ba.ar.ar+st4.10hs| 
| 3 | bezeichnung | architektur- und städtebaugeschichte 4|
| 4 | veranstalter | aa studiengang architektur |
| 5 | credits | 2 |
| 6 | version: | 1.0 gültig ab 01.08.2013das modul architektur- und städtebaugeschichte 4 besteht aus den beiden submodulen architekturgeschichte 4 und städtebaugeschichte 4. |
| 7 | nr. | a.ba.ar.ar4.10hs.g |
| 8 | bezeichnung | architekturgeschichte 4 - gruppenunterricht |
| 9 | veranstalter | aa studiengang architektur |
| 10 | version: | 1.0 gültig ab 01.08.2013 lernziele die studierenden soll |
| 11 | nr. | a.ba.ar.st4.10hs.g |
| 12 | bezeichnung | städtebaugeschichte 4 - gruppenunterricht |
| 13 | veranstalter | aa studiengang architektur |
| 14 | version: | 1.0 gültig ab 01.08.2013 lernziele die studierenden sollen die wichtigsten städtebaulichen phänomene der nachkriegszeit in ihrem politischen, sozialen, ökonomischen und kulturellen kontext erklären. der kurs soll auch als zusammenfassung dienen, zur wiederholung der gesamten 4 semester städtebaugeschichte. lerninhalt wiederaufbau in deutschland und frankreich xxx sprawl chandigard, brasilia, dhaka, canberra um 1968 learning from las vegas/new york zürich: eine zusammenfassung |

...

## Sources

For structuring, developing and documentation the following sources have been used. 
- Warwick masterclass R text analysis paert one. "Kasper Welbers, VU University Amsterdam"
