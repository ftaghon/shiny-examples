# library(owmr)
library(mongolite)
library(dplyr)
# owmr_settings("c3c95a52225a4460ea37410155946d30")

# Sys.setenv(OWM_API_KEY = "c3c95a52225a4460ea37410155946d30")


# Connect to server
con_bur <- mongo("Bureaux", url =
               "mongodb+srv://Ayoros:meteor17At!@cluster0.fh0qc.mongodb.net/Phimeteo")


con_met <- mongo("Meteo", url =
                   "mongodb+srv://Ayoros:meteor17At!@cluster0.fh0qc.mongodb.net/Phimeteo")


# Query data
bureaux <- con_bur$find()

meteo <- as.data.frame(con_met$find(sort = '{"dt": -1}', limit = nrow(bureaux)))



library(shiny)
library(leaflet)

ui <- fluidPage(
  leafletOutput("mymap", height=800),
  p(),
  actionButton("recalc", "Refresh")
)

server <- function(input, output, session) {

  output$mymap <- renderLeaflet({
    leaflet(data = ) %>%
      addTiles() %>%
      addMarkers(meteo$coord$lon, meteo$coord$lat, label = round(meteo$main$temp-273.15, digits = 0))
  })
}

shinyApp(ui, server)
