# =============================================================
# TEMPLATE: Creating Metadata using the Dataspice Package
# =============================================================

# Load necessary libraries
library(readr)
library(dataspice)
library(listviewer)
library(readxl)
library(tidyr)
library(dplyr)
library(jsonlite)
library(here)


# Define file paths for data and variable information files
# Replace these with the actual file paths for your data and metadata
data_files <- list(
  "Data_File1" = here("data", "Data_File1.xlsx"),
  "Data_File2" = here("data", "Data_File2.xlsx")
)

variable_info_files <- list(
  "Info_File1" = here("metadata_info", "original", "Info_File1.xlsx"),
  "Info_File2" = here("metadata_info", "original", "Info_File2.xlsx")
)

# Read in data and variable information files
data_list <- lapply(data_files, read_excel)
variable_info_list <- lapply(variable_info_files, read_excel)

# Reshape data as or if needed
# 

# Save each reshaped data frame to a CSV file
output_paths <- lapply(names(data_files), function(name) {
  path <- here("data", paste0(name, ".csv"))       
  write.csv(data_list[[name]], path, row.names = FALSE)
  path
})

# Initialize dataspice metadata structure
create_spice(path = here("metadata_info", "processed"))

# Fill in and customize each section of the metadata
# The following steps guide the user to manually edit files as needed

# creators.csv - Information about data creators
edit_creators(path = here("metadata_info", "processed"))  # Manually add details of dataset creators

# access.csv - Information on data access
prep_access(path = here("metadata_info", "processed"))    # Automatically populate some access details
edit_access(path = here("metadata_info", "processed"))    # Manually edit as needed

# biblio.csv - Bibliographic metadata (title, description, temporal/spatial coverage)
# Edit biblio details manually
edit_biblio(path = here("metadata_info", "processed"))

# attributes.csv - Variable details in the dataset
prep_attributes(path = here("metadata_info", "processed"))  # Extract attributes from data files
edit_attributes(path = here("metadata_info", "processed"))  # Manually edit variable details

# Export metadata to JSON format for individual metadata components
metadata_files <- c("attributes.csv", "biblio.csv", "creators.csv", "access.csv")
metadata_json <- list()

for (file in metadata_files) {
  csv_data <- read_csv(here("metadata_info", "processed", file))
  json_data <- as.list(csv_data)
  write_json(json_data, here("metadata_info", "processed", paste0(file, ".json")), pretty = TRUE)
  metadata_json[[gsub(".csv", "", file)]] <- json_data
}

# Combine JSON metadata files into a single JSON structure
combined_metadata <- list(
  attributes = metadata_json[["attributes"]],
  biblio = metadata_json[["biblio"]],
  creators = metadata_json[["creators"]],
  access = metadata_json[["access"]]
)

# Save combined JSON metadata
write_json(combined_metadata, here("metadata_info", "final", "dataspice_combined.json"), pretty = TRUE)

# View combined metadata
combined_json <- read_json(here("metadata_info", "final", "dataspice_combined.json"))
listviewer::jsonedit(combined_json)