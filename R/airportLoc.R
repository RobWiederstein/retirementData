#' US Airport Locations
#'
#' A dataset containing airport locations for commercial flights.
#'
#' @usage data("airportLoc")
#'
#' @format A data frame with 445 rows and 13 variables:
#' \describe{
#'   \item{lat}{latitude of airport}
#'   \item{lon}{longitude of airport}
#'   \item{location}{a three character unique identifier of US airports}
#'   \item{rank}{an integer that ranks airport by passenger volume}
#'   \item{ro}{region}
#'   \item{st}{state}
#'   \item{city}{city}
#'   \item{airport}{airport name}
#'   \item{s_l}{a classification of either 'CS'  for 'commercial service'
#'   or 'P' for primary}
#'   \item{hub}{an ordered factor variable specifying size of airport}
#'   \item{enplane_2020}{number of passengers boarded in 2020}
#'   \item{enplane_2019}{number of passengers boarded in 2019}
#'   \item{pct_change}{percent increase/decrease from 2019 to 2020}
#' }
#'
#' @details
#'
#' Data consist of "Enplanements at All Commercial Service Airports."  A "commercial
#' service" airport is a publicly owned airport "with at least 2,500 annual enplanements
#' and scheduled air carrier service." U.S.C. §47102(7). "Primary airports" are a commercial
#' service airport with more than 10,000 annual enplanements. U.S.C. §47102(16).
#'
#' Commercial service airports are further classified by size:
#' \itemize{
##'  \item{Large Hub -- }{Receives 1 percent or more of the annual U.S. commercial enplanements;}
##'  \item{Medium Hub -- }{Receives 0.25 to 1.0 percent of the annual U.S. commercial enplanements;}
##'  \item{Small Hub -- }{Receives 0.05 to 0.25 percent of the annual U.S. commercial enplanements;}
##'  \item{Nonhub -- }{Receives less than 0.05 percent but more than 10,000 of the annual U.S.
##'  commercial enplanements.}
##' }\insertCite{FAAcategories2020}{retirementData}
#'  \insertNoCite{FAAairports2020}{retirementData}
#'  \insertNoCite{FAAcontact2021}{retirementData}
#'
#' @references
#'     \insertAllCited{}
#' @examples
#' #load
#' data("airportLoc")
"airportLoc"

