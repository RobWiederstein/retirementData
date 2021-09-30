##################################################################
##         The Centers for Medicare & Medicaid Services         ##
##                 Hospital General Information                 ##
##   url:https://data.cms.gov/provider-data/dataset/xubh-q36u   ##
##                    downloaded: 09/092021                     ##
##################################################################
# load libraries ----
library(ggmap)
# download file ----
url <- "https://data.cms.gov/provider-data/sites/default/files/resources/092256becd267d9eeccf73bf7d16c46b_1623902717/Hospital_General_Information.csv"
destfile <- paste0("./inst/extdata/", basename(url))
if(!(file.exists(destfile))){
        download.file(url = url, destfile = destfile)
        }else{
                print("file already exists")
        }
# open file ----
file <- system.file("extdata",
                    "Hospital_General_Information.csv",
                    package = "retirementLoc"
                    )
df <- readr::read_csv(file = file, show_col_types = FALSE)
# clean data ----
df.1 <-
        df %>%
        janitor::clean_names() %>%
        dplyr::select(facility_id:zip_code, hospital_type:emergency_services, hospital_overall_rating)
# prepare for geotagging ----
df.2 <-
        df.1 %>%
        unite(geocode, address:state, sep = ", ", remove = F) %>%
        mutate(lon = "",
               lat = "")
# Loop through the addresses to get the latitude and longitude of each address and add it to the
# df.2 data frame in new columns lat and lon
for(i in 1:nrow(df.2)){
        print(i)
        result <- geocode(df.2$geocode[i], output = "latlona", source = "google")
        print(result)
        df.2$lon[i] <- as.numeric(result[1])
        df.2$lat[i] <- as.numeric(result[2])
}
#spruce
hospitalLoc <-
        df.2 %>%
        select(lat, lon, everything()) %>%
        drop_na() %>%
        distinct() %>%
        rename(id = facility_id,
               name = facility_name,
               type = hospital_type,
               ownership = hospital_ownership,
               emer_room = emergency_services,
               stars = hospital_overall_rating) %>%
        mutate(verify = "<a href='www.medicare.gov/care-compare'>Hospital Compare</a>") %>%
        select(lat, lon, name, type:verify) %>%
        mutate(lat = lat %>% as.numeric,
               lon = lon %>% as.numeric)
hospitalLoc

# save file ----
usethis::use_data(hospitalLoc, overwrite = TRUE)


