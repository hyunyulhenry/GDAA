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
library(metathis)

ui <- dashboardPage(
  
  dashboardHeader(title = 'Global Dynamic Asset Allocation',
                  titleWidth = 220
                  ),
  
  source('output_sidebar.R', local = TRUE)$value,
  source('output_body.R', local = TRUE)$value
  
)


server <- function(input, output) {
  
  source('down_db.R', local = TRUE)
  
  source('read_ui.R', local = TRUE)
  source('read_graph.R', local = TRUE)
  source('read_table.R', local = TRUE)
  source('read_pak.R', local = TRUE)
  
  output$profile <- renderUI({
    tags$iframe(
      src="https://blog.naver.com/leebisu/222420214291",
      width = "100%",
      style="height: 80vh;",
      scrolling = 'no'
    )
  })
  
  output$test = renderText(
    input$date[[1]]
  )
  
}

shinyApp(ui, server)

# rsconnect::deployApp()
