library(shiny)

DropDown <- function(id) {
  
  ns <- NS(id)
  #fluidPage(
  fluidRow(
    #fluidRow(
    column(6, offset = 2,
           selectInput(ns("ship_type"), "Ship Type:",
                       c( 
                         "Cargo" =  "Cargo",
                         "Fishing"  = "Fishing" ,
                         "High Special" =  "High Special",
                         "Navigation" =   "Navigation" ,
                         "Passenger"  =  "Passenger" ,
                         "Pleasure"   =  "Pleasure"   ,
                         "Tanker" = "Tanker" ,
                         "Tug"  =   "Tug" ,
                         "Unspecified" =  "Unspecified"))
           
           
    ),
    #fluidRow(
    column(2, offset = 0,
           uiOutput(ns("ship_names"))
    )
  )
}


DropDownMod <- function(id){
  
  
  ns <- NS(id)
  moduleServer(
    id,
    function(input, output, session) {
      
      output$ship_names <- renderUI({
        
        
        filtered_ship_names <- filter_ship_names(df,  sel_ship_type =  input$ship_type)
        
        
        selectInput(ns("shipname"), "Ship Name:",  filtered_ship_names)
        
        
      })
      
      return(list(sel_shipname = reactive({ input$shipname }) , sel_ship_type =   reactive({ input$ship_type })  ))
      
    })
  
}
