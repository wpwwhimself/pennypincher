library(shiny)
library(tidyverse)
library(scales)
library(RMySQL)
library(dotenv)

shinyApp(
  ui = fluidPage(
    titlePanel("Statystyki"),
    sidebarLayout(
      sidebarPanel(
        dateRangeInput(
          "datesRange", "Okres:",
          floor_date(Sys.Date() - years(1), "month"),
          separator = "do"
        )
      ),
      mainPanel(
        tabsetPanel(
          tabPanel(
            "Miesięcznie",
            plotOutput("breakdown"),
            plotOutput("balance")
          ),
          tabPanel(
            "Majątek",
            tableOutput("rollingSum")
          ),
          tabPanel(
            "Kategorie"
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
    categories <- dbGetQuery(con, "SELECT * FROM categories")
    accounts <- dbGetQuery(con, "SELECT * FROM accounts")
    transactions <-
      dbGetQuery(con, "
        SELECT *
        FROM transactions
      ") %>%
      mutate(date = as_date(date))

    # global settings
    theme_set(theme_minimal())

    # data
    transactions_summary <- reactive({
      transactions %>%
      select(date, amount) %>%
      mutate(
        month = paste(
          str_pad(year(date), 4, "left", 0),
          str_pad(month(date), 2, "left", 0),
          sep = "-"
        ),
        is_income = factor(
          if_else(amount > 0, "Przychody", "Wydatki"),
          c("Przychody", "Wydatki")
        )
      ) %>%
      filter(date %within% interval(
        as_date(as.POSIXct(input$datesRange[1])),
        as_date(as.POSIXct(input$datesRange[2]))
      )) %>%
      arrange(month, is_income)
    })
    rolling_sum <- reactive({
      transactions %>%
      group_by(date, account_id) %>%
      summarise(amount = sum(amount, na.rm = TRUE)) %>%
      ungroup() %>%
      pivot_wider(names_from = account_id, names_prefix = "account_", values_from = amount) %>%
      mutate(across(starts_with("account"), ~ .x %>%
        replace_na(0) %>%
        cumsum()
      ))
      # todo odjąć przepływy z kategorii transferowych
    })

    # outputs
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
    output$rollingSum <- renderTable(rolling_sum())

    dbDisconnect(con)
  },
  options = list(
    host = "0.0.0.0",
    port = 81
  )
)