server <- function(input, output) {
  observeEvent(input$go, {
    dat <- input$file
    datum <- dat$datapath
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
    st_read(datum, "CSWA Y/O-A")
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
  cent_in <- data.frame(t(sapply(i, get_cent)))
  cent_sp <- SpatialPointsDataFrame(centroid(cent_in), df, proj4string=CRS("+proj=longlat +datum=WGS84"))
    # write out lat long as a new kml file
  results <- writeOGR(cent_sp, dsn = "KML_Centroid.kml", layer = "", driver="KML")
   # Name will not be used: dsn is filename to client
    output$downloadcent <- downloadHandler(filename = function() {
      paste("Centroid-", Sys.Date(), ".kml", sep="")
    },
      content = function(con) {
      write(results, con)
      })
    })
  }





        
