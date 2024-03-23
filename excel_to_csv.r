import_data <- function(spreadsheet, year_of_life) {
  #### libraries ####
  library(googlesheets4)
  library(tidyverse)
  library(purrr)

  #### dictionaries ####
  months <- c(
    "styczeń",
    "luty",
    "marzec",
    "kwiecień",
    "maj",
    "czerwiec",
    "lipiec",
    "sierpień",
    "wrzesień",
    "piździernik",
    "liściopad",
    "grudzień"
  )

  data <- months %>%
    map(function(month) {
      current_month <- which(months == month)
      current_year <- 1997 + year_of_life - (current_month < 9)

      read_sheet(
        spreadsheet,
        month,
        "A:E"
      ) %>%
        mutate(
          date = ymd(paste(current_year, current_month, dzień, sep = "-")),
          category = case_match(
            kategoria,
            `1` = 2,
            `1.1` = 3,
            `1.2` = 4,
            `1.3` = 5,
            `1.4` = 6,
            `1.5` = 7,
            `2` = 8,
            `2.1` = 9,
            `3` = 10,
            `3.1` = 11,
            `3.2` = 12,
            `3.3` = 13,
            `4` = 14,
            `4.1` = 15,
            `4.2` = 16,
            `4.3` = 17,
            `5` = 18,
            `5.1` = 19,
            `5.2` = 20,
            `5.3` = 21,
            `5.4` = 22,
            `5.5` = 23,
            `5.6` = 24,
            `5.7` = 25,
            `6` = 26,
            `7` = 27,
            `7.1` = 28,
            `0` = 1,
            `-1` = 29,
            `-1.1` = 30,
            `-1.2` = 31
          )
        )
    }) # %>%
    # bind_rows()

  return(data)
}

