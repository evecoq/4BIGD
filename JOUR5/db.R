# Install and load necessary packages
install.packages("DBI")
install.packages("RSQLite")
install.packages("readr")

library(DBI)
library(RSQLite)
library(readr)

# Read the CSV file
df <- read_csv("imdb_dataset.csv")

# Connect to SQLite and create the table
con <- dbConnect(RSQLite::SQLite(), "imdb_database.db")

# Create an IMDb table
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

# Use dbWriteTable to insert the data
dbWriteTable(con, "IMDb", df, row.names = FALSE, append = TRUE)

# Check if the data has been inserted
result <- dbGetQuery(con, "SELECT * FROM IMDb LIMIT 5")
print(result)

# Close the connection
dbDisconnect(con)