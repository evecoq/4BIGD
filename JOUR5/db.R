# Install necessary packages, suppress warnings and messages
suppressWarnings(suppressMessages({
  if (!require("DBI")) install.packages("DBI")
  if (!require("RSQLite")) install.packages("RSQLite")
  if (!require("readr")) install.packages("readr")
}))

# Load necessary packages
library(DBI)
library(RSQLite)
library(readr)

# Read the CSV file
tryCatch({
  df <- read_csv("imdb_dataset.csv")
}, error = function(e) {
  cat("Error reading CSV file:", e$message, "\n")
  # Stop the execution if an error occurs
  stop(e)
})

# Connect to SQLite and create the table
tryCatch({
  con <- dbConnect(RSQLite::SQLite(), "imdb_database.db")
}, error = function(e) {
  cat("Error connecting to SQLite:", e$message, "\n")
  # Stop the execution if an error occurs
  stop(e)
})

# Create an IMDb table
tryCatch({
  dbExecute(con, "
    CREATE TABLE IF NOT EXISTS IMDb (
      nconst TEXT,
      primaryName TEXT,
      birthYear INTEGER,
      deathYear INTEGER,
      Profession1 TEXT,
      Profession2 TEXT,
      Profession3 TEXT,
      knownForTitles1 TEXT,
      knownForTitles2 TEXT,
      knownForTitles3 TEXT,
      knownForTitles4 TEXT
    )
  ")
}, error = function(e) {
  cat("Error creating table in SQLite:", e$message, "\n")
  # Close the connection and stop the execution if an error occurs
  dbDisconnect(con)
  stop(e)
})

# Use dbWriteTable to insert the data
tryCatch({
  dbWriteTable(con, "IMDb", df, row.names = FALSE, append = TRUE)
}, error = function(e) {
  cat("Error writing data to SQLite:", e$message, "\n")
  # Close the connection and stop the execution if an error occurs
  dbDisconnect(con)
  stop(e)
})

# Check if the data has been inserted
tryCatch({
  result <- dbGetQuery(con, "SELECT * FROM IMDb LIMIT 5")
  print(result)
}, error = function(e) {
  cat("Error querying data from SQLite:", e$message, "\n")
}, finally = {
  # Close the connection in the finally block to ensure it's always closed
  dbDisconnect(con)
})