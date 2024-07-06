library(shiny)
library(dplyr); library(ggplot2); library(lubridate); library(stringr); library(scales)
library(RMySQL)

shinyApp(
  ui = fluidPage(
    titlePanel("Statystyki"),
    tabsetPanel(
      tabPanel(
        "Przepływy",
        fluid = TRUE,
        sidebarLayout(
          sidebarPanel(
            dateRangeInput(
              "datesRange", "Okres:",
              floor_date(Sys.Date() - years(1), "month"),
              separator = "do"
            )
          ),
          mainPanel(
            plotOutput("breakdown"),
            plotOutput("balance")
          )
        )
      )
    )
  ),
  server = function(input, output) {
    # database connection
    con <- dbConnect(MySQL(),
      host = Sys.getenv("DB_HOST"),
      port = as.numeric(Sys.getenv("DB_PORT")),
      dbname = Sys.getenv("DB_DATABASE"),
      user = Sys.getenv("DB_USERNAME"),
      password = Sys.getenv("DB_PASSWORD")
    )

    # validate(need(
    #   input$datesRange[2] >= input$datesRange[1],
    #   "Data końcowa musi być większa niż początkowa"
    # ))

    theme_set(theme_minimal())

    transactions_summary <- reactive({
      dbGetQuery(con, "
        SELECT date, amount
        FROM transactions
      ") %>%
      mutate(
        date = as_date(date),
        month = paste(
          str_pad(year(date), 4, "left", 0),
          str_pad(month(date), 2, "left", 0),
          sep = "-"
        ),
        is_income = as.factor(if_else(amount > 0, "Przychody", "Wydatki"))
      ) %>%
      filter(date %within% interval(
        as_date(as.POSIXct(input$datesRange[1])),
        as_date(as.POSIXct(input$datesRange[2]))
      )) %>%
      arrange(month, is_income)
    })

    output$breakdown <- renderPlot(
      transactions_summary() %>%
        mutate(amount = abs(amount)) %>%
        group_by(month, is_income) %>%
        summarise(amount = sum(amount)) %>%
        ggplot(aes(x = month, y = amount, fill = is_income)) +
          geom_col(position = "dodge") +
          theme(legend.position = "top") +
          scale_y_continuous(labels = label_number()) +
          scale_fill_manual(
            name = "Typ",
            labels = c("Przychody", "Wydatki"),
            values = c("chartreuse3", "brown2")
          ) +
          labs(
            title = "Przychody vs wydatki",
            x = "Miesiąc",
            y = "Kwota [zł]"
          )
    )
    output$balance <- renderPlot(
      transactions_summary() %>%
        group_by(month) %>%
        summarise(amount = sum(amount)) %>%
        ggplot(aes(x = month, y = amount)) +
          geom_col() +
          scale_y_continuous(labels = label_number()) +
          labs(
            title = "Bilans",
            x = "Miesiąc",
            y = "Kwota [zł]"
          )
    )
  },
  options = list(
    host = "0.0.0.0",
    port = 8001
  )
)