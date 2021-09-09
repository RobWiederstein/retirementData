##################################################################
##                    IRS SOI Migration Data                    ##
##                 url: www.irs.gov/pub/irs-soi                 ##
##                     downloaded: 09/10/21                     ##
##################################################################
# download outflow data ----
url <- "https://www.irs.gov/pub/irs-soi/countyoutflow1819.csv"
destfile <- paste0("./inst/extdata/", basename(url))
if(!(file.exists(destfile))){
        download.file(url = url, destfile = destfile)
}else{
        print("file already exists")
}
# read in ----
file <- system.file("extdata",
        "countyoutflow1819.csv",
        package = "retirementLoc"
)
irs_soi_out <- readr::read_csv(file = file,
                               show_col_types = F)

#Each state file contains six header records, for each county
headers <- c("96000", "97000", "97001", "97003", "98000", "10001")

# county-to-county flows that have less than 10 returns have been categorized
# into seven “Other flows” categories
other_flows <- c("58000", "59000", "59001", "59003", "59005", "59007",
                 "59009", "57009")
df.out <-
        irs_soi_out %>%
        unite(fips_origin, y1_statefips:y1_countyfips, sep = "", remove = T) %>%
        unite(fips_target, y2_statefips:y2_countyfips, sep = "", remove = T) %>%
        rename(state_target = y2_state,
               county_target = y2_countyname,
               returns = n1,
               exempts = n2) %>%
        dplyr::filter(!fips_target %in% headers) %>%
        dplyr::filter(!fips_target %in% other_flows) %>%
        mutate(avg_agi = agi %>% `*`(1e3) %>%  `/`(returns) %>% round(0)) %>%
        mutate(flow = "out") %>%
        select(flow, everything())

# merge with county fips codes ----
url <- "https://raw.githubusercontent.com/kjhealy/fips-codes/master/county_fips_master.csv"
destfile <- paste0("./inst/extdata/", basename(url))
if(!(file.exists(destfile))){
        download.file(url = url, destfile = destfile)
}else{
        print("file already exists")
}
file <- system.file("extdata",
                    "county_fips_master.csv",
                    package = "retirementLoc"
)

fips <- readr::read_csv(file = file,
                        col_select = fips:state_abbr,
                        show_col_types = F)
df.fips <-
        fips %>%
        mutate(fips = stringr::str_pad(fips,
                                       width = 5,
                                       side = "left",
                                       pad = "0")
        ) %>%
        rename(fips_origin = fips,
               county_origin = county_name,
               state_origin = state_abbr)

df.out.1 <-
        left_join(df.out, df.fips, by = "fips_origin")

df.out.2 <-
        df.out.1 %>%
        select(flow, fips_origin, state_origin, county_origin, everything())

# download irs migration inflow ----
url <- "https://www.irs.gov/pub/irs-soi/countyinflow1819.csv"
destfile <- paste0("./inst/extdata/", basename(url))
if(!(file.exists(destfile))){
        download.file(url = url, destfile = destfile)
}else{
        print("file already exists")
}
# read in file ----
file <- system.file("extdata",
                    "countyinflow1819.csv",
                    package = "retirementLoc"
                    )
irs_soi_in <- readr::read_csv(file = file,
                              show_col_types = FALSE)

# files represent the migration flows into the destination state
#Each state file contains six header records, for each county
headers <- c("96000", "97000", "97001", "97003", "98000", "10001")

# county-to-county flows that have less than 10 returns have been categorized
# into seven “Other flows” categories
other_flows <- c("58000", "59000", "59001", "59003", "59005", "59007",
                 "59009", "57009")
df.in <-
        irs_soi_in %>%
        unite(fips_target, y2_statefips:y2_countyfips, sep = "", remove = T) %>%
        unite(fips_origin, y1_statefips:y1_countyfips, sep = "", remove = T) %>%
        rename(state_origin = y1_state,
               county_origin = y1_countyname,
               returns = n1,
               exempts = n2) %>%
        dplyr::filter(!fips_origin %in% headers) %>%
        dplyr::filter(!fips_origin %in% other_flows) %>%
        mutate(avg_agi = agi %>% `*`(1e3) %>%  `/`(returns) %>% round(0)) %>%
        mutate(flow = "in") %>%
        select(flow, everything())
## county fips codes ----
file <- system.file("extdata",
                    "county_fips_master.csv",
                    package = "retirementLoc"
)
fips <- readr::read_csv(file = file,
                        col_select = fips:state_abbr,
                        show_col_types = FALSE)
df.fips <-
        fips %>%
        mutate(fips = stringr::str_pad(fips,
                                       width = 5,
                                       side = "left",
                                       pad = "0")
        ) %>%
        rename(fips_target = fips,
               county_target = county_name,
               state_target = state_abbr)

df.in.1 <-
        left_join(df.in, df.fips, by = "fips_target")

df.in.2 <-
        df.in.1 %>%
        select(flow, fips_target, state_target, county_target, everything())

# combine inflow and outflow ----
df <- dplyr::bind_rows(df.out.2,
                       df.in.2)



# add lat lon ----
url <- "https://raw.githubusercontent.com/btskinner/spatial/master/data/county_centers.csv"
destfile <- paste0("./inst/extdata/", basename(url))
if(!(file.exists(destfile))){
        download.file(url = url, destfile = destfile)
}else{
        print("file already exists")
}
file <- system.file("extdata",
                    "county_centers.csv",
                    package = "retirementLoc"
)
county_centroids <- readr::read_csv(file = file,
                                    col_select = c(fips, pclon10, pclat10),
                                    show_col_types = F)
df.1 <-
        df %>%
        dplyr::left_join(. ,
                         county_centroids,
                         by = c("fips_origin" = "fips")
        ) %>%
        rename(lon_origin = pclon10,
               lat_origin = pclat10)
df.2 <-
        df.1 %>%
        dplyr::left_join(.,
                         county_centroids,
                         by = c("fips_target" = "fips")) %>%
        rename(lon_target = pclon10,
               lat_target = pclat10)
df.3 <-
        df.2 %>%
        select(flow, lat_origin, lon_origin, fips_origin:county_origin,
               lat_target, lon_target, fips_target:county_target,
               everything()) %>%
        tidyr::drop_na()
irsMigration <- df.3

# save file ----
usethis::use_data(irsMigration, overwrite = TRUE)
