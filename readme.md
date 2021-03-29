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
- Global variable: eg. 'eventoURLsList'; concatenation of 'evento'(source specific term), URLs(value description), 'List'(type of variable). The first character of each term is written in upper letters to make the variables better readable.  
- function specific variable: eg. fDataset; 'f' is the first character of each function specific variable. The names are short and because there are only used within the function often not that self-explanatory as the global variables.
- Function name: 'evento_generate_raw_dataframe'; like the global variables, the function names are self-explanatory, but this time each term is seperated


## Sources

For structuring, developing and documentation the following sources have been used. 
- Warwick masterclass R text analysis paert one. "Kasper Welbers, VU University Amsterdam"
