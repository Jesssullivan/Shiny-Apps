ui <- fluidPage(
  titlePanel("KML to SHP Converter"),
  sidebarLayout(
    mainPanel(
      fileInput("file", "Choose Your Input KML File", multiple = TRUE),
      width = 12
    ),
    sidebarPanel(
      actionButton("go", "Click to Run..."),
      downloadButton("downloadcent", "Click to Download a .zip of the resulting SHP files.
                     If not all are converted, please verify your KML layers!"),
      width = 12)
  )
)
