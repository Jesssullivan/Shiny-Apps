#Global packages for KML Search and Convert
library(rgdal)
library(plyr)
library(dplyr)
library(tidyverse)
library(data.table)
library(sf)

args <- commandArgs(trailingOnly = TRUE)

ui <- fluidPage(
  titlePanel("Simple KML to CSV Converter"),
  sidebarLayout(
    mainPanel(
      fileInput("file", "Choose Your KML File"),
      width = 12
    ),
      sidebarPanel(
        actionButton("go", "Click to Run..."),
        downloadButton("downloadCSV", "Click to download your converted KML as a CSV file"),
        width = 6
      )
  )
)

server <- function(input, output) {
  observeEvent(input$go, {
    dat <- input$file
    datum <- dat$datapath
    kml_cleaned <- ogrListLayers(datum)
    it <- as.numeric(length(kml_cleaned))
    iterate_layers <- function(i){
      layer_i <- st_read(datum, kml_cleaned[i])
      return(layer_i)
    }
    rate <- 1:it
    data <- lapply(FUN = iterate_layers, rate)
    results <- ldply(data)
    output$downloadCSV <- downloadHandler(filename = function() {
      paste("kml2csv_", as.character(input$file), ".csv", sep="")
    },
    content = function(con) {
      write.csv(results, con)
    })
  })
}

runApp(shinyApp(ui, server), port = as.numeric(args[1]))

