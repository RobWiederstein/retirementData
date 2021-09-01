#' Criteria for Retirement Location
#'
#' A dataset containing criteria for relocation in retirement.
#'
#' @usage data("retirementLoc")
#'
#' @format A data frame with 3104 rows and 15 variables:
#' \describe{
#'   \item{lat}{latitude of county center in degrees}
#'   \item{lon}{longitude of county center in degrees}
#'   \item{fips}{a five digit unique identifier of US counties}
#'   \item{stname}{state}
#'   \item{ctyname}{county name}
#'   \item{pop_2020}{population estimate in 2020}
#'   \item{pct_pop_change}{percent population change from 2010 to 2020}
#'   \item{partisan_lean}{percent voting Democrat in 2020 presidential race}
#'   \item{life_exp}{life expectancy in years}
#'   \item{avg_ann_temp}{average annual temperature in fahrenheit}
#'   \item{broadband_2017}{percent households with broadband access}
#'   \item{years_to_payoff}{years to payoff home}
#'   \item{violent_crime_rate}{violent crimes per 100,000}
#'   \item{avg_daily_pm_2_5}{Average daily amount of fine particulate matter in micrograms per cubic meter}
#'   \item{prim_care_dr_rate}{primary care physicians per 100,000 population}
#' }
#'
#' @details
#'
#' The latitude and longitude, or county centroids, were downloaded from the \href{https://github.com/btskinner/spatial}{btskinner/spatial} repo maintained by Professor Benjamin Skinner.
#'
#' The population data is from the \href{https://www2.census.gov/programs-surveys/popest/datasets/2010-2020/counties/totals/co-est2020.csv}{U.S. Census Bureau}.
#'
#' The partisan lean was computed from the 2020 US presidential election results
#' furnished by the \href{https://electionlab.mit.edu/data}{Election Lab at MIT}.
#'
#' The life expectancy data was downloaded from The Institute for Health Metrics
#' and Evaluation (IHME). The webpage was entitled, "\href{http://ghdx.healthdata.org/record/ihme-data/united-states-life-expectancy-and-age-specific-mortality-risk-county-1980-2014}{United States Life Expectancy and Age-specific Mortality Risk by County 1980-2014}
#'
#' Average annual temperature was downloaded from \href{https://www.ncdc.noaa.gov/cag/county/mapping}{NOAA National Center for Environmental Information}.
#'
#' Broadband coverage is from the US Census Bureau and represents the percentage
#'  of households having access to broadband in 2017.
#'
#' Years to payoff is computed from US Census Bureau data.  It represents the median
#' value of owner occupied housing in 2010 adjusted for inflation to 2020 divided by the
#' annual median household income.
#'
#' The average daily particulate matter 2.5 microns was downloaded from \href{https://www.countyhealthrankings.org}{County Health Rankings},
#' although it is available from the Environmental Protection Agency as well.  Particulate Matter (PM). PM2.5 describes fine inhalable
#' particles, with diameters that are generally 2.5 micrometers and smaller. While the levels have been
#' decreasing over time, they cause serious health problems.
#'
#' The violent crime rate was downloaded from \href{https://www.countyhealthrankings.org}{County Health Rankings}.
#' The data is derived from The Uniform Crime Reporting (UCR) Program. 17,000 law enforcement
#' agencies across the United States submit the data to the FBI which is charged with collecting and
#' publishing it.
#'
#' The primary care physician rate is important to insure that the public can access preventive and primary care. The information is
#' collected by \href{https://www.countyhealthrankings.org}{County Health Rankings} from over 50 sources.
#'
#' @examples
#' #load
#' data("retirementLoc")
#' sum(retirementLoc$pop_2020)
"retirementLoc"

