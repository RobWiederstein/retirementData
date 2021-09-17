#' Download dataset to external data directory
#'
#' The `download_dataset` function downloads a data set to the `inst/extdata`
#' directory and names it using the `basename` function.
#' @param url a character string (or longer vector e.g., for the "libcurl"
#' method) naming the URL of a resource to be downloaded.
#'
#' @importFrom utils download.file read.csv
#'
download_dataset <- function(url) {
      destfile <- paste0("./inst/extdata/", basename(url))
      if (!(file.exists(destfile))) {
            download.file(url = url, destfile = destfile)
      } else {
            print("file is already downloaded")
      }
}

#' Fetch state fips codes
#'
#' The `fetch_state_fips_codes` function retrieves FIPS codes for all 50 US states.
#'
#' @importFrom dplyr filter rename select left_join mutate
#' @importFrom tidyr pivot_longer pivot_wider separate unite replace_na
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom readr cols
#' @importFrom tidyselect all_of
fetch_state_fips_codes <- function() {
      file.path <- system.file(
            "extdata",
            "state_fips_master.csv",
            package = "retirementLoc"
      )
      df <- readr::read_csv(
            file = file.path,
            skip = 0,
            col_select = c(.data$state_abbr, .data$fips),
            show_col_types = FALSE
      )
      #
      df <- janitor::clean_names(df)

      state_fips_codes <-
            df %>%
            rename(state = .data$state_abbr) %>%
            mutate(fips = stringr::str_pad(.data$fips, 2, side = "left", pad = 0))
      state_fips_codes
}
#' Fetch county fips codes
#'
#' The `fetch_county_fips_codes` function retrieves FIPS codes for 3142 US counties.
#'
#' @importFrom dplyr filter rename select left_join mutate
#' @importFrom tidyr pivot_longer pivot_wider separate unite replace_na
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom readr cols
#' @importFrom tidyselect all_of
fetch_county_fips_codes <- function() {
      file.path <- system.file(
            "extdata",
            "county_fips_master.csv",
            package = "retirementLoc"
      )
      df <- readr::read_csv(
            file = file.path,
            skip = 0,
            show_col_types = FALSE
      )
      county_fips <-
            df %>%
            mutate(fips = stringr::str_pad(.data$fips,
                  width = 5,
                  side = "left", pad = "0"
            )) %>%
            mutate(county_name = gsub(" County", "", .data$county_name)) %>%
            select(.data$fips, .data$state_abbr, .data$county_name) %>%
            rename(state = .data$state_abbr, county = .data$county_name)
      county_fips
}
#' Fetch county centroids weighted by population
#'
#' The `fetch_county_coords` function retrieves population weighted centers for
#'  3142 US counties.
#'  @details
#'  The latitude and longitude, or county centroids, were downloaded from the
#'  \href{https://github.com/btskinner/spatial}{btskinner/spatial}
#'  repo maintained by Professor Benjamin Skinner. Centroids are population weighted.
#'
#' @importFrom dplyr filter rename select left_join mutate
#' @importFrom tidyr pivot_longer pivot_wider separate unite replace_na
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom readr cols
#' @importFrom tidyselect all_of
fetch_county_coords <- function() {
      file <- system.file(
            "extdata",
            "county_centers.csv",
            package = "retirementLoc"
      )
      # read in data
      df <- readr::read_csv(
            file = file,
            skip = 0,
            show_col_types = FALSE
      )
      # clean
      county_lat_lon <-
            df %>%
            janitor::clean_names() %>%
            select(.data$fips, .data$pclon10, .data$pclat10) %>%
            rename(lat = .data$pclat10, lon = .data$pclon10)
      # export
      county_lat_lon
}
