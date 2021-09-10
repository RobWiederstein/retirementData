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
# origAddress <-
#         df.1 %>%
#         select(facility_name:zip_code) %>%
#         unite(addresses, address:state, sep = ", ")
# # Initialize the data frame ----
# geocoded <- data.frame(stringsAsFactors = FALSE)
# Loop through the addresses to get the latitude and longitude of each address and add it to the
# origAddress data frame in new columns lat and lon
# for(i in 1:nrow(origAddress)){
#         # Print("Working...")
#         result <- geocode(origAddress$addresses[i], output = "latlona", source = "google")
#         origAddress$lon[i] <- as.numeric(result[1])
#         origAddress$lat[i] <- as.numeric(result[2])
#         origAddress$geoAddress[i] <- as.character(result[3])
# }
#
# origAddress.1 <- origAddress %>% distinct()
# # Write a CSV file containing origAddress to the working directory
# write.csv(origAddress, "geocoded.csv", row.names=FALSE)

file <- system.file("extdata",
                    "geocoded_hospital_addresses.csv",
                    package = "retirementLoc")
col_select <- c("facility_name", "lon", "lat")
origAddress <- readr::read_csv(file = file,
                               col_select = col_select)
df.2 <-
        dplyr::left_join(df.1, origAddress, by = "facility_name")
df.3 <-
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
        select(lat, lon, name, type:verify)
hospitalLoc <- df.3
# save file ----
usethis::use_data(hospitalLoc, overwrite = TRUE)


