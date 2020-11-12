source('read_pak.R')

# data = readRDS('db.Rds')

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
  
}

shinyApp(ui, server)
