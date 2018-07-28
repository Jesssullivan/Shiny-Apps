#setwd("/srv/shiny-server")
server <- function(input, output) {
  #output$WaitTime3 <- renderText(paste("Seconds before downloading your file!"))
  #output$WaitTime2 <- reactive(paste(wait))
  observeEvent(input$go, {
    dat <- input$file
    datum <- dat$datapath
    kml_layers <- ogrListLayers(datum)
    it <- as.numeric(length(kml_layers))
   # output$wait <- reactive(print(sum(as.numeric(length(kml_layers) + 5))))
    # func to deal with multiple layers
    i <- 1
    iterate_layers <- function(i){
      layer_i <-  readOGR(datum, layer = kml_layers[i])
      i <- i+1
      return(layer_i)
    }
    # Preform conversion 
    apply_iterate <- lapply(i:it, iterate_layers)
    data <- ldply(apply_iterate, data.frame)
    # Write out for KML -> CSV only download
    ### Search Function:
    kw1 <- contains(input$param_1, vars = data$Description)
    kw2 <- contains(input$param_2, vars = data$Description)
    # combine resulting matches as numbers
    result <- combine(kw1, kw2)
    # find entry matches
    results <- data.frame(data[result,])
      #
    output$downloadCSV <- downloadHandler(filename = function() {
      paste("kml2csv_", as.character(input$file), ".csv", sep="")
    },
    content = function(con) {
      write.csv(data, con)
    })
      output$downloadSearch <- downloadHandler(filename = function() {
        paste("Search_kml2csv_", as.character(input$file), ".csv", sep="")
      },
      content = function(con) {
        write.csv(results, con)
    })
  })
}
