# Installe le package SparkR si ce n'est pas déjà fait et charger la bibliothèque
if (!require("SparkR")) {
  if (!requireNamespace("sparklyr", quietly = TRUE)) {
    install.packages("SparkR")
  } else {
    message("The 'SparkR' package is not available. Please install it manually.")
  }
}

# Charge la bibliothèque SparkR
library(SparkR)

# Essaye de se connecter au système de fichiers HDFS
tryCatch({
  hdfs.init()
}, error = function(e) {
  cat("Error connecting to HDFS file system:", e$message, "\n")
  # Arrête l'exécution du script en cas d'erreur
  stop(e)
})

# Chemin de destination sur HDFS
destination_path <- "/user/hadoop/imdb_dataset"

# Vérifie si le répertoire existe déjà sur HDFS
if (!hdfs.exists(destination_path)) {
  # Créer le répertoire s'il n'existe pas encore
  tryCatch({
    hdfs.mkdir(destination_path, recursive = TRUE)
    cat("Directory created successfully on HDFS.\n")
  }, error = function(e) {
    cat("Error creating directory on HDFS:", e$message, "\n")
    # Arrête l'exécution du script en cas d'erreur
    stop(e)
  })
}

# Copie le fichier CSV vers HDFS
tryCatch({
  hdfs.put("imdb_dataset.csv", paste0(destination_path, "/imdb_dataset.csv"))
}, error = function(e) {
  cat("Error copying CSV file to HDFS:", e$message, "\n")
  # Arrête l'exécution du script en cas d'erreur
  stop(e)
})