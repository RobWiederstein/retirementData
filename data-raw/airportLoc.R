## commercial airline service emplanements by airport ----
library(tidyverse)
file.path <- system.file(
        "extdata",
        "cy20-commercial-service-enplanements.xlsx",
        package = "retirementLoc"
)
#read in data - "f" for flights
df.f <- readxl::read_xlsx(
        file.path
)

us_airport_flights <-
        df.f %>%
        janitor::clean_names() %>%
        select(locid, everything())

# location data for commercial service airports
file.path <- system.file(
        "extdata",
        "NfdcFacilities.xls",
        package = "retirementLoc"
)
#read in data "l' for locations
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
        rename(lat = arp_latitude,
               lon = arp_longitude,
               airport = airport_name,
               enplane_2020 = cy_20_enplanements,
               enplane_2019 = cy_19_enplanements,
               pct_change = percent_change,
               location = locid) %>%
        select(lat, lon, everything()) %>%
        mutate(lat = gsub("N|W", "", lat) %>% angle2dec,
               lon = gsub("N|W", "", lon) %>% angle2dec %>% `*`(-1)
        ) %>%
        mutate(airport = gsub("International", "Int.", airport)) %>%
        tidyr::drop_na()
airportLoc$hub <- factor(airportLoc$hub, ordered = T,
                    labels = c("Large","Medium", "Small", "Non-hub", "None"))
# save
usethis::use_data(airportLoc, overwrite = TRUE)


