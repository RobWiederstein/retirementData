#' IRS  County-to-County Migration Data
#'
#' A dataset containing taxpayer location by county in 2018 and 2019.
#'
#' @usage data("irsMigration")
#'
#' @format A data frame with 102517 rows and 15 variables:
#' \describe{
#'   \item{flow}{direction of taxpayer toward or away from a county}
#'   \item{lat_origin}{population weighted latitude center  of originating county}
#'   \item{lon_origin}{population weighted longitude center  of originating county}
#'   \item{fips_origin}{five digit FIPS code for originating county}
#'   \item{state_origin}{name of originating state}
#'   \item{county_origin}{name of originating county}
#'   \item{lat_target}{population weighted latitude center of target county}
#'   \item{lon_target}{population weighted longitude center of target county}
#'   \item{fips_target}{five digit FIPS code for target county}
#'   \item{state_target}{name of target state}
#'   \item{county_target}{name of target county}
#'   \item{returns}{number of returns filed}
#'   \item{exempts}{number of total exemptions claimed}
#'   \item{agi}{adjusted gross income in thousands}
#'   \item{avg_agi}{adjusted gross income divided by number of returns}
#' }
#'
#' @details
#'
#' According to the IRS \href{https://www.irs.gov/statistics/soi-tax-stats-migration-data}{website}:
#' "Migration data for the United States are based on year-to-year address changes reported on
#' individual income tax returns filed with the IRS. They present migration patterns by State
#' or by county for the entire United States and are available for inflows—the number of new
#' residents who moved to a State or county and where they migrated from, and outflows—the n
#' umber of residents leaving a State or county and where they went.
#'
#' The data are available for filing Years 1991 through 2019 and include:
#' Number of returns filed, which approximates the number of households that migrated
#' Number of personal exemptions claimed, which approximates the number of individuals
#' Total adjusted gross income, starting with Filing Year 1995.  Aggregate migration
#' flows at the State level, by the size of adjusted gross income (AGI) and age of the
#' primary taxpayer, starting with Filing Year 2011."
#'
#' Counts below 20 at the county level were deleted, presumably, to prevent a taxpayer
#' from being identified. Data do not represent the full U.S. population because many
#' individuals are not required to file an individual income tax return.
#'
#' The IRS also publishes a helpful and comprehensive
#' \href{https://www.irs.gov/pub/irs-soi/1819inpublicmigdoc.pdf}{"Migration Data Users Guide and Record Layouts"}.
#'  \insertNoCite{IRS2021}{retirementData}
#'
#' @references
#'     \insertAllCited{}
#' @examples
#' #load
#' data("irsMigration")
"irsMigration"

