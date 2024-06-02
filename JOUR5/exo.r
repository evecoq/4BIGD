library(dplyr)
library(tidyverse)
library(readr)
library(psych)

# Import dataset
df <- read_tsv('name_basics.tsv')

# 1. Data Exploration:
# Explore the dataset by examining its structure, dimensions, and summary statistics.
dim(df)
colnames(df)
head(df)
tail(df)
describe(df)

# Identify the variables/columns present in the dataset and their data types.
summary(df)

# Perform basic data quality checks to identify missing values or inconsistencies.
colSums(is.na(df)) #La sortie de cette commnade indique qu'il y a pas de valeur manquantes, pourtant 
sum(duplicated(df))
str(df)

# Handle missing values appropriately by either imputing them or removing rows/columns.
# Remove rows with NA values in the 'primaryName' column (48 rows)
df <- df[!is.na(df$primaryName), ]

# Convert data types of variables if necessary (e.g., date columns) 
# Convert birthYear and deathYear to integers
df$birthYear <- as.integer(df$birthYear)
df$deathYear <- as.integer(df$deathYear)

# Standardize or clean data as required (e.g., removing leading/trailing spaces, formatting).
# Split the Departments column into separate columns

# counting the occurrences of comma in primaryProfession column
count_p <- str_count(df$primaryProfession, ",")
max_comma_p <- max(count_p)
print (max_comma_p)

# counting the occurrences of comma in knownForTitles column
count_t <- str_count(df$knownForTitles, ",")
max_comma_t <- max(count_t)
print (max_comma_t)

#Separate profession and titles columns
df <- df %>%
  separate(primaryProfession, into = paste0("Profession", 1:3), sep = ",", fill = "right")
df <- df %>%
  separate(knownForTitles, into = paste0("knownForTitles", 1:4), sep = ",", fill = "right")

#Removing leading/trailing spaces from all character columns in the data frame
df <- df %>% mutate(across(where(is.character), trimws))

#Export dataset as csv
write.csv(df, "imdb_dataset.csv", row.names=FALSE)