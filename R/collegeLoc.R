#' US College Locations Greater than 5,000
#'
#' A dataset containing US college locations with total student enrollments
#' greater than 5,000.
#'
#' @usage data("collegeLoc")
#'
#' @format A data frame with 1254 rows and 7 variables:
#' \describe{
#'   \item{lat}{latitude of college}
#'   \item{lon}{longitude of colege}
#'   \item{id}{a unique identifier assigned by IPEDS}
#'   \item{fips}{county FIPS code}
#'   \item{state}{state name}
#'   \item{name}{school name}
#'   \item{students_2020}{total student enrollments in 2020}
#' }
#' \insertNoCite{IPEDS2021}{retirementLoc}
#' @references
#'     \insertAllCited{}
#' @examples
#' # load
#' data("collegeLoc")
"collegeLoc"
