#' Fetch US life expectancy by county
#' The `fetch_ihme_life_expectancy` function retrieves the life expectancy by US county
#'
#' @details
#' The life expectancy data was downloaded from The Institute for Health Metrics
#' and Evaluation (IHME). The webpage was entitled, "\href{http://ghdx.healthdata.org/record/ihme-data/united-states-life-expectancy-and-age-specific-mortality-risk-county-1980-2014}{United States Life Expectancy and Age-specific Mortality Risk by County 1980-2014}
#'
#' @importFrom dplyr filter rename select left_join mutate
#' @importFrom tidyr pivot_longer pivot_wider separate unite replace_na drop_na
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom readr cols
#' @importFrom tidyselect all_of
fetch_ihme_life_expectancy <- function() {
      file.path <- system.file(
            "extdata",
            "IHME_USA_COUNTY_LE_MORTALITY_RISK_1980_2014_NATIONAL_Y2017M05D08.XLSX",
            package = "retirementLoc"
      )
      # read in data
      df <- readxl::read_xlsx(
            path = file.path,
            skip = 1,
            col_types = "text",
            n_max = 3196
      )
      # clean
      df <- janitor::clean_names(df)
      life_exp <-
            df %>%
            select(.data$fips, .data$life_expectancy_2014) %>%
            separate(.data$life_expectancy_2014,
                  sep = " ",
                  into = c("life_exp", NA), extra = "drop"
            ) %>%
            drop_na() %>%
            mutate(fips = stringr::str_trim(.data$fips, side = "both")) %>%
            dplyr::filter(nchar(.data$fips) %in% c(4, 5)) %>%
            mutate(life_exp = life_exp %>% as.numeric()) %>%
            mutate(fips = stringr::str_pad(.data$fips, width = 5, side = "left", pad = "0"))
      life_exp
}

#' Fetch violent crime rate by county
#' The `fetch_chr_violent_crime_rate` function retrieves violent crime rate from county
#' health rankings
#'
#' @details
#' The violent crime rate was downloaded from \href{https://www.countyhealthrankings.org}{County Health Rankings}.
#' The data is derived from The Uniform Crime Reporting (UCR) Program. 17,000 law enforcement
#' agencies across the United States submit the data to the FBI which is charged with collecting and
#' publishing it.
fetch_chr_violent_crime_rate <- function() {
      # import
      file <- system.file(
            "extdata",
            "2020 County Health Rankings Data - v2.xlsx",
            package = "retirementLoc"
      )
      df <- readxl::read_xlsx(
            path = file,
            sheet = 4,
            skip = 1,
            n_max = 3195
      )
      # clean
      keep.cols <- c("FIPS", "Violent Crime Rate")
      violent_crime_rate <-
            df %>%
            select(all_of(keep.cols)) %>%
            janitor::clean_names()
      # export
      violent_crime_rate
}
#' Fetch average daily particulate matter 2.5
#' The `fetch_chr_avg_daily_pm_2_5` function retrieves violent crime rate from county
#' health rankings
#'
#' @details
#' The average daily particulate matter 2.5 microns was downloaded from \href{https://www.countyhealthrankings.org}{County Health Rankings},
#' although it is available from the Environmental Protection Agency as well. PM2.5 describes fine inhalable
#' particles, with diameters that are generally 2.5 micrometers and smaller. While the levels have been
#' decreasing over time, high concentrations of particulate matter are associated
#' with serious health problems.
#'
#' @importFrom dplyr filter rename select left_join mutate
#' @importFrom tidyr pivot_longer pivot_wider separate unite replace_na
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom readr cols
#' @importFrom tidyselect all_of
fetch_chr_avg_daily_pm_2_5 <- function(){
        # import
        file <- system.file(
                "extdata",
                "2020 County Health Rankings Data - v2.xlsx",
                package = "retirementLoc"
        )
        df <- readxl::read_xlsx(
                path = file,
                sheet = 4,
                skip = 1,
                n_max = 3195
        )
        # clean
        keep.cols <- c("FIPS", "Average Daily PM2.5")
        avg_daily_pm_2_5 <-
                df %>%
                select(all_of(keep.cols)) %>%
                janitor::clean_names()
        # export
        avg_daily_pm_2_5

}

#' Fetch primary care physicians per 100,000
#' The `fetch_chr_primary_care_doctors` function retrieves the number of primary care
#' physicians per 100,000 residents
#' @details
#' #' The primary care physician rate is important to insure that the public can access
#' preventive and primary care. The information is collected by
#' \href{https://www.countyhealthrankings.org}{County Health Rankings} from over 50 sources.
#'
#' @importFrom dplyr filter rename select left_join mutate
#' @importFrom tidyr pivot_longer pivot_wider separate unite replace_na
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom readr cols
#' @importFrom tidyselect all_of
fetch_chr_primary_care_doctors <- function(){
        # import
        file <- system.file(
                "extdata",
                "2020 County Health Rankings Data - v2.xlsx",
                package = "retirementLoc"
        )
        df <- readxl::read_xlsx(
                path = file,
                sheet = 4,
                skip = 1,
                n_max = 3195
        )
        # clean
        keep.cols <- c("FIPS", "Primary Care Physicians Rate")
        primary_care_doctors <-
                df %>%
                select(all_of(keep.cols)) %>%
                janitor::clean_names() %>%
                rename(prim_care_dr_rate = .data$primary_care_physicians_rate)
        # export
        primary_care_doctors
}
