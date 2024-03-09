library(shiny)
library(tidyverse)
library(RMySQL)

# database connection
source("cred.r")
con <- dbConnect(MySQL(),
  host = db_cred$host, port = db_cred$port,
  dbname = db_cred$name, user = db_cred$user, password = db_cred$password
)

dbSendQuery(con, "select * from transactions;") %>%
  fetch() %>%
  as_tibble()

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

shinyApp(ui, server)