server <- function(input, output) {
rt <- function () { 
  observeEvent(input$go, {
#  setwd("~/Shiny-Apps-master/Shiny-Apps-master/KML-Centroid-Generator"
     dat <- input$file
    datum <- dat$datapath
 #   datum <- "FullKML.kml"
    # read kml section
    kml_layers <- ogrListLayers(datum)
    kml_cleaned <- kml_layers[!(duplicated(kml_layers))]
    lengthCleaned <- as.numeric(length(kml_cleaned))
    it <- as.numeric(length(kml_cleaned)) 
    iterate_layers <- function(i){
      layer_i <- st_read(datum, kml_cleaned[i])
      print(layer_i)
      return(layer_i)
    }
    # process kml with layers
    data <- data.frame(sapply(1:it, iterate_layers))
    # extract centroid with WGS84 CRS
    df <- data.frame(1, 1)
    lengthdata <- as.numeric(length(data))
# pull lat/lon function
  get_cent <- function(i) {
      getGeo <- as.table(t(as.matrix(data[i])))
      getGeo <- (unlist(getGeo[3]))
      coords <- cbind(getGeo[1], getGeo[2])
      return(coords)
  }
  # generate centroid with geosphere function from table of coords
  i <- 1:lengthdata
  cent_in <- data.frame(t(as.matrix(sapply(i, get_cent))))
  cent_sp <- SpatialPointsDataFrame(centroid(cent_in), df, proj4string=CRS("+proj=longlat +datum=WGS84"))
    # write out lat long as a new kml file
  writeOGR(cent_sp, dsn = "kml.kml", layer = "", driver="KML")
  })
  output$down <- downloadHandler(filename = "Centroid_File.kml", 
                                 content = function(file) {
                                  file.copy("kml.kml", file)
                                 })
  }
observeEvent(input$go,
                    rt()
                    )
}




        
