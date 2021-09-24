#' Fetch Zillow Median Housing Price
#'
#' The `fetch_zillow_median_price` function retrieves the typical value for homes
#' in dollars by county.
#'
#' @details
#' Background can be found on Zillow's data \href{https://www.zillow.com/research/data/}{tab}.
#' According to the Zillow website, it is "a smoothed, seasonally adjusted measure of the typical
#' home value and market changes across a given region and housing type. It reflects the
#' typical value for homes in the 35th to 65th percentile range. \insertCite{Zillow2021}{retirementLoc}
#'
#' @importFrom dplyr  filter rename select
#' @importFrom tidyr pivot_longer pivot_wider separate unite
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom Rdpack reprompt
#'
#' @references
#' \insertAllCited{}


fetch_zillow_median_price <- function() {
      # load
      file <- system.file("extdata", "zillow_hpi.csv", package = "retirementLoc")
      df <- readr::read_csv(
            file = file,
            show_col_types = FALSE
      )
      # clean
      z_median_price <-
            df %>%
            pivot_longer(cols = .data$`1996-01-31`:.data$`2021-07-31`, names_to = "date", values_to = "value") %>%
            janitor::clean_names() %>%
            unite("fips", .data$state_code_fips:.data$municipal_code_fips, sep = "") %>%
            mutate(date = as.Date(.data$date, format = "%Y-%m-%d")) %>%
            dplyr::filter(.data$date == max(.data$date)) %>%
            rename(median_home_price = .data$value) %>%
            select(.data$fips, .data$median_home_price)
      # export
      z_median_price
}

#' Fetch Zillow Year-over-Year Price Change
#'
#' The `fetch_zillow_median_price` function retrieves the percentage change in median
#' housing price over one year.
#'
#' @details
#' Background can be found on Zillow's data \href{https://www.zillow.com/research/data/}{tab}.
#' According to the Zillow website, it is "a smoothed, seasonally adjusted measure of the typical
#' home value and market changes across a given region and housing type. It reflects the
#' typical value for homes in the 35th to 65th percentile range. Data set was filtered to
#' the latest period available and one year preceding it.  The percentage change was computed from
#' the most recent month and the month one year previous to the current month.
#' \insertCite{Zillow2021}{retirementLoc}
#'
#' @importFrom dplyr  filter rename select
#' @importFrom tidyr pivot_longer pivot_wider separate unite
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @references
#' \insertAllCited{}
fetch_zillow_yoy_price_chg_pct <- function() {
      # load
      file <- system.file("extdata", "zillow_hpi.csv", package = "retirementLoc")
      df <- readr::read_csv(
            file = file,
            show_col_types = F
      )
      # clean
      z_yoy_chg <-
            df %>%
            pivot_longer(cols = .data$`1996-01-31`:.data$`2021-07-31`, names_to = "date", values_to = "value") %>%
            janitor::clean_names() %>%
            unite("fips", .data$state_code_fips:.data$municipal_code_fips, sep = "") %>%
            mutate(date = as.Date(.data$date, format = "%Y-%m-%d")) %>%
            dplyr::filter(date == max(.data$date) | date == "2020-07-31") %>%
            pivot_wider(.data$region_id:.data$fips, names_from = .data$date, values_from = .data$value) %>%
            rename(
                  year_1 = .data$`2020-07-31`,
                  year_2 = .data$`2021-07-31`
            ) %>%
            mutate(yoy_price_chg_pct = (.data$year_2 - .data$year_1) / .data$year_1) %>%
            mutate(yoy_price_chg_pct = .data$yoy_price_chg_pct %>% `*`(100) %>% round(1)) %>%
            select(.data$fips, .data$yoy_price_chg_pct)
      # export
      z_yoy_chg
}

#' Fetch USDA Household Income by County
#'
#' The `fetch_usda_household_inc` function retrieves the median household income.
#'
#' @importFrom dplyr filter rename select left_join mutate
#' @importFrom tidyr pivot_longer pivot_wider separate unite
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom Rdpack reprompt
#'
#' @references
#'     \insertRef{USDAhhinc2021}{retirementLoc}
fetch_usda_household_inc <- function() {
      path <- system.file("extdata", "unemployment.xlsx", package = "retirementLoc")
      df <- readxl::read_xlsx(
            path = path,
            skip = 4
      )
      # clean
      usda_household_inc <-
            df %>%
            janitor::clean_names() %>%
            select(.data$fips_code, .data$median_household_income_2019) %>%
            rename(
                  fips = .data$fips_code,
                  med_hh_inc_2019 = .data$median_household_income_2019
            )
      # export
      usda_household_inc
}

#' Home price to income multiple
#'
#' The `create_home_price_to_income_multiple` function
#' creates a quotient representing 2019 household income divided
#' by the Zillow median home price.
#'
#' @importFrom dplyr filter rename select left_join mutate
#' @importFrom tidyr pivot_longer pivot_wider separate unite
#' @importFrom magrittr %>%
#' @importFrom rlang .data
create_home_price_to_income_multiple <- function() {
      # combine
      df <- left_join(
            fetch_zillow_median_price(),
            fetch_usda_household_inc()
      )
      # clean
      price_to_income <-
            df %>%
            mutate(years_to_payoff = (.data$median_home_price / .data$med_hh_inc_2019)) %>%
            mutate(years_to_payoff = .data$years_to_payoff %>% round(1)) %>%
            select(.data$fips, .data$years_to_payoff)
      # export
      price_to_income
}
