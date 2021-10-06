library(shiny)
library(shiny.semantic)

#SETUP

library(geosphere)
library(leaflet)
library(data.table)
library(tidyverse)
library(glue)
source('utils.R', local = TRUE)
source('drop_down_modules.R', local = TRUE)
options(digits=15)


# PREPARING THE DF
df <- fread('ships.csv',  
            encoding = 'UTF-8', 
            select = c('ship_type', 'SHIPNAME', 'LON', 'LAT', 'DATETIME')) %>%
  clean_df()




#DEFINING THE APP

ui <- semanticPage(
  
  titlePanel(h1("Ship Movement", align = "center")),
  DropDown("drop_down"),
  h4(textOutput('distance_info')),
  leafletOutput('greatest_distance_map',width="100%", height="700px")
  
     
)    



server <- function(input, output, session) {
  
  
  #filtering the dataframe
  selection <- DropDownMod("drop_down")
  df_i <- reactive({
    
    req(selection$sel_ship_type())
    req(selection$sel_shipname())
    
    df_i <- df %>%
      filter(ship_type == selection$sel_ship_type() , shipname == selection$sel_shipname())
    
    req(nrow(df_i) > 0)
    
    filter_longuest_distance(df_i)

    
  })
  
  
  #printing information
  output$distance_info <- renderText({
    
    distance_to_display <- round(df_i()$distance , 2)
    speed_to_display <- round(df_i()$speed, 2)
    
    "Traveled {distance_to_display} meters at {speed_to_display} Km/h" %>% glue()
    
  })
  
  
  #defining map
  output$greatest_distance_map <-  renderLeaflet({
    

    req(df_i())
    req(nrow(df_i()) > 0)
    
    leaflet() %>%
      addTiles() %>%
      addMarkers(lng=df_i()$lon_l1, lat=df_i()$lat_l1,  label="Start") %>%
      addMarkers(lng=df_i()$lon, lat=df_i()$lat, label = 'End')
    
     
  })
  
  
  
}

shinyApp(ui, server)


