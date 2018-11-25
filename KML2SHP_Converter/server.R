library(shiny)
library(rgdal)
library(gdalUtils)

server <- function(input, output) {
  observeEvent(input$go, {
    dat <- input$file
    out <- input$outfile
    datum <- dat$datapath
    tempfile <- "shp"
    ogr2ogr(datum, tempfile, overwrite = TRUE)
    zip(zipfile='zip', files=tempfile)
        output$downloadcent <- downloadHandler(filename = function() {
      paste("kml2shp-", Sys.Date(), ".zip", sep="")
    },
    content = function(con) {
      file.copy('zip.zip', con)
    })
  })
}






