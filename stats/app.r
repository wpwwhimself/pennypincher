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
            "Przychody/wydatki",
            plotOutput("breakdown"),
            plotOutput("balance"),
            tableOutput("inVsOut")
          ),
          tabPanel(
            "Majątek",
            tableOutput("rollingSum")
          ),
          tabPanel(
            "Kategorie",
            uiOutput("categories")
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
      left_join(categories, by = c("category_id" = "id")) %>%
      filter(parent_id != 1) %>%
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
    categories_summary <- reactive({
      transactions %>%
      left_join(categories, by = c("category_id" = "id")) %>%
      filter(date %within% interval(
        as_date(as.POSIXct(input$datesRange[1])),
        as_date(as.POSIXct(input$datesRange[2]))
      )) %>%
      complete(
        date = seq(min(date), max(date), by = "day"),
        category_id,
        amount = 0
      ) %>%
      mutate(
        month = paste(
          str_pad(year(date), 4, "left", 0),
          str_pad(month(date), 2, "left", 0),
          sep = "-"
        )
      ) %>%
      group_by(month, category_id) %>%
      summarise(amount = sum(amount, na.rm = TRUE)) %>%
      left_join(categories, by = c("category_id" = "id")) %>%
      mutate(parent_id = coalesce(parent_id, category_id)) %>%
      arrange(month)
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
            title = "Rozbicie miesięczne",
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
    output$inVsOut <- renderTable({
      transactions_summary() %>%
        group_by(is_income) %>%
        summarise(amount = sum(amount)) %>%
        pivot_wider(names_from = is_income, values_from = amount) %>%
        mutate(Dochody = Przychody + Wydatki)
    })

    output$rollingSum <- renderTable(rolling_sum())

    output$categories <- renderUI({
      main_categories <- categories %>%
        filter(is.na(parent_id), id != 1) %>%
        pull(id)

      lapply(main_categories, function(cat_id) {
        plot_id <- paste0("plot_", cat_id)
        plotOutput(plot_id)

        output[[plot_id]] <- renderPlot({
          categories_summary() %>%
            filter(parent_id == cat_id) %>%
            ggplot(aes(x = month, y = amount, fill = name)) +
              geom_col() +
              theme(legend.position = "top") +
              scale_y_continuous(labels = label_number()) +
              scale_fill_brewer(
                name = "Kategoria",
                palette = "Pastel1"
              ) +
              labs(
                title = categories$name[cat_id],
                x = "Miesiąc",
                y = "Kwota [zł]"
              )
        })
      })
    })

    dbDisconnect(con)
  },
  options = list(
    host = "0.0.0.0",
    port = 81
  )
)