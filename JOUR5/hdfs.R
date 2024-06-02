install.packages("rhdfs")
library(rhdfs)

# Connect to the HDFS file system
hdfs.init()

# Destination path on HDFS
destination_path <- "/user/hadoop/imdb_dataset"

# Check if the directory already exists on HDFS
if (!hdfs.exists(destination_path)) {
  # Create the directory if it doesn't exist
  hdfs.mkdir(destination_path, recursive = TRUE)
  cat("Directory created successfully on HDFS.\n")
}

# Copy the CSV file to HDFS
hdfs.put("imdb_dataset.csv", paste0(destination_path, "imdb_dataset.csv"))