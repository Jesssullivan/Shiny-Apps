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
