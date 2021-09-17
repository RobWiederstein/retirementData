#' Criteria for Retirement Location
#'
#' A dataset containing criteria for relocation in retirement.
#'
#' @usage data("retirementLoc")
#'
#' @format A data frame with 3146 rows and 21 variables:
#' \describe{
#'  \item{fips}{a five digit unique identifier of US counties}
#'   \item{lat}{latitude of county center in degrees}
#'   \item{lon}{longitude of county center in degrees}
#'   \item{state}{state name}
#'   \item{county}{county name}
#'   \item{pop_2020}{population estimate in 2020}
#'   \item{pct_pop_change}{percent population change from 2010 to 2020}
#'   \item{cbsa_desig}{a classification based on population density}
#'   \item{rucc_2013}{a classification of 1 through 9 on a rural-urban continuum}
#'   \item{partisan_lean}{percent voting Democrat in 2020 presidential race}
#'   \item{med_hh_inc_2019}{median household income for 2019}
#'   \item{pct_bachelor}{percent of county residents holding a bacherlor degree or higher}
#'   \item{broadband_2017}{percent households with broadband access}
#'   \item{life_exp}{life expectancy in years}
#'   \item{violent_crime_rate}{violent crimes per 100,000}
#'   \item{average_daily_pm2_5}{Average daily amount of fine particulate matter in micrograms per cubic meter}
#'   \item{prim_care_dr_rate}{primary care physicians per 100,000 population}
#'   \item{avg_annual_temp}{average annual temperature in fahrenheit}
#'   \item{median_home_price}{median home price}
#'   \item{yoy_price_chg_pct}{year-over-year percentage increase (-decrease) in home price}
#'   \item{years_to_payoff}{quotient of household income divided by median home price}
#' }
#'
#' @details
#'
#' The dataset includes the 50 US states and Washington D.C. disaggregated at the county
#' level.
#
#' @examples
#' #load
#' data("retirementLoc")
#' sum(retirementLoc$pop_2020)
"retirementLoc"

