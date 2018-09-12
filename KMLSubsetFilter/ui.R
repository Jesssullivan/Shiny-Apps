# UI filter
ui <- fluidPage(
  titlePanel("KML Subset:  Filter your KML"),
  sidebarLayout(
    mainPanel(
      fileInput("file", "Choose Your KML File"),
      print("You must fill out the search fields before running!"),
      textInput("param_1", "Enter keyword 1 to search for in your KML file"),
      textInput("param_2", "Ente keyword 2 to search for in your KML file"),
      width = 12
    ),
      sidebarPanel(
        actionButton("go", "Click to Run..."),
        downloadButton("downloadKML", "Click to download your filtered KML subset file")
      )
  )
)

