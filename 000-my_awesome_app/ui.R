library(leaflet)
library(shinydashboard)

# fluidPage(
#   titlePanel("Phimeteo"),
#
#   tabsetPanel(
#     tabPanel("météo actuelle", leafletOutput("actuel", height=800)),
#     tabPanel("Prévisions à 3H", leafletOutput("previsions", height=800)),
#     tabPanel("Historique")
#     ),
#
#   actionButton("recalc", "Refresh")
# )

dashboardPage(
  dashboardHeader(title = "Phimeteo"),
  dashboardSidebar(actionButton("recalc", "Refresh")),
  dashboardBody(
    # tabBox(
    #   width = 12,
      tabsetPanel(
      tabPanel(
        "météo actuelle",
        tags$style(type = "text/css", "#actuel {height: calc(100vh - 80px) !important;}"),
        leafletOutput("actuel")
      ),
      tabPanel(
        "Prévisions à 3H",
        tags$style(type = "text/css", "#previsions {height: calc(100vh - 80px) !important;}"),
        leafletOutput("previsions")
      ) #,
      # tabPanel(
      #   "Historique",
      #   dataTableOutput("histo_table")),
      # tabPanel(
      #   "Analyse",
      #   dataTableOutput("cor_mat")),
      # tabPanel(
      #   "openturns",
      #   plotOutput("kernel_fit"))
    )
  )
)
