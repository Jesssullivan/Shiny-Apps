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
param1 <- args[3]
param2 <- args[4]

server <- function(input, output, param1, param2) {
    datum <- input
    kml_cleaned <- ogrListLayers(datum)
    it <- as.numeric(length(kml_cleaned))
    iterate_layers <- function(i){
      layer_i <- st_read(datum, kml_cleaned[i])
      return(layer_i)
    }
    rate <- 1:it
    dat <- lapply(FUN = iterate_layers, rate)
    data <- data.frame(ldply(dat))
    kw1 <- contains(param1, vars = data$description)
    kw2 <- contains(param2, vars = data$description)
    result <- c(kw1, kw2)
    filtered <- data.frame(data[result,])
    lengthdata <- 1:length(filtered[,2])
    df <- data.frame(matrix(nrow = lengthdata, ncol = 2))
    target_file <- "temp.kml"
    b <- st_sf(filtered)
    st_write(b, dsn = output, layer = "", driver="KML", delete_dsn = TRUE)
}

server(input, output, param1, param2)

# close from within R if possible:
Sys.sleep(2)
quit()
