#Global packages for KML Search and Convert
library(rgdal)
library(plyr)
library(dplyr)
library(tidyverse)
library(data.table)
library(sf)

args <- commandArgs(trailingOnly = TRUE)

# UI filter
ui <- fluidPage(
  titlePanel("KML Subset:  Filter your KML"),
  sidebarLayout(
    mainPanel(
      fileInput("file", "Choose Your KML File"),
      print("You must fill out the search fields before running!"),
      textInput("param_1", "Enter keyword 1 to search for in your KML file"),
      textInput("param_2", "Ente keyword 2 to search for in your KML file"),
      width = 12
    ),
      sidebarPanel(
        actionButton("go", "Click to Run..."),
        downloadButton("downloadKML", "Click to download your filtered KML subset file")
      )
  )
)

#filter
server <- function(input, output) {
  observeEvent(input$go, {
    dat <- input$file
    datum <- dat$datapath
#    datum <- "Full_KCP_JESS_6.3.18.kml"
    kml_cleaned <- ogrListLayers(datum)
    it <- as.numeric(length(kml_cleaned))
    iterate_layers <- function(i){
      layer_i <- st_read(datum, kml_cleaned[i])
      return(layer_i)
    }
    rate <- 1:it
    dat <- lapply(FUN = iterate_layers, rate)
    data <- data.frame(ldply(dat))
    kw1 <- contains(input$param_1, vars = data$description)
    kw2 <- contains(input$param_2, vars = data$description)
    result <- c(kw1, kw2)
    filtered <- data.frame(data[result,])
    lengthdata <- 1:length(filtered[,2])
    df <- data.frame(matrix(nrow = lengthdata, ncol = 2))
    target_file <- "temp.kml"
    b <- st_sf(filtered)
    st_write(b, dsn = target_file, layer = "", driver="KML", delete_dsn = TRUE)
    output$downloadKML <- downloadHandler(filename = function() {
      paste("filtered-KML-", as.character(input$file), ".kml", sep="")
    },
    content = function(con) {
      file.copy(target_file, con)
    })
  })
}

runApp(shinyApp(ui, server), port = as.numeric(args[1]))
