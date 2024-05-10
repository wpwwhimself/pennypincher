#### libraries ####
library(readxl)
library(tidyverse)
library(purrr)

#### import data ####
years_of_life <- 20:27
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

# 2017-01-01 - 2017-12-31: 1
# 2018-01-01 - 2018-08-31: 2
# 2018-09-01 - 2021-08-31: 3
# 2021-09-01 - present: 4
c_categories <- function(date) {
  if (date %within% interval(ymd("2017-01-01"), ymd("2017-12-31")))
    return(c(
      "1" = "0",
      "5" = "1",
      "14" = "2",
      "13" = "3",
      "11" = "4",
      "21" = "5",
      "29" = "6",
      "30" = "7"
    ))
  if (date %within% interval(ymd("2018-01-01"), ymd("2018-08-31")))
   return(c(
      "1" = "0",
      "5" = "1",
      "14" = "2",
      "13" = "3",
      "11" = "4",
      "21" = "5",
      "29" = "6",
      "27" = "-1",
      "14" = "7",
      "10" = "8"
    ))
  if (date %within% interval(ymd("2018-09-01"), ymd("2021-08-31")))
    return(c(
      "1" = "0",
      "5" = "1",
      "14" = "2",
      "13" = "3",
      "11" = "4",
      "21" = "5",
      "29" = "6",
      "27" = "-1",
      "10" = "7",
      "17" = "8",
      "31" = "9"
    ))
  return(c(
    "1" = "0",
    "5" = "1",
    "6" = "1.1",
    "7" = "1.2",
    "8" = "1.3",
    "9" = "1.4",
    "10" = "1.5",
    "10" = "8",
    "11" = "2",
    "12" = "2.1",
    "13" = "3",
    "14" = "3.1",
    "15" = "3.2",
    "16" = "3.3",
    "17" = "4",
    "18" = "4.1",
    "19" = "4.2",
    "20" = "4.3",
    "21" = "5",
    "22" = "5.1",
    "23" = "5.2",
    "24" = "5.3",
    "25" = "5.4",
    "26" = "5.5",
    "27" = "5.6",
    "28" = "5.7",
    "29" = "6",
    "30" = "7",
    "31" = "7.1",
    "32" = "-1",
    "33" = "-1.1",
    "34" = "-1.2"
  ))
}

#### custom functions ####
c_day_to_date <- function(day, current_year, current_month) {
  ymd(paste(current_year, current_month, day, sep = "-"))
}
c_file_path <- function(year_of_life) {
  paste(
    "_old_rs_files/Rok życia nr ",
    year_of_life, ".xlsx",
    sep = ""
  )
}

#### let's roll ####
data <-
  map(years_of_life, .progress = TRUE, function(year_of_life) {
    map(months, .progress = TRUE, function(month) {
      current_month <- which(months == month)
      current_year <- 1997 + year_of_life - (current_month >= 9)
      start_date <- ymd(paste(current_year, current_month, 1, sep = "-"))

      if (!start_date %within% interval(ymd("2017-01-01"), ymd("2024-04-01")))
        return()

      #### load transactions ####
      data_main <-
        read_xlsx(
          c_file_path(year_of_life),
          month,
          if_else(
            year_of_life == 25,
            "A10:E9999",
            if_else(
              start_date <= ymd("2018-02-28"),
              "A3:E9999",
              "A2:E9999"
            )
          ),
          col_names = c("date", "category_id", "description", "account_id", "amount"),
          col_types = c("numeric", "numeric", "text", "numeric", "numeric")
        ) %>%
        filter(!is.na(date)) %>%
        mutate(
          date = c_day_to_date(date, current_year, current_month),
          amount = coalesce(amount, 0),
          account_id = case_match(account_id,
            0 ~ "1",
            1 ~ "2",
            2 ~ "3"
          ),
          category_id = category_id %>%
            as_factor() %>%
            fct_recode(!!!c_categories(start_date))
          
        ) %>%
        mutate( # transfer categories handling
          category_id = if_else(
            category_id == "1",
            as_factor(case_match(account_id,
              "1" ~ 2,
              "2" ~ 3,
              "3" ~ 2
            )),
            category_id
          ),
          account_id = if_else(
            category_id %in% c(2, 3, 4),
            as_factor(case_match(account_id,
              "1" ~ 2,
              "2" ~ 3,
              "3" ~ 3
            )),
            account_id
          )
        )

      data_crypto <-
        # 2021-03-01 - 2021-08-31: H3:I33
        # 2021-09-01 - 2022-08-31: H10:I40
        # 2022-09-01 - 2023-08-31: H2:I32
        if (start_date %within% interval(ymd("2021-03-01"), ymd("2023-08-31"))) {
          read_xlsx(
            c_file_path(year_of_life),
            month,
            if_else(
              start_date %within% interval(ymd("2021-03-01"), ymd("2021-08-31")),
              "H3:I33",
              if_else(
                start_date %within% interval(ymd("2021-09-01"), ymd("2022-08-31")),
                "H10:I40",
                "H2:I32"
              )
            ),
            col_names = c("balance", "amount"),
            col_types = c("numeric", "numeric")
          ) %>%
            rowid_to_column("date") %>%
            mutate(
              date = c_day_to_date(date, current_year, current_month),
              category_id = as_factor(31),
              account_id = as_factor(3),
              description = as.character(NA)
            ) %>%
            select(-balance) %>%
            filter(
              !is.na(date),
              amount != 0
            )
        } else {
          tibble()
        }

      data_savings <-
        # 2022-12-01 - 2023-08-31: J:L
        # 2023-09-01 - 2023-12-31: H:J
        if (start_date %within% interval(ymd("2022-12-01"), ymd("2023-12-31"))) {
          read_xlsx(
            c_file_path(year_of_life),
            month,
            if_else(
              start_date %within% interval(ymd("2022-12-01"), ymd("2023-08-31")),
              "J2:L32",
              "H2:J32"
            ),
            col_names = c("amount", "balance", "payout"),
            col_types = c("numeric", "numeric", "numeric")
          ) %>%
            rowid_to_column("date") %>%
            mutate(
              date = c_day_to_date(date, current_year, current_month),
              category_id = as_factor(3),
              account_id = as_factor(3),
              description = "auto-oszczędzanie",
              amount = coalesce(amount, 0) - coalesce(payout, 0)
            ) %>%
            select(-payout, -balance) %>%
            filter(
              !is.na(date),
              amount != 0
            )
        } else {
          tibble()
        }

      #### merge ####
      data <- bind_rows(
        data_main,
        data_crypto,
        data_savings
      )
    }) %>%
      bind_rows()
  }) %>%
    bind_rows() %>%
    mutate(
      account_id = as_factor(account_id)
    )

data %>%
  write_csv("_old_rs_files/data.csv")

# source("excel_to_csv.r")
