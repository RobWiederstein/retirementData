## code to prepare `retirementLoc` dataset goes here
library(magrittr)
library(dplyr)
library(tidyr)

# population ----
file.path <- system.file(
        "extdata",
        "co-est2020.csv",
        package = "retirementLoc"
)
#read in data
df <- readr::read_csv(
        file.path,
        show_col_types = FALSE
)
# rename variables
df <- janitor::clean_names(df)

# tidy data
uscb_county_pop <-
        df %>%
        filter(county != "000") %>%
        unite(fips, state:county, sep = "") %>%
        mutate(ctyname = gsub(" County", "", ctyname)) %>%
        select(fips, stname, ctyname, census2010pop, popestimate2020) %>%
        mutate(census2010pop = census2010pop %>% as.integer) %>%
        mutate(pct_change = (popestimate2020 - census2010pop) / census2010pop) %>%
        mutate(pct_change = round(pct_change * 100, 1)) %>%
        select(-census2010pop) %>%
        rename(pop_2020 = popestimate2020,
                      pct_pop_change = pct_change)

# partisan lean ----
# retrieve paths to datafiles
file.path <- system.file(
        "extdata",
        "countypres_2000-2020.csv",
        package = "retirementLoc"
)
#read in data
df <- read.csv(file = file.path,
               colClasses = "character")
# rename variables
df <- janitor::clean_names(df)

us_part_lean <-
        df %>%
        filter(year == "2020") %>%
        #filter(county_fips == "37001") %>%
        filter(party == "DEMOCRAT") %>%
        mutate(across(candidatevotes:totalvotes, as.integer)) %>%
        group_by(county_fips, totalvotes) %>%
        summarize(cast = sum(candidatevotes)) %>%
        mutate(partisan_lean = cast / totalvotes,
                      partisan_lean = (partisan_lean * 100) %>% round(1)
                      ) %>%
        select(county_fips, partisan_lean) %>%
        rename(fips = county_fips) %>%
        drop_na() %>%
        ungroup()

# life expectancy ----
file.path <- system.file(
        "extdata",
        "IHME_USA_COUNTY_LE_MORTALITY_RISK_1980_2014_NATIONAL_Y2017M05D08.XLSX",
        package = "retirementLoc"
)
#read in data
df <- readxl::read_xlsx(path = file.path,
                        skip = 1,
                        col_types = "text",
                        n_max = 3196)
#
df <- janitor::clean_names(df)
life_exp <-
        df %>%
        select(fips, life_expectancy_2014) %>%
        separate(life_expectancy_2014, sep = " " ,
                 into = c("life_exp", NA), extra = "drop") %>%
        drop_na() %>%
        mutate(fips = stringr::str_trim(fips, side = "both")) %>%
        filter(nchar(fips) %in% c(4, 5)) %>%
        mutate(life_exp = life_exp %>% as.numeric) %>%
        mutate(fips = stringr::str_pad(fips, width = 5, side = "left", pad = "0"))

# get average temperature data ----
file.path <- system.file(
        "extdata",
        "110-tavg-202107-1.csv",
        package = "retirementLoc"
)
#read in data
df <- readr::read_csv(file = file.path,
                      skip = 3)
#
df <- janitor::clean_names(df)
avg_temp <-
        df %>%
        separate(location_id, into = c("state", "county"), sep = "-") %>%
        select(state, county, value)
## get state fips codes ----
file.path <- system.file(
        "extdata",
        "state_fips_master.csv",
        package = "retirementLoc"
)
df <- readr::read_csv(file = file.path,
                      skip = 0,
                      col_select = c(state_abbr, fips))
#
df <- janitor::clean_names(df)

state_fips_codes <-
        df %>%
        rename(state = state_abbr) %>%
        mutate(fips = stringr::str_pad(fips, 2, side = "left", pad = 0))
avg_temp <-
        left_join(avg_temp, state_fips_codes, by = "state")
## end state fips codes
avg_temp <-
        avg_temp %>%
        unite(fips, c("fips", "county"), sep = "") %>%
        select(fips, value) %>%
        rename(avg_ann_temp = value)

# county lat and lon  ---
file.path <- system.file(
        "extdata",
        "county_centers.csv",
        package = "retirementLoc"
)
#read in data
df <- readr::read_csv(file = file.path,
                      skip = 0)
# clean
df <- janitor::clean_names(df)
county_lat_lon <-
        df %>%
        select(fips, clon00, clat00) %>%
        rename(lat = clat00, lon = clon00)

# housing and broadband from uscb ----
file <- system.file(
        "extdata",
        "2021-08-28_uscb_housing.csv",
        package = "retirementLoc"
)
#read in data
df <- readr::read_csv(file = file,
                      skip = 0)
# clean
df <- janitor::clean_names(df)
country <- "US"
inflation_dataframe <- priceR::retrieve_inflation_data(country)
countries_dataframe <- priceR::show_countries()
df$median_val_owner_occupied_2019 <- priceR::afi(df$median_val_owner_occupied_2010,
                                                 country = "US",
                                                 from_date = 2010,
                                                 to_date = 2019,
                                                 inflation_dataframe = inflation_dataframe,
                                                 countries_dataframe = countries_dataframe)
home_values <-
        df %>%
        mutate(years_to_payoff = median_val_owner_occupied_2019 / median_household_income_2019,
               years_to_payoff = years_to_payoff %>% round(1)) %>%
        select(fips, broadband_2017, years_to_payoff) %>%
        mutate(fips = stringr::str_pad(fips, width = 5, side = "left", pad = "0"))


# merge data sources ----
retirementLoc <-
        left_join(uscb_county_pop,
                         us_part_lean,
                         by = "fips") %>%
        filter(partisan_lean > 0) %>%
        distinct() %>%
        drop_na()
retirementLoc <-
        left_join(retirementLoc,
                         life_exp,
                         by = "fips")
retirementLoc <-
        left_join(retirementLoc,
                         avg_temp,
                         by = "fips")
retirementLoc <-
        left_join(retirementLoc,
                         county_lat_lon,
                         by = "fips")
retirementLoc <-
        left_join(retirementLoc,
                                  home_values,
                                  by = "fips")

#order the variables
retirementLoc <-
        retirementLoc %>%
        select(lat, lon, fips:years_to_payoff)


# save
usethis::use_data(retirementLoc, overwrite = TRUE)
