## commercial airline service emplanements by airport ----
library(tidyverse)
file.path <- system.file(
        "extdata",
        "cy20-commercial-service-enplanements.xlsx",
        package = "retirementLoc"
)
#read in data
df.f <- readxl::read_xlsx(
        file.path
)


file.path <- system.file(
        "extdata",
        "NfdcFacilities.xls",
        package = "retirementLoc"
)
us_airport_flights <-
        df.f %>%
        janitor::clean_names() %>%
        select(locid, everything())
# location data for commercial service airports
#read in data
col_select <- c("LocationID", "ARPLatitude", "ARPLongitude")
df.l <- readr::read_tsv(
        file.path,
        col_select = col_select,
        show_col_types = FALSE
)
us_airport_locations <-
        df.l %>%
        janitor::clean_names() %>%
        mutate(location_id = gsub("'", "", location_id)) %>%
        rename(locid = location_id)

angle2dec <- function(angle) {
        angle <- as.character(angle)
        x <- do.call(rbind, strsplit(angle, split='-'))
        x <- apply(x, 1L, function(y) {
                y <- as.numeric(y)
                y[1] + y[2]/60 + y[3]/3600
        })
        return(x)
}

airportLoc <-
        dplyr::left_join(us_airport_flights,
                         us_airport_locations,
                         by = "locid") %>%
        rename(lat = arp_latitude, lon = arp_longitude, airport = airport_name) %>%
        select(lat, lon, everything()) %>%
        mutate(lat = gsub("N|W", "", lat) %>% angle2dec,
               lon = gsub("N|W", "", lon) %>% angle2dec %>% `*`(-1)
        ) %>%
        mutate(airport = gsub("International", "Int.", airport)) %>%
        tidyr::drop_na()
# save
usethis::use_data(airportLoc, overwrite = TRUE)


