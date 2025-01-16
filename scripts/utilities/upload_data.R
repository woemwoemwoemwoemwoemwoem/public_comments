# =============================================================
# TEMPLATE: Upload Files to a Google Drive Folder
# =============================================================

# Load Required Packages
library(googledrive)  # For Google Drive interactions
library(here)         # For constructing relative file paths

# STEP 1: Authenticate with Google Drive
# -------------------------------------------------------------
# When running `drive_auth()`, a browser window will open asking for 
# authorization. Log in and grant permission for R to access your Google Drive.
# This will store your credentials locally, so you won’t need to repeat this 
# unless the token expires.
drive_auth()

# STEP 2: Specify the Google Drive Folder
# -------------------------------------------------------------
# Replace `folder_id` with the ID of the folder where you want to upload files.
# The `folder_id` is the part of the Google Drive URL that looks like:
# https://drive.google.com/drive/folders/<folder_id>
folder_id <- "YOUR_FOLDER_ID_HERE"

# Retrieve the folder information using the folder ID
folder <- drive_get(as_id(folder_id))

# STEP 3: Specify Local Files to Upload
# -------------------------------------------------------------
# Use `list.files()` to specify the files you want to upload.
# Update the `path` argument to point to your local directory:
# - Use `here()` for relative paths within your project.
# - Use an absolute path for a specific folder location.
local_files <- list.files(
  path = here("data"), # Replace with your desired folder
  full.names = TRUE    # Includes full file paths for uploading
)

# STEP 4: Upload Files to Google Drive
# -------------------------------------------------------------
# Loop through the files in `local_files` and upload them to the specified 
# Google Drive folder.
# Use `overwrite = FALSE` to avoid overwriting existing files. 
# Change to `overwrite = TRUE` if you want to replace existing files.

lapply(
  local_files,  # Loop through local file paths
  function(file) {
    drive_upload(
      media = file,        # Local file path
      path = as_id(folder_id), # Target Google Drive folder
      overwrite = FALSE    # Set to TRUE to overwrite existing files
    )
  }
)

# =============================================================
# CUSTOMIZATION NOTES:
# -------------------------------------------------------------
# 1. Replace `YOUR_FOLDER_ID_HERE` with the ID of your Google Drive folder.
# 2. To specify files for upload:
#    - Update the `path` argument in `list.files()`:
#      a) Use `here()` for relative paths within your project (e.g., here("data")).
#      b) Use an absolute file path for a specific location (e.g., "/path/to/your/folder").
#    - Add filters like `pattern = "\\.csv$"` to upload only specific file types (e.g., `.csv` files).
# 3. Use `overwrite = TRUE` only if you want to replace files in the target folder.
# 4. If you encounter upload errors, ensure the local directory and file paths are correct.
# =============================================================
