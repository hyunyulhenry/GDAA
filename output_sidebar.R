dashboardSidebar(
  width = 220,
  sidebarMenu(
    uiOutput('date'),
    menuItem("Overview", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Return by period", tabName = "returns", icon = icon("chart-bar")),
    menuItem("Risk Stat", tabName = "risk", icon = icon("check-square")),
    menuItem("Weight", tabName = "weight", icon = icon("weight")),
    menuItem("Raw Data", tabName = "raw", icon = icon("database")),
    menuItem("Strategy", tabName = "strategy", icon = icon("info-circle")),
    menuItem("Profile", tabName = "profile", icon = icon("address-card"))
  )
)