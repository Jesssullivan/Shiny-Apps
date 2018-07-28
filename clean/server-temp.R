server <- function(input, output) {
  observeEvent(input$go, {
    dat <- input$file
    Data <- fread(dat$datapath)
    #Define count and iterations:
    count <- as.numeric(count(Data[,1]))
    it <- 1:count+1
    #efine loop beginning and loop each cell:
    i <- 1
    for(i in it) {
      ifelse(Data[i,1] == "", Data[i,1] <- Data[i-1,1], i+1)
    }
    i <- 1
    for(i in it) {
      ifelse(Data[i,2] == "", Data[i,2] <- Data[i-1,2], i+1)
    }
    i <- 1
    for(i in it) {
      ifelse(Data[i,3] == "", Data[i,3] <- Data[i-1,3], i+1)
    }
    iter <- 1:count
    q <- data.frame(Data[iter,1:3])
    w <- data.frame(cbind(q, Data[iter,4]))
    e <- data.frame(cbind(q, Data[iter,5]))
    r <- rbind(w,e)
    dataout <- cbind(r[!(r[,4] ==""),])
    output$downloadData <- downloadHandler(filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    content = function(con) {
      write.csv(dataout, con)
    })
  })
}
