ui <- fluidPage(
  # Application title
  titlePanel("Clean Point Count Data!"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "choose a file with the following layout: Point|Date|Time|<50m|>50m")
    ),
    sidebarPanel(
      actionButton("go", "Click to Run..."),
      print("   Please allow 10-30 seconds for processing!   "),
      downloadButton("downloadData", ".. Then to Download")
    )
  )
)
