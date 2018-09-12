# UI
ui <- fluidPage(
  titlePanel("Simple KML to CSV Converter"),
  sidebarLayout(
    mainPanel(
      fileInput("file", "Choose Your KML File"),
      width = 12
    ),
      sidebarPanel(
        actionButton("go", "Click to Run..."),
        downloadButton("downloadCSV", "Click to download your converted KML as a CSV file"),
        width = 6
      )
  )
)

