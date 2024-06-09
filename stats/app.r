library(shiny)
library(tidyverse)
library(RMySQL)

# database connection
# con <- dbConnect(MySQL(),
#   host = Sys.getenv("DB_HOST"),
#   port = as.numeric(Sys.getenv("DB_PORT")),
#   dbname = Sys.getenv("DB_DATABASE"),
#   user = Sys.getenv("DB_USERNAME"),
#   password = Sys.getenv("DB_PASSWORD")
# )

ui <- fluidPage(
  titlePanel("Rachunek sumienia"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins", "Number of bins:", 1, 50, 30)
    ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

server <- function(input, output) {
  output$distPlot <- renderPlot({
    x <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(
      x,
      breaks = bins,
      col = "red",
      border = "white",
      xlab = "Waiting",
      main = "bleble"
    )
  })
}

shinyApp(
  ui,
  server,
  options = list(
    host = "0.0.0.0",
    port = 8001
  )
)