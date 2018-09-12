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
