dashboardBody(
  
  tags$head(tags$style(HTML("
	                .main-header .logo {
	                font-size: 12px;
                    }"))),
  
  tabItems(
    tabItem("dashboard",
            fluidRow(
              column(width = 12, height = 300,
                     box(width = NULL, 
                         withSpinner(plotlyOutput('cum_graph')
                                     ))),
              column(width = 6, 
                     box(
                       title = 'Portfolio Weight',
                       width = NULL, 
                       plotlyOutput('wts', height = 280),
                       style = "height:300px;" 
                       )),
              
              column(width = 6, 
                     box(
                       title = 'Recent Return',
                       width = NULL,
                       DT::dataTableOutput('recent'),
                       style = "height:300px; overflow-y: scroll" 
                        # ;overflow-x: scroll;
                     ))
              )
    ),
    
    tabItem("returns",
            fluidRow(
              column(width = 12, 
                     box(width = NULL, 
                         uiOutput('tz'),
                         plotlyOutput('period_graph', height = 250)
                     )),
              column(width = 12, 
                     box(width = NULL, 
                         DT::dataTableOutput('return_table'),
                         style = "height:400px; overflow-y: scroll" 
                         ))
              )
              ),
    
    tabItem("daily",
            fluidRow(
              column(width = 12, 
                     box(width = NULL, 
                         DT::dataTableOutput('return_daily_table'),
                         style = "height:700px; overflow-y: scroll" 
                     ))
              )
    ),
    
    tabItem("risk",
            fluidRow(
              column(width = 12, height = 300,
                     box(title = 'Histogram of Daily Return',
                         width = NULL, 
                         plotlyOutput('histogram')
                     )),
              column(width = 12, height = 300,
                     box(width = NULL, 
                         DT::dataTableOutput('risk_table')
                     ))
              
            )
    ),
    
    tabItem("weight",
            fluidRow(
              column(width = 12, 
                     box(width = NULL, 
                         plotlyOutput('wts_his', height = 350)
                     )),
              
              tabBox(
                width = 12,
                
                tabPanel("Historical Weight",
                         div(style = 'overflow-y:scroll;height:350px;',
                             DT::dataTableOutput('wts_table'))
                         ),
                tabPanel("Turnover", 
                         div(style = 'overflow-y:scroll;height:350px;',
                             DT::dataTableOutput('to_table'))
                         )
              )
              )
    ),
    
    tabItem("raw",
            fluidRow(
              column(width = 12, 
                     box(width = NULL, 
                         downloadButton("downloadData", "Download Data"),
                         withSpinner(tableOutput('raw_data')),
                         style = "height:800px; overflow-y: scroll" 
                     ))
            )
    ),
    
    tabItem("strategy",
            includeMarkdown('stra.Rmd'),
            tableOutput('universe')
            
    ),
    
    tabItem("profile",
            includeMarkdown('profile.Rmd')
            
    )
  )
)