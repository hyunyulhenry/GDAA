output$date = renderUI({
  dateRangeInput('date', 'Date Range',
                 start = '2007-01-01',
                 end = Sys.Date(),
                 min = '2007-01-01',
                 max = Sys.Date(),
                 format = "yyyy-mm-dd",
                 separator = " - ")
})

output$tz = renderUI({
  radioGroupButtons(
    inputId = "tz",
    choices = list("Year" = 'yearly',
                   "Quarter" = 'quarterly',
                   "Month" = 'monthly'
    ),
    checkIcon = list(
      yes = tags$i(class = "fa fa-check-square", 
                   style = "color: steelblue"),
      no = tags$i(class = "fa fa-square-o", 
                  style = "color: steelblue"))
  )
})