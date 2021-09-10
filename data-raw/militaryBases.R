##################################################################
##                 OpenDataSoft: Military Bases                 ##
##                  url: https://bit.ly/3yVXhMn                 ##
##                    downloaded: 09/10/2021                    ##
##################################################################
# read in as semi colon as delim file ----
file <- system.file("extdata", "military-bases.csv", package = "retirementLoc")
mb <- readr::read_delim(file = file,
                        delim = ";",
                        show_col_types = FALSE
                        )
# format file ----
mb.1 <-
        mb %>%
        janitor::clean_names() %>%
        dplyr::select(-geo_shape) %>%
        separate(geo_point, into = c("lat", "lon"), sep = ",") %>%
        mutate(across(lat:lon, as.numeric)) %>%
        dplyr::filter(country == "United States") %>%
        dplyr::filter(oper_stat == "Active") %>%
        dplyr::select(lat, lon, objectid, site_name, perimeter, area) %>%
        mutate(across(perimeter:area, as.numeric)) %>%
        rename(base = site_name)
militaryBases <- mb.1
# save file ----
usethis::use_data(militaryBases, overwrite = TRUE)
