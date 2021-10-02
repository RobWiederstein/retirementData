#' Fetch USCB population data
#'
#' The `fetch_uscb_population` function retrieves the total population by county
#' in the United States for 2020 as tablulated by the United States Census Bureau.
#'
#' @details
#' The population data is from the
#' \href{https://www2.census.gov/programs-surveys/popest/datasets/2010-2020/counties/totals/co-est2020.csv}{U.S. Census Bureau}.
#'
#' @importFrom dplyr filter rename select left_join mutate group_by ungroup across summarize
#' @importFrom tidyr pivot_longer pivot_wider separate unite
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom Rdpack reprompt
#'
#' @references
#' \insertRef{USCB2021}{retirementData}
fetch_uscb_population <- function() {
  # read in data
  file.path <- system.file(
    "extdata",
    "co-est2020.csv",
    package = "retirementData"
  )

  df <- readr::read_csv(
    file.path,
    show_col_types = FALSE
  )
  # rename variables
  df <- janitor::clean_names(df)

  # clean
  uscb_county_pop <-
    df %>%
    dplyr::filter(.data$county != "000") %>%
    unite("fips", .data$state:.data$county, sep = "") %>%
    mutate(ctyname = gsub(" County", "", .data$ctyname)) %>%
    select(.data$fips, .data$stname, .data$ctyname, .data$census2010pop, .data$popestimate2020) %>%
    mutate(census2010pop = .data$census2010pop %>% as.integer()) %>%
    mutate(pct_change = (.data$popestimate2020 - .data$census2010pop) / .data$census2010pop) %>%
    mutate(pct_change = round(.data$pct_change * 100, 1)) %>%
    select(-.data$census2010pop) %>%
    rename(
      pop_2020 = .data$popestimate2020,
      pct_pop_change = .data$pct_change
    ) %>%
    select(.data$fips, .data$pop_2020, .data$pct_pop_change)
  # export
  uscb_county_pop
}

#' Fetch Partisan Lean
#'
#' The `fetch_partisan_lean` function retrieves the percentage of votes by county
#' cast in favor of the Democratic candidate for president in 2020.
#'
#' @details
#' The partisan lean was computed from the 2020 US presidential election results
#' furnished by the \href{https://electionlab.mit.edu/data}{Election Lab at MIT}.
#'
#' @importFrom dplyr filter rename select left_join mutate group_by ungroup across summarize
#' @importFrom tidyr pivot_longer pivot_wider separate unite
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom Rdpack reprompt
#'
#' @references
#' \insertRef{MIT2017}{retirementData}
fetch_partisan_lean <- function() {
  file.path <- system.file(
    "extdata",
    "countypres_2000-2020.csv",
    package = "retirementData"
  )
  # read in data
  df <- read.csv(
    file = file.path,
    colClasses = "character"
  )
  # rename variables
  df <- janitor::clean_names(df)
  # clean
  us_part_lean <-
    df %>%
    dplyr::filter(.data$year == "2020") %>%
    dplyr::filter(.data$party == "DEMOCRAT") %>%
    mutate(across(.data$candidatevotes:.data$totalvotes, as.integer)) %>%
    group_by(.data$county_fips, .data$totalvotes) %>%
    summarize(cast = sum(.data$candidatevotes)) %>%
    mutate(
      partisan_lean = .data$cast / .data$totalvotes,
      partisan_lean = (.data$partisan_lean * 100) %>% round(1)
    ) %>%
    select(.data$county_fips, .data$partisan_lean) %>%
    rename(fips = .data$county_fips) %>%
    drop_na() %>%
    ungroup()
  # export
  us_part_lean
}

#' Fetch CBSA county classifications
#'
#' The `fetch_cbsa_metro_label` function retrieves OMB classifications of US
#' counties.
#'
#' @details
#' The Office of Management and Budget ("OMB") assigns some counties to metropolitan
#' or micropolitan areas.  The two classifications are further subdivided into central
#' and outlying areas.
#'
#' The US Census Bureau provides "dilineation" files listing core
#' based statistic areas (CBSA), combined statistical areas (CSA), and their component areas.
#' The value "rural-faraway" is a construct and was used to replace
#' "NA" values. For more information, see the US Census Bureau
#' \href{#https://www.census.gov/programs-surveys/metro-micro.html}{website}.
#'
#' @importFrom dplyr filter rename select left_join mutate
#' @importFrom tidyr pivot_longer pivot_wider separate unite replace_na
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom readr cols
#' @importFrom Rdpack reprompt
#'
#' @references
#' \insertRef{NBER2021}{retirementData}
fetch_cbsa_metro_label <- function() {
  # load
  file <- system.file("extdata", "cbsa2fipsxw.csv", package = "retirementData")
  df <- readr::read_csv(file = file, col_types = cols(.default = "c"))
  # clean
  cbsa_codes <-
    df %>%
    janitor::remove_empty() %>%
    select(
      .data$fipsstatecode, .data$fipscountycode,
      .data$centraloutlyingcounty, .data$metropolitanmicropolitanstatis
    ) %>%
    rename(
      state = .data$fipsstatecode,
      county = .data$fipscountycode,
      class = .data$centraloutlyingcounty,
      status = .data$metropolitanmicropolitanstatis
    ) %>%
    tidyr::unite("fips", .data$state:.data$county, sep = "") %>%
    tidyr::unite("cbsa_desig", c(.data$status, .data$class), sep = "-") %>%
    dplyr::mutate(cbsa_desig = .data$cbsa_desig %>% tolower()) %>%
    dplyr::mutate(cbsa_desig = gsub("politan statistical area", "", .data$cbsa_desig))
  # merge
  df <-
    left_join(fetch_county_fips_codes(),
      cbsa_codes,
      by = "fips"
    ) %>%
    replace_na(list(cbsa_desig = "rural-faraway")) %>%
    select(.data$fips, .data$cbsa_desig)
  # export
  df
}
#' Fetch rural-urban county continuum county classifications
#'
#' The `fetch_rural_urban_continuum` function classifies counties from 1 -- urban to
#' 9 rural.
#'
#' @details
#'
#' The OMB also assigns counties to a rural-urban continuum.  The values are
#' 1 through 9 and is based on population and adjacency to an urban area. It is also known as
#' the "Beale code" originally developed by David L. Brown and later popularized by Calvin
#' Beale at the United States Department of Agriculture in 1975. See
#' \href{https://bit.ly/3Aa2KAW}{USDA Rural-Urban Continuum Codes}.
#'
#' @importFrom dplyr filter rename select left_join mutate group_by ungroup across summarize
#' @importFrom tidyr pivot_longer pivot_wider separate unite
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom Rdpack reprompt
#'
#' @references
#' \insertRef{USDAcodes2021}{retirementData}
fetch_rural_urban_continuum <- function() {
  # import
  path <- system.file("extdata", "ruralurbancodes2013.xls", package = "retirementData")
  df <- readxl::read_xls(path = path)
  # clean
  rural_urban_codes <-
    df %>%
    janitor::clean_names() %>%
    select(.data$fips, .data$rucc_2013) %>%
    mutate(rucc_2013 = .data$rucc_2013 %>% as.character())
  # export
  rural_urban_codes
}
#' Fetch percent residents having broadband access
#'
#' The `fetch_broadband_access` function retrieves the percentage of residents
#' having access to broadband cable.
#'
#' @details
#'  Broadband coverage is from the US Census Bureau and represents the percentage
#'  of households having access to broadband in 2017. The USCB found that "nationally,
#'  78 percent of households subscribe to the internet, but households in both rural
#'  and lower-income counties trail the national average by 13 points."
#'   \insertCite{USCBbroadband2021}{retirementData} Counties with high broadband
#'   subscription rates are concentrated around urban areas and along both coasts.
#'   \insertCite{USCBbroadband2021}{retirementData} Whereas counties with lower subscription
#'   rates are more prominent in the South and the Mississippi River basin.
#'   \insertNoCite{USCBacs2018}{retirementData}
#'
#'
#' @importFrom dplyr filter rename select left_join mutate
#' @importFrom tidyr pivot_longer pivot_wider separate unite
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom Rdpack reprompt
#'
#' @references
#'     \insertAllCited{}
fetch_broadband_access <- function() {
  file <- system.file(
    "extdata",
    "2021-08-28_uscb_housing.csv",
    package = "retirementData"
  )
  # read in data
  df <- readr::read_csv(
    file = file,
    skip = 0
  )
  # clean
  broadband <-
    df %>%
    janitor::clean_names() %>%
    select(.data$fips, .data$broadband_2017) %>%
    mutate(fips = stringr::str_pad(.data$fips, width = 5, side = "left", pad = "0"))
  # export
  broadband
}
#' Fetch percent of population having a bacherlor's degree or higher
#'
#' The `fetch_bachelor_degrees` function retrieves the percentage of the population
#' having four or more years of college.
#'
#' @importFrom dplyr filter rename select left_join mutate
#' @importFrom tidyr pivot_longer pivot_wider separate unite
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom Rdpack reprompt
#'
#' @references
#' \insertRef{USDAeduc2021}{retirementData}
fetch_bachelor_degrees <- function() {
  # import
  path <- system.file("extdata", "usda_education_level_by_county.xls", package = "retirementData")
  education_level <- readxl::read_xls(
    path = path,
    range = "A5:AU3288",
    sheet = 1
  )
  # clean
  education_level <-
    education_level %>%
    janitor::clean_names() %>%
    select(.data$fips_code, .data$percent_of_adults_with_a_bachelors_degree_or_higher_2015_19) %>%
    rename(
      fips = .data$fips_code,
      pct_bachelor = .data$percent_of_adults_with_a_bachelors_degree_or_higher_2015_19
    ) %>%
    separate(.data$fips, into = c("state", "county"), sep = 2) %>%
    dplyr::filter(.data$county != "000") %>%
    unite("fips", .data$state:.data$county, sep = "") %>%
    mutate(pct_bachelor = .data$pct_bachelor %>% round(1))
  # export
  education_level
}
