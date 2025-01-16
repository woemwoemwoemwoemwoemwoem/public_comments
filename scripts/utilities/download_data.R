# =============================================================
# TEMPLATE: Download Files from the SpaSES Google Drive
# =============================================================

# Load Required Packages
library(googledrive)  # For Google Drive interactions
library(here)         # For constructing relative file paths

# STEP 1: Authenticate with Google Drive
# -------------------------------------------------------------
# When running `drive_auth()`, a browser window will open asking for 
# authorization. You need to log in and grant permission for R to access
# your Google Drive. This will store your credentials locally, so you 
# won’t have to repeat the process unless the token expires.
drive_auth()

# STEP 2: Specify the Google Drive Folder
# -------------------------------------------------------------
# Replace the `folder_id` with the ID of the folder you want to download files from.
# The `folder_id` is the part of the Google Drive URL that looks like:
# https://drive.google.com/drive/folders/<folder_id>
folder_id <- "YOUR_FOLDER_ID_HERE"

# Retrieve the folder information using the folder ID
folder <- drive_get(as_id(folder_id))

# STEP 3: List Files in the Folder
# -------------------------------------------------------------
# Use `drive_ls()` to list all files in the specified folder.
# Note: If there are subfolders, this function will not list files 
# in the subfolders. Each subfolder must be processed separately.
gdrive_files <- drive_ls(folder)

# STEP 4: Download Files to a Local Directory
# -------------------------------------------------------------
# Specify where you want to save the downloaded files.
# Update the file path (`here("data", ...)`) to your desired location.
# For example:
# - Save files to the project's "data" folder: here("data", ...)
# - Save files to an absolute path: "/path/to/your/folder"
# 
# Use `overwrite = FALSE` to avoid overwriting existing files.
# If `overwrite = TRUE`, existing files with the same name will be replaced.

# Download all files listed in `gdrive_files`
lapply(
  gdrive_files$id,  # Loop through the IDs of the files in the folder
  function(file_id) {
    drive_download(
      as_id(file_id),  # Google Drive file ID
      path = here("data", gdrive_files[gdrive_files$id == file_id, ]$name), # Local save path
      overwrite = FALSE  # Change to TRUE if you want to overwrite existing files
    )
  }
)

# =============================================================
# CUSTOMIZATION NOTES:
# -------------------------------------------------------------
# 1. Replace `YOUR_FOLDER_ID_HERE` with the ID of your Google Drive folder.
# 2. To change the local file path:
#    - Update the `path` argument in `drive_download()`:
#      a) Use `here()` for relative paths within your project (e.g., here("data", ...)).
#      b) Use an absolute file path for a specific location (e.g., "/path/to/your/folder").
#    - Ensure the directory exists before running the script.
# 3. If the folder contains subfolders, you must handle each subfolder separately 
#    by updating `folder_id` and re-running the script for each subfolder.
# 4. Use `overwrite = TRUE` only if you want to replace files in the local directory.
# =============================================================
