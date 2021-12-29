library(mongolite)

# Define any Python packages needed for the app here:
PYTHON_DEPENDENCIES = c('numpy', 'pandas', 'matplotlib', 'openturns')

function(input, output) {

  # ------------------ App virtualenv setup (Do not edit) ------------------- #

  virtualenv_dir = Sys.getenv('VIRTUALENV_NAME')
  python_path = Sys.getenv('PYTHON_PATH')

  # Create virtual env and install dependencies
  reticulate::virtualenv_create(envname = virtualenv_dir, python = python_path)
  reticulate::virtualenv_install(virtualenv_dir, packages = PYTHON_DEPENDENCIES, ignore_installed=TRUE)
  reticulate::use_virtualenv(virtualenv_dir, required = T)

  # Import python functions to R
  reticulate::source_python('python_functions.py')


  # Connect to server
  con_bur <- mongo("Bureaux", url =
                     "mongodb+srv://Ayoros:meteor17At!@cluster0.fh0qc.mongodb.net/Phimeteo")

  cur_met <- mongo("Current_meteo", url =
                     "mongodb+srv://Ayoros:meteor17At!@cluster0.fh0qc.mongodb.net/Phimeteo")

  # dai_met <- mongo("Next_day_meteo", url =
  #                    "mongodb+srv://Ayoros:meteor17At!@cluster0.fh0qc.mongodb.net/Phimeteo")

  hou_met <- mongo("Next_hour_meteo", url =
                     "mongodb+srv://Ayoros:meteor17At!@cluster0.fh0qc.mongodb.net/Phimeteo")

  # his_met <- mongo("Historical_meteo", url =
  #                    "mongodb+srv://Ayoros:meteor17At!@cluster0.fh0qc.mongodb.net/Phimeteo")


  # Query data
  bureaux <- con_bur$find()
  cur_met <- cur_met$find()
  # dai_met <- dai_met$find()
  hou_met <- hou_met$find()
  # his_met <- his_met$find()

  # meteo <- as.data.frame(con_met$find(sort = '{"dt": -1}', limit = nrow(bureaux)))
  # meteo_past <- as.data.frame(con_met$find(sort = '{"dt": 1}', limit = nrow(bureaux)))

  cur_met = merge(cur_met, bureaux, by = "name")
  # dai_met = merge(dai_met, bureaux, by = "name")
  hou_met = merge(hou_met, bureaux, by = "name")

  weatherIcons <- iconList(
    "thunderstorm with light rain" = makeIcon(iconUrl="http://openweathermap.org/img/wn/11d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "thunderstorm with rain" = makeIcon(iconUrl="http://openweathermap.org/img/wn/11d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "thunderstorm with heavy rain" = makeIcon(iconUrl="http://openweathermap.org/img/wn/11d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "light thunderstorm" = makeIcon(iconUrl="http://openweathermap.org/img/wn/11d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "thunderstorm" = makeIcon(iconUrl="http://openweathermap.org/img/wn/11d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "heavy thunderstorm" = makeIcon(iconUrl="http://openweathermap.org/img/wn/11d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "ragged thunderstorm" = makeIcon(iconUrl="http://openweathermap.org/img/wn/11d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "thunderstorm with light drizzle" = makeIcon(iconUrl="http://openweathermap.org/img/wn/11d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "thunderstorm with drizzle" = makeIcon(iconUrl="http://openweathermap.org/img/wn/11d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "thunderstorm with heavy drizzle" = makeIcon(iconUrl="http://openweathermap.org/img/wn/11d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "light intensity drizzle" = makeIcon(iconUrl="http://openweathermap.org/img/wn/09d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "drizzle" = makeIcon(iconUrl="http://openweathermap.org/img/wn/09d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "heavy intensity drizzle" = makeIcon(iconUrl="http://openweathermap.org/img/wn/09d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "light intensity drizzle rain" = makeIcon(iconUrl="http://openweathermap.org/img/wn/09d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "drizzle rain" = makeIcon(iconUrl="http://openweathermap.org/img/wn/09d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "heavy intensity drizzle rain" = makeIcon(iconUrl="http://openweathermap.org/img/wn/09d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "shower rain and drizzle" = makeIcon(iconUrl="http://openweathermap.org/img/wn/09d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "heavy shower rain and drizzle" = makeIcon(iconUrl="http://openweathermap.org/img/wn/09d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "shower drizzle" = makeIcon(iconUrl="http://openweathermap.org/img/wn/09d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "light rain" = makeIcon(iconUrl="http://openweathermap.org/img/wn/10d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "moderate rain" = makeIcon(iconUrl="http://openweathermap.org/img/wn/10d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "	heavy intensity rain" = makeIcon(iconUrl="http://openweathermap.org/img/wn/10d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "very heavy rain" = makeIcon(iconUrl="http://openweathermap.org/img/wn/10d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "extreme rain" = makeIcon(iconUrl="http://openweathermap.org/img/wn/10d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "freezing rain" = makeIcon(iconUrl="http://openweathermap.org/img/wn/13d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "freezing rain" = makeIcon(iconUrl="http://openweathermap.org/img/wn/09d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "shower rain" = makeIcon(iconUrl="http://openweathermap.org/img/wn/09d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "heavy intensity shower rain" = makeIcon(iconUrl="http://openweathermap.org/img/wn/09d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "ragged shower rain" = makeIcon(iconUrl="http://openweathermap.org/img/wn/09d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "light snow" = makeIcon(iconUrl="http://openweathermap.org/img/wn/13d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "Snow" = makeIcon(iconUrl="http://openweathermap.org/img/wn/13d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "Heavy snow" = makeIcon(iconUrl="http://openweathermap.org/img/wn/13d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "Sleet" = makeIcon(iconUrl="http://openweathermap.org/img/wn/13d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "Light shower sleet" = makeIcon(iconUrl="http://openweathermap.org/img/wn/13d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "Shower sleet" = makeIcon(iconUrl="http://openweathermap.org/img/wn/13d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "Light rain and snow" = makeIcon(iconUrl="http://openweathermap.org/img/wn/13d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "Rain and snow" = makeIcon(iconUrl="http://openweathermap.org/img/wn/13d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "Light shower snow" = makeIcon(iconUrl="http://openweathermap.org/img/wn/13d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "Shower snow" = makeIcon(iconUrl="http://openweathermap.org/img/wn/13d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "Heavy shower snow" = makeIcon(iconUrl="http://openweathermap.org/img/wn/13d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "mist" = makeIcon(iconUrl="http://openweathermap.org/img/wn/50d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "Smoke" = makeIcon(iconUrl="http://openweathermap.org/img/wn/50d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "Haze" = makeIcon(iconUrl="http://openweathermap.org/img/wn/50d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "sand/ dust whirls" = makeIcon(iconUrl="http://openweathermap.org/img/wn/50d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "fog" = makeIcon(iconUrl="http://openweathermap.org/img/wn/50d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "sand" = makeIcon(iconUrl="http://openweathermap.org/img/wn/50d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "dust" = makeIcon(iconUrl="http://openweathermap.org/img/wn/50d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "volcanic ash" = makeIcon(iconUrl="http://openweathermap.org/img/wn/50d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "squalls" = makeIcon(iconUrl="http://openweathermap.org/img/wn/50d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "tornado" = makeIcon(iconUrl="http://openweathermap.org/img/wn/50d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "clear sky" = makeIcon(iconUrl="http://openweathermap.org/img/wn/01d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "few clouds" = makeIcon(iconUrl="http://openweathermap.org/img/wn/02d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "scattered clouds" = makeIcon(iconUrl="http://openweathermap.org/img/wn/03d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "broken clouds" = makeIcon(iconUrl="http://openweathermap.org/img/wn/04d@2x.png", iconAnchorX = 55, iconAnchorY = 55),
    "overcast clouds" = makeIcon(iconUrl="http://openweathermap.org/img/wn/04d@2x.png", iconAnchorX = 55, iconAnchorY = 55)
  )

  for (k in 1:nrow(bureaux)) {

    cur_met[k, "description"] = cur_met$weather[[k]]$description
    hou_met[k, "description"] = hou_met$weather[[k]]$description

  }

  output$actuel <- renderLeaflet({
    leaflet(data = cur_met) %>%
      addTiles() %>%
      addMarkers(~longitude, ~latitude, icon = weatherIcons[cur_met$description],
                 popup = paste("<b>", cur_met$name, "</b>", "<br>",
                               "<b>Description: </b>", cur_met$description, "<br>",
                               "<b>Température: </b>", cur_met$temp, "<br>",
                               sep=""))
  })

  output$previsions <- renderLeaflet({
    leaflet(data = hou_met) %>%
      addTiles() %>%
      addMarkers(~longitude, ~latitude, icon = weatherIcons[hou_met$description],
                 popup = paste("<b>", hou_met$name,"</b>","<br>",
                               "<b>Description: </b>",hou_met$description,"<br>",
                               "<b>Température: </b>",hou_met$temp,"<br>",
                               sep=""))
  })

  # output$histo_table <- renderDataTable(his_met)

  # output$cor_mat <- renderDataTable(test_function(his_met))


  # output$kernel_fit <- renderImage({
  #
  #   kernel_smoothing(his_met$temp)
  #
  #   list(src = 'myplot.png',
  #        alt = "This is alternate text")
  #
  # }, deleteFile = TRUE)

}
