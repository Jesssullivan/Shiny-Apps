library(shiny)
library(rgdal)
library(gdalUtils)

args <- commandArgs(trailingOnly = TRUE)
input <- args[1]  # file path from flask
output <- args[2]  # output directory
tmp <- args[3] # opt3 for tmp path


server <- function(input, output, tmp) {
    ogr2ogr(input, tmp, overwrite = TRUE)
    zip(zipfile=output, files=tmp)
    content = function(con) {
      file.copy(output, con)
    }
}

server(input, output, tmp)

# close from within R if possible:
Sys.sleep(2)
quit()

