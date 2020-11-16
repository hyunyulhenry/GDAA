output$universe <- function() {
  data.frame(
    'Asset' = c('Stock', 'Stock', 'Stock', 'Stock', 'Bond', 'Bond',
                'Alternative', 'Alternative', 'Alternative', 'Alternative'),
    'Specific' = c('US Stock', 'Europe Stock', 'Japan Stock', 'Emerging Stock',
                   'US Longterm Bond', 'US Int Bond', 'US REITs',
                   'Global REITs', 'Gold', 'Commodities'),
    'ETF' = c('SPY', 'IEV', 'EWJ', 'EEM', 'TLT', 'IEF',
              'IYR', 'RWX', 'GLD', 'DBC'),
    stringsAsFactors = FALSE) %>% kable(., align = "c", esacpe = F) %>%
    kable_styling(bootstrap_options =
                    c("striped", "hover", "condensed", "responsive")) %>%
    collapse_rows(columns = 1:1, valign = "middle")
}

output$recent = DT::renderDataTable({
  
  tail(data$net, 20) %>% fortify.zoo() %>%
    mutate(Returns = paste0(round(Returns, 4)* 100, '%')) %>%
    arrange(desc(Index)) %>%
    set_colnames(c('Date', 'Return')) %>%
    datatable(rownames = FALSE, 
              options = list(dom = 'tB',
                             pageLength = 1000000,
                             columnDefs = list(list(className = 'dt-right', targets = 1))
                             
              )
    )
})

output$return_table = DT::renderDataTable({
  
  req(input$date[[1]])
  
  data$net %>% apply.monthly(., Return.cumulative) %>%
    table.CalendarReturns(digits =2, geometric = TRUE) %>%
    dplyr::rename('YTD' = 'Returns') %>%
    arrange(desc(rownames(.))) %>%
    datatable(rownames = TRUE, 
              options = list(dom = 't',
                             pageLength = 1000000
              ) 
    ) %>%
    formatStyle(columns = c("YTD"), fontWeight = 'bold')
  
  
})

output$return_daily_table = DT::renderDataTable({
  
  req(input$date[[2]])
  
  df = return_selected()
  
  df %>%
    fortify.zoo() %>%
    mutate(Returns = multiply_by(round(Returns, 4), 100)) %>%
    arrange(desc(Index)) %>%
    set_colnames(c('Date', 'Return (%)')) %>%
    datatable(rownames = FALSE, extensions = 'Buttons',
              options = list(dom = 'tB',
                             buttons = c('copy', 'csv', 'excel'),
                             pageLength = 1000000)
    )
})

output$wts_table = DT::renderDataTable({
  
  data$wts %>% fortify.zoo(name = 'Date') %>%
    mutate_if(is.numeric, list(~round(., 2))) %>%
    arrange(desc(Date))  %>%
    datatable(rownames = FALSE, extensions = 'Buttons',
              options = list(dom = 'tB',
                             buttons = c('copy', 'csv', 'excel'),
                             pageLength = 1000000)
    )
              
})

output$to_table = DT::renderDataTable({
  
  data$turover %>% 
    apply.monthly(., Return.cumulative) %>%
    fortify.zoo() %>%
    set_names(c('Date', 'Turnover (%)')) %>%
    mutate_if(is.numeric, list(~round(., 4) * 100)) %>%
    arrange(desc(Date))  %>%
    datatable(rownames = FALSE, extensions = 'Buttons',
              options = list(dom = 'tB',
                             buttons = c('copy', 'csv', 'excel'),
                             pageLength = 1000000)
    )
  
})

output$raw_data = function() {
  
  data$price %>% fortify.zoo(name = 'Date') %>%
    mutate_if(is.numeric, list(~round(., 4))) %>%
    arrange(desc(Date))  %>%
    kable() %>%
    kable_styling(bootstrap_options =
                    c("striped", "hover", "condensed", "responsive"))
  
}

output$downloadData = downloadHandler(
  filename = function() {
    paste("price_data", ".csv", sep="")
  },
  content = function(file) {
    write.csv(data.frame(data$price), file)
  }
)

output$risk_table = DT::renderDataTable({
  
  req(input$date[[2]])
  
  df = return_selected()
  
  list(
    'Cumulative Return' = Return.cumulative(df) %>% numeric_to_perc(),
    'Annualized Return' = Return.annualized(df) %>% numeric_to_perc(),
    'Annualized Vol' = StdDev.annualized(df) %>% numeric_to_perc(),
    'Sharpe Ratio' = SharpeRatio.annualized(df) %>% round(., 4),
    'MDD' = maxDrawdown(df) %>% numeric_to_perc()
  ) %>% do.call(rbind, .) %>%
    data.frame() %>%
    set_colnames('Value') %>%
    mutate(Index = rownames(.)) %>%
    select(Index, Value) %>%
    datatable(rownames = FALSE,             
              options = list(dom = 't', pageLength = 1000000,
                             columnDefs = list(list(className = 'dt-right', targets = 1))
              )
    )
  

})
  