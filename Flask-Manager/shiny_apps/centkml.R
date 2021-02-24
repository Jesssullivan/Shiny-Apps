library(shiny)
library(rgdal)
library(sf)

args <- commandArgs(trailingOnly = TRUE)
input <- args[1]  # file path from flask
output <- args[2]  # output directory

server <- function(input, output) {
    datum <- input
    kml_cleaned <- ogrListLayers(datum)
    it <- as.numeric(length(kml_cleaned))
    iterate_layers <- function(i){
      layer_i <- st_read(datum, kml_cleaned[i])
      print(layer_i)
      return(layer_i)
    }
    rate <- 1:it
    data <- data.frame(t(data.frame(sapply(rate, iterate_layers))))
    # extract centroid with WGS84 CRS
    lengthdata <- as.numeric(length(data))
    # pull lat/lon function
    func <- function(i) {
      lm <- as.numeric(length(unlist(data$geometry)))
      getGeo <- array(unlist(data$geometry), dim = c(3,lm))
      getGeo <- array(unlist(getGeo), dim=c(lm, 3))
      coords <- cbind(getGeo[1], getGeo[2])
      return(coords)
    }
    # generate centroid with geosphere function from table of coords

}

server(input, output)
# close from within R if possible:
Sys.sleep(2)
quit()