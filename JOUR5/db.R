# Installer et charger les packages nécessaires
install.packages("DBI")
install.packages("RSQLite")
install.packages("readr")

library(DBI)
library(RSQLite)
library(readr)

# Lire le fichier CSV
df <- read_csv("imdb_dataset.csv")

# Connexion à SQLite et création de la table
con <- dbConnect(RSQLite::SQLite(), "imdb_database.db")

# Créer une table IMDb
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

# Utiliser dbWriteTable pour insérer les données
dbWriteTable(con, "IMDb", df, row.names = FALSE, append = TRUE)

# Vérifier que les données ont été insérées
result <- dbGetQuery(con, "SELECT * FROM IMDb LIMIT 5")
print(result)

# Fermer la connexion
dbDisconnect(con)