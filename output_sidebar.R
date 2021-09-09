dashboardSidebar(
  width = 220,
  sidebarMenu(
    uiOutput('date'),
    menuItem("Overview", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Return By Period", icon = icon("chart-bar"),
             menuSubItem("By Period", tabName = "returns"),
             menuSubItem("By Daily", tabName = "daily")),
    menuItem("Performance Measure", tabName = "risk", icon = icon("check-square")),
    menuItem("Weight", tabName = "weight", icon = icon("weight")),
    menuItem("Raw Data", tabName = "raw", icon = icon("database")),
    menuItem("Strategy", tabName = "strategy", icon = icon("info-circle")),
    menuItem("Profile", tabName = "profile", icon = icon("address-card")),
    br(),
    tags$div(class="f_fixed",
             a(href="https://doomoolmori.com/",
               img(src = 'dmmr.png',
                   style="width: 160px; display: block; margin-left: auto; margin-right: auto;" )
             )
    )
  )
)