#Global packages for KML Search and Convert
library(rgdal)
library(plyr)
library(dplyr)
library(tidyverse)
library(data.table)
library(sf)

args <- commandArgs(trailingOnly = TRUE)
input <- args[1]  # file path from flask
output <- args[2]  # output directory

server <- function(input, output) {
    kml_cleaned <- ogrListLayers(input)
    it <- as.numeric(length(kml_cleaned))
    iterate_layers <- function(i){
      layer_i <- st_read(input, kml_cleaned[i])
      return(layer_i)
    }
    rate <- 1:it
    data <- lapply(FUN = iterate_layers, rate)
    results <- ldply(data)
    write.csv(results, output)
}

server(input, output)

# close from within R if possible:
Sys.sleep(2)
quit()
