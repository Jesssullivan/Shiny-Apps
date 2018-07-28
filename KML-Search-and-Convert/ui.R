# UI
ui <- fluidPage(
  titlePanel("KML Search And Convert"),
  sidebarLayout(
    mainPanel(
      fileInput("file", "Choose Your KML File"),
    #  textOutput("WaitTime1"), 
    #  htmlOutput("WaitTime2"),
    #  textOutput("WaitTime3"),
      textInput("param_1", "Enter keyword 1 to search for in your KML file"),
      textInput("param_2", "Ente keyword 2 to search for in your KML file"),
      width = 12
    ),
      sidebarPanel(
        actionButton("go", "Click to Run..."),
        downloadButton("downloadCSV", "Click to download your converted KML as a CSV file"),
        print("
If you would like to seach within your KML file, enter your search terms below. 
            You may download the search results as an additional CSV below."),
        downloadButton("downloadSearch", "Click to download your search results as a CSV file"),
        width = 12)
      )
)

