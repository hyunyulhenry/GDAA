library(DT)
library(quadprog)
library(quantmod)
library(PerformanceAnalytics)
library(knitr)
library(kableExtra)
library(magrittr)
library(shinyWidgets)
library(lubridate)
library(stringr)
library(dplyr)
library(tidyr)
library(tibble)
library(shiny)
library(plotly)
library(shinydashboard)
library(shinycssloaders)
library(forcats)

numeric_to_perc = function(number) {
  number %>% round(., 4) %>%
    multiply_by(., 100) %>% paste(., '%')
}


return_selected = reactive({
  
  t1 = input$date[[1]] %>% as.character()
  t2 = input$date[[2]] %>% as.character()
  
  df = data$net[paste0(t1, "::", t2)]
  
  return(df)
  
})

return_period = reactive({
  
  t1 = input$date[[1]] %>% as.character()
  t2 = input$date[[2]] %>% as.character()
  
  df = data$net[paste0(t1, "::", t2)]
  
  pr = input$tz
  period = paste0('apply.', pr)
  
  df_mod = df %>%
    get(period)(., Return.cumulative) %>%
    fortify.zoo() %>%
    mutate(Index = str_sub(Index, 1, 7))
  
  return(df_mod)
  
})
