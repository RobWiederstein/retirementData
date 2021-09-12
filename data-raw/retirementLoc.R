## code to prepare `retirementLoc` dataset goes here
library(magrittr)
library(dplyr)
library(tidyr)
library(janitor)

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
        dplyr::filter(county != "000") %>%
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
        dplyr::filter(year == "2020") %>%
        #filter(county_fips == "37001") %>%
        dplyr::filter(party == "DEMOCRAT") %>%
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
        dplyr::filter(nchar(fips) %in% c(4, 5)) %>%
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
                      skip = 3,
                      show_col_types = FALSE)
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
                      col_select = c(state_abbr, fips),
                      show_col_types = FALSE)
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
                      skip = 0,
                      show_col_types = FALSE)
# clean
df <- janitor::clean_names(df)
county_lat_lon <-
        df %>%
        select(fips, pclon10, pclat10) %>%
        rename(lat = pclat10, lon = pclon10)

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
# health and environmental data from county health rankings ----
file <- system.file(
        "extdata",
        "2020 County Health Rankings Data - v2.xlsx",
        package = "retirementLoc"
)
df <- readxl::read_xlsx(path = file,
                        sheet = 4,
                        skip = 1,
                        n_max = 3195)

keep.cols <- c("FIPS", "State", "County", "Violent Crime Rate", "Average Daily PM2.5",
               "Primary Care Physicians Rate")
health_rankings <-
        df %>%
        select(all_of(keep.cols)) %>%
        janitor::clean_names() %>%
        tidyr::drop_na(county) %>%
        select(!c(state, county)) %>%
        rename(prim_care_dr_rate = primary_care_physicians_rate,
               avg_daily_pm_2_5 = average_daily_pm2_5) %>%
        mutate(prim_care_dr_rate = prim_care_dr_rate %>% round(1),
               violent_crime_rate = violent_crime_rate %>% round(1))
# cbsa metro/micro designations  ----
#https://www.census.gov/programs-surveys/metro-micro.html
file <- "https://data.nber.org/cbsa-csa-fips-county-crosswalk/cbsa2fipsxw.csv"
df <- readr::read_csv(file = file, col_types = cols(.default = "c"))

cbsa_codes <-
        df %>%
        janitor::remove_empty() %>%
        select(fipsstatecode,fipscountycode, centraloutlyingcounty,
               metropolitanmicropolitanstatis) %>%
        rename(state = fipsstatecode,
               county = fipscountycode,
               class = centraloutlyingcounty,
               status = metropolitanmicropolitanstatis) %>%
        tidyr::unite("fips", state:county, sep = "") %>%
        tidyr::unite("cbsa_desig", c(status, class), sep = "-") %>%
        dplyr::mutate(cbsa_desig = cbsa_desig %>%  tolower) %>%
        dplyr::mutate(cbsa_desig = gsub("politan statistical area", "", cbsa_desig))
# housing price index "HPI" from Federal Housing Finance ----
path <- system.file("extdata", "HPI_AT_BDL_county.xlsx", package = "retirementLoc")
housing_price_index <- readxl::read_xlsx(path = path,
                                         range = "A7:H91542",
                                         na = ".")
hpi <-
        housing_price_index %>%
        janitor::clean_names() %>%
        dplyr::filter(year == "2020") %>%
        mutate(annual_change_percent = annual_change_percent %>% as.numeric %>% round(1)) %>%
        select(fips_code, annual_change_percent) %>%
        rename(hpi_ann_chg_pct_2020 = annual_change_percent,
               fips = fips_code)
# merge data sources ----
retirementLoc <-
        left_join(uscb_county_pop,
                         us_part_lean,
                         by = "fips") %>%
        dplyr::filter(partisan_lean > 0) %>%
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
retirementLoc <-
        left_join(retirementLoc,
                  health_rankings,
                  by = "fips")

retirementLoc <-
        left_join(retirementLoc,
                  cbsa_codes,
                  by = "fips")
retirementLoc$cbsa_desig[which(is.na(retirementLoc$cbsa_desig)== T)] <- "rural-faraway"

retirementLoc <-
        left_join(retirementLoc,
                  hpi,
                  by = "fips")
#order the variables  !!!!!!
retirementLoc <-
        retirementLoc %>%
        select(lat, lon, fips:ctyname, cbsa_desig,
               pop_2020:hpi_ann_chg_pct_2020) %>%
        drop_na(lat, lon)

# funky import issue on '~' in Dona Ana
retirementLoc[which(retirementLoc$fips == "35013"), grep("ctyname", colnames(retirementLoc))] <- "Dona Ana"
#omit Hawaii and Alaska
retirementLoc <-
        retirementLoc %>%
        dplyr::filter(!stname %in% c("Hawaii", "Alaska"))
#rename variables
retirementLoc <-
        retirementLoc %>%
        rename(state = stname,
               county = ctyname)


#Amelia::missmap(retirementLoc)
file <- "~/Dropbox/public/datasets/2021-08-30-retirement_location.csv"
write.csv(retirementLoc, file = file, row.names = F)
# save
usethis::use_data(retirementLoc, overwrite = TRUE)
