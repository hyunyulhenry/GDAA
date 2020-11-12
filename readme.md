# Global Dynamic Asset Allocation by Henry
shiny for Global Dynamic Asset Allocation 

To run the project either fork/download the files and run the **app.R**-file, or in R run
```{r}
shiny::runGitHub('GDAA', 'hyunyulhenry')
```
In order to run the project properly, you need to have the following packages installed.

To install all packages you can also use
```{r}
pkg = c('shiny', 'DT', 'quadprog', 'highcharter', 'quantmod', 'PerformanceAnalytics',
        'shinythemes', 'knitr', 'kableExtra', 'magrittr', 'shinyWidgets',
        'lubridate', 'stringr', 'dplyr', 'tidyr', 'plotly', 'tibble')

new.pkg = pkg[!(pkg %in% installed.packages()[, "Package"])]
if (length(new.pkg))
  install.packages(new.pkg, dependencies = TRUE)
sapply(pkg, require, character.only = TRUE)
```
