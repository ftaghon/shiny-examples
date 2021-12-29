library(owmr)

# owmr_settings("c3c95a52225a4460ea37410155946d30")

# Sys.setenv(OWM_API_KEY = "c3c95a52225a4460ea37410155946d30")


# Connect to server
con <- mongo("Bureaux", url =
               "mongodb+srv://Ayoros:meteor17At!@cluster0.fh0qc.mongodb.net/Phimeteo")

# Query data
mydata <- con$find()

res = data.frame()

for (k in 1:nrow(mydata)) {
  tmp <- find_cities_by_geo_point(
    lat = mydata$location$coordinates[[k]][1],
    lon = mydata$location$coordinates[[k]][2],
    cnt = 1,
    units = "metric"
  ) %>% owmr_as_tibble()

  tmp = tmp[c("name", "temp", "coord_lon", "coord_lat")]

  res = rbind(res, tmp)
}


library(shiny)
library(leaflet)

ui <- fluidPage(
  leafletOutput("mymap") #,
  # p(),
  # actionButton("recalc", "New points")
)

server <- function(input, output, session) {

  output$mymap <- renderLeaflet({
    leaflet(data = res) %>%
      addTiles() %>%
      addMarkers(~coord_lon, ~coord_lat, label = ~temp)
  })
}

shinyApp(ui, server)
