#' Fetch average annual temparature data
#'
#' The `fetch_noaa_avg_temp` function retrieves the life expectancy by US county
#'
#' @details
#' Average annual temperature was downloaded from \href{https://www.ncdc.noaa.gov/cag/county/mapping}{NOAA National Center for Environmental Information}.
#'
#' @importFrom dplyr filter rename select left_join mutate
#' @importFrom tidyr pivot_longer pivot_wider separate unite replace_na
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom readr cols
#' @importFrom tidyselect all_of
fetch_noaa_avg_temp <- function() {
      file.path <- system.file(
            "extdata",
            "110-tavg-202107-1.csv",
            package = "retirementLoc"
      )
      # read in data
      df <- readr::read_csv(
            file = file.path,
            skip = 3,
            show_col_types = FALSE
      )
      # clean
      avg_temp <-
            df %>%
            janitor::clean_names() %>%
            separate(.data$location_id, into = c("state", "county"), sep = "-") %>%
            select(.data$state, .data$county, .data$value)
      avg_temp <- dplyr::left_join(avg_temp,
            fetch_state_fips_codes(),
            by = "state"
      )
      avg_temp <-
            avg_temp %>%
            unite("fips", c(.data$fips, .data$county), sep = "") %>%
            rename(avg_annual_temp = .data$value) %>%
            select(.data$fips, .data$avg_annual_temp)
      avg_temp
}
