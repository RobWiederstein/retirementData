#' Criteria for Retirement Location
#'
#' A dataset containing criteria for relocation in retirement.
#'
#' @format A data frame with 3112 rows and 12 variables:
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
#' }
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
#' The regional price parity index by MSA was downloaded from the Bureau of
#' Economic Analysis \href{https://apps.bea.gov/itable/drilldown.cfm?reqid=70&stepnum=40&Major_Area=5&State=00000&Area=XX&TableId=104&Statistic=1&Year=2019&YearBegin=-1&Year_End=-1&Unit_Of_Measure=Levels&Rank=0&Drill=1}{webpage}.
#'
#' Broadband coverage is from the US Census Bureau and represents the percentage
#'  of households having access to broadband in 2017.
#'
#' Years to payoff is computed from US Census Bureau data.  It represents the median
#' value of owner occupied housing in 2010 adjusted for inflation to 2020 divided by the
#' annual median household income.
"retirementLoc"
