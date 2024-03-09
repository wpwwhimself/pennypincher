import_data <- function(spreadsheet, year_of_life) {
  #### libraries ####
  library(googlesheets4)
  library(tidyverse)
  library(purrr)

  #### dictionaries ####
  sheet_list <- c(
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

  sheet_list %>%
    map(function(sheet) {
      read_sheet(
        spreadsheet,
        sheet,
        "A:E"
      )
    }) %>%
    bind_rows()

  return(data)
}
