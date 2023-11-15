# script.R

library(rvest)
library(RSelenium)
library(httr)
library(tidyverse)

# Retrieve GitHub secrets
github_user <- Sys.getenv("INPUT_USER")
github_pw <- Sys.getenv("INPUT_PW")

# Set up Selenium driver
driver <- rsDriver(browser = "firefox")
remDr <- driver[["client"]]

# Navigate to the website and perform login
url <- "https://nbco.localgov.ie/en/user/?destination=bcms/dashboard"
remDr$navigate(url)

# Find and fill in the login form
remDr$findElement(using = "name", value = "username")$sendKeysToElement(list(github_user))
remDr$findElement(using = "name", value = "password")$sendKeysToElement(list(github_pw))
remDr$findElement(using = "tag name", value = "form")$submitForm()

# Wait for the page to load (adjust the time according to your website)
Sys.sleep(5)

# Select drop-downs
# Replace "dropdown1" and "dropdown2" with the appropriate identifiers on your website
# Select the dropdown by ID
dropdown <- remDr$findElement(using = "css selector", value = "#edit-date-from")

# Click on the dropdown to open the options
dropdown$click()

# Select an option by its value
option_value <- "2015-01"
remDr$findElement(using = "css selector", value = paste0("#edit-date-from option[value='", option_value, "']"))$click()
Sys.sleep(2)  # Adjust the time if needed
dropdown <- remDr$findElement(using = "css selector", value = "#edit-date-to")

# Click on the dropdown to open the options
dropdown$click()

# Select an option by its value
option_value <- "2023-11"
remDr$findElement(using = "css selector", value = paste0("#edit-date-from option[value='", option_value, "']"))$click()
Sys.sleep(2)

# Select the dropdown by class
file_format_dropdown <- remDr$findElement(using = "css selector", value = ".nice-select.form-select.required.nice-select-processed")

# Click on the dropdown to open the options
file_format_dropdown$click()

# Select an option by its value (e.g., "CSV")
option_value <- "csv"
remDr$findElement(using = "css selector", value = paste0(".nice-select.form-select.required.nice-select-processed li[data-value='", option_value, "']"))$click()

# Download the zipped file
# Replace "download_button" with the appropriate identifier on your website
# Find and click the "Download" button by ID
download_button <- remDr$findElement(using = "css selector", value = "#edit-submit")
download_button$click()

# Wait for the download to complete (adjust the time if needed)
Sys.sleep(10)

# Move the downloaded file to the repository directory
downloaded_zip_path <- "/path/to/downloaded/file.zip"  # Adjust the path
new_zip_path <- paste0(getwd(), "/downloaded_file.zip")
file.rename(downloaded_zip_path, new_zip_path)

# Close the browser
remDr$close()

# Unzip the file
unzip(new_zip_path, exdir = getwd())

# Extract CSV files
csv_files <- list.files(pattern = "\\.csv$")

# Combine CSV files into a single data frame
#combined_data <- bind_rows(lapply(csv_files, read.csv))

# Write the combined data to a new CSV file
#write.csv(combined_data, file = "combined_data.csv", row.names = FALSE)

