#Global packages for STL Converter (raster2stl)
library(r2stl)
library(png)
library(imager)
library(magick)
library(shinycssloaders)
library(rgl)

args <- commandArgs(trailingOnly = TRUE)

ui <- fluidPage(
  titlePanel("Raster to STL converter"),
  sidebarLayout(
    mainPanel(
      fileInput("file", "Choose Your image File"),
      width = 12
    ),
    sidebarPanel(
      titlePanel("please wait to download
                 until your input raster image 
                 is displayed below!  This is can take a while..."),
      actionButton("go", "Click to Run..."),
      plotOutput("Test") %>% withSpinner(color="#0dc5c1"),
      downloadButton("downloadSTL", "Click to download your STL file"),
      width = 6
    )
  )
)
server <- function(input, output) {
  observeEvent(input$go, {
    validate(
      need(input$file != "", "Please jpeg")
    )
    ##  extra tmp read write ###
    image = image_read(input$file$datapath)
    imag <- image_convert(image, format = "png", colorspace = "gray")
    ima <- image_write(imag, "tmp.png")
    im <- load.image("tmp.png")
    z <- im[, , 1, 1]
    x <- 1:length(im[, 1, 1, 1])
    y <- 1:length(im[1, , , 1])
    r2stl(x, y, z, filename = "tmp.stl", object.name = "raster2stl")
    output$Test <- renderPlot({
      plot(im)
    })
    output$downloadSTL <- downloadHandler(
      filename = function() {
        paste("raster2stl_", Sys.Date(), ".stl", sep = "")
      },
      content = function(con) {
        file.copy("tmp.stl", con)
      }
    )
  })
}

runApp(shinyApp(ui, server), port = as.numeric(args[1]))
