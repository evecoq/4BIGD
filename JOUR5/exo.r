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
