server <- function(input, output) {
  # entire process is under function "rt" 
    rt <- function() { 
    dat <- input$file
    datum <- dat$datapath
    kml_layers <- ogrListLayers(datum)
    kml_cleaned <- kml_layers[!(duplicated(kml_layers) | duplicated(kml_layers, fromLast = TRUE))]
    it <- as.numeric(length(kml_cleaned))
    # iterate to deal with multiple layers
    i <- 1
    iterate_layers <- function(i){
      layer_i <-  readOGR(dsn = datum, layer = kml_cleaned[i])
      i <- i+1
      print(layer_i)
      return(layer_i)
    }
    # Preform conversion 
    apply_iterate <- lapply(i:it, iterate_layers)
    data <- ldply(apply_iterate, data.frame)
    ### Search Function:
    data2 <- data.frame(data)
    kw1 <- contains(input$param_1, vars = data$Description)
    kw2 <- contains(input$param_2, vars = data$Description)
    # combine resulting matches as numbers
    result <- combine(kw1, kw2)
    # find entry matches
    results <- data.frame(data[result,])
#
    output$downloadSearch <- downloadHandler(filename = function() {
      paste("Search_kml2csv_", as.character(input$file), ".csv", sep="")
    },
    content = function(con) {
      write.csv(results, con)
#
      output$downloadCSV <- downloadHandler(filename = function() {
        paste("kml2csv_", as.character(input$file), ".csv", sep="")
      },
      content = function(con) {
        write.csv(data, con)
      })
    })
    }
    # Control flow section
    observeEvent(input$go,
                 ifelse(input$file == input$file
                & input$param_1 >= 2
                & input$param_2 >= 2,
                        rt(),
    # Placeholder; above three conditions are not met
      print("")
      )
    )
}


                              