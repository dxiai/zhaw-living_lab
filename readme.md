# Overall ZHAW data archives data extraction
For this project data from four ZHAW data archives shall be extracted and analysed.
Structure and acessibility of all four archives is different. Therefore different data harvesting merthods will be used. Each of them will be explained
in the course of this project.

The four steps that I will follow in this project are: Obtaining data Preparing data, Analysing data, Validation

## Coding in R
There are several options with regard to good software frameworks for this project. Python, Matlab and R have a large community and development support, even when it comes to text mining. I choose R. The language is very compact and many libraries allow clear and clean development.


### ZHAW Moodle Layouts

Das ZHAW Moodle verwendet Bootstrap 4 unbeschränkt. Es können alle Funktionen von Bootstrap genutzt werden. 

> Wichtig: Moodle's markdown interpreter versteht das Quote-Präfix `>` nicht. 

> Wichtig: Moodle's markdown interpreter erlaubt kein Markdown in HTML Code. Falls Bootstrap Alerts und Buttons o.ä. verwendet werden, muss der **gesamte** Inhalte als HTML formatiert werden.

Das ZHAW Moodle verwendet die standard [fontawesome 4.7.0 free Icons](https://fontawesome.com/v4.7.0/icons/). 

Ausserdem wird ein spezieller Satz von Glyphicons verwendet. Das einzige Symbol in dieser Auswahl, das sinnvoll verwendet werden kann, ist das ZHAW Logo: Z.B. `<i class="glyphicon glyphicon-zhaw"></i>`.

## Lizenz

Dieser Kurs ist unter [CC BY NC SA 4.0](http://creativecommons.org/licenses/by-nc-sa/4.0/) lizensiert.
