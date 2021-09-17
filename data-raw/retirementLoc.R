## code to prepare `retirementLoc` dataset goes here
library(magrittr)
library(retirementLoc)
df <-
      list(
            # utils
            fetch_county_coords(),
            fetch_county_fips_codes(),
            # demographics
            fetch_uscb_population(),
            fetch_cbsa_metro_label(),
            fetch_rural_urban_continuum(),
            fetch_partisan_lean(),
            fetch_usda_household_inc(),
            fetch_bachelor_degrees(),
            fetch_broadband_access(),
            # health
            fetch_ihme_life_expectancy(),
            fetch_chr_violent_crime_rate(),
            fetch_chr_avg_daily_pm_2_5(),
            fetch_chr_primary_care_doctors(),
            # weather
            fetch_noaa_avg_temp(),
            # valuation
            fetch_zillow_median_price(),
            fetch_zillow_yoy_price_chg_pct(),
            create_home_price_to_income_multiple()
      ) %>%
      reduce(left_join, by = "fips")

#drop missing location data
retirementLoc <-
      df %>%
      tidyr::drop_na(lat, lon)

#write out to public dataset
file <- "~/Dropbox/public/datasets/2021-08-30-retirement_location.csv"
write.csv(retirementLoc, file = file, row.names = F)
# save
usethis::use_data(retirementLoc, overwrite = TRUE)
