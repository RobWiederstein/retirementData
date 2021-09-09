##################################################################
##        Integrated Postsecondary Education Data System        ##
##                            IPEDS                             ##
##         url = https://nces.ed.gov/ipeds/use-the-data         ##
##                     download: 09/08/2021                     ##
##################################################################
# load file ----
file <- system.file("extdata", "2021-09-08_nces_ipeds_download.csv", package = "retirementLoc")
us_colleges <-readr::read_csv(file = file,
                     show_col_types = FALSE)
# clean names ----
us_colleges <- us_colleges %>% janitor::clean_names()
# manipulate data ----
df.1 <-
        us_colleges %>%
        rename(id = unit_id,
               name = institution_name,
               title_4 = postsecondary_and_title_iv_institution_indicator_hd2020,
               fips_state = fips_state_code_hd2020,
               address = street_address_or_post_office_box_hd2020,
               city = city_location_of_institution_hd2020,
               state = state_abbreviation_hd2020,
               zip = zip_code_hd2020,
               lon = longitude_location_of_institution_hd2020,
               lat = latitude_location_of_institution_hd2020,
               fips = fips_county_code_hd2020,
               students_2020 = grand_total_effy2020_all_students_total
        ) %>%
        select(lat, lon, id, fips, state, name, students_2020) %>%
        mutate(fips = stringr::str_pad(fips, width = 5, side = "left", pad = "0")) %>%
        tidyr::drop_na() %>%
        dplyr::filter(students_2020 > 5000)
# rename ----
collegeLoc <- df.1
# save ----
usethis::use_data(collegeLoc, overwrite = T)
