output$cum_graph = renderPlotly({
  
  req(input$date[[2]])
  
  df = return_selected()
  
  # return graph
  df_ret = df %>%
    fortify.zoo() %>%
    mutate_at(vars(-Index), list(~cumprod(1+.) - 1)) %>%
    mutate(Returns =  multiply_by(Returns, 100))

  # drawdown graph
  df_dd = df %>%
    Drawdowns() %>%
    fortify.zoo() %>%
    mutate(Returns =  multiply_by(Returns, 100))


  p1 = df_ret %>%
    plot_ly(
      x = ~Index,
      y = ~Returns,
      type = 'scatter',
      mode = 'none',
      fill = 'tozeroy',
      showlegend = F) %>% layout(yaxis = list(showticklabels = F))

  p2 = df_dd %>%
    plot_ly(
      x = ~Index,
      y = ~Returns,
      type = 'scatter',
      mode = 'none',
      fill = 'tonexty',
      showlegend = F) %>% layout(yaxis = list(showticklabels = F))


  subplot(list(p1, p2), nrows = 2, heights = c(0.8, 0.2), margin = 0,
          shareX = TRUE, titleX = FALSE) %>%
    layout(yaxis = list(title = "Return (%)"), yaxis2 = list(title = "Drawdown (%)")) %>%
    layout(yaxis = list(hoverformat = ".2f", showticklabels = T))
  
})

output$wts = renderPlotly({
  
  tail(data$wts, 1) %>% data.frame() %>%
    select_if(~any(. > 0)) %>%
    mutate_all(~list(round(., 4))) %>% gather() %>%
    plot_ly(labels = ~key, values = ~value, type = 'pie',
            textposition = 'inside',
            textinfo = 'label+percent',
            insidetextfont = list(color = '#FFFFFF'),
            hoverinfo = 'text',
            marker = list(colors = colors,
                          line = list(color = '#FFFFFF', width = 2)),
            showlegend = FALSE)
  
})

output$wts_his = renderPlotly({
  
  df = data$wts
  nm = colnames(df)  

  p = df %>% fortify.zoo() %>% gather(name, weight, -Index) %>% 
    mutate(name = forcats::fct_relevel(name, nm)) %>%
    ggplot( aes(x=Index, y=weight, fill=name, text=name)) +
    geom_area( ) +
    theme(legend.position="bottom") +
    labs(fill = NULL) +
    theme_bw() +
    ylab('') +
    xlab('') +
    scale_x_date(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0),
                       labels = function(x) paste0(x*100, "%"))
  
  ggplotly(p) %>%
    layout(legend = list(orientation = "h",  x = 0.2, y = -0.1))
  
})

output$period_graph = renderPlotly({
  
  req(input$tz)
  
  df_mod = return_period()
  
  df_mod %>%
    mutate(Returns = multiply_by(round(Returns, 4), 100)) %>%
    plot_ly(x = ~Index, y = ~Returns, type = 'bar',
            text = ~Returns, textposition = 'auto') %>%
    layout(xaxis = list(title = ''),
           yaxis = list(title = 'Return (%)'))
  
})

output$histogram = renderPlotly({
  
  req(input$date[[2]])
  
  df = return_selected()
  # fit = density(df$Returns)
  
  df %>% fortify.zoo() %>%
    plot_ly(x = ~Returns, type = "histogram", name = "Histogram") 
  
})
