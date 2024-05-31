library(dplyr)
library(readr)
library(ggplot2)
library(hrbrthemes)
library(treemap)

# Import dataset
df_v <- read_csv('imdb_dataset.csv')

# Count the frequency of each profession
prof_frequency <- table(df_v$Profession1)
prof_frequency <- as.data.frame(prof_frequency)

# Barplot for the frequency of each profession
ggplot(prof_frequency, aes(x = reorder(Var1, Freq), y = Freq)) + 
  geom_bar(stat = "identity") +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Profession frequency", x = "Profession", y = "Frequency") + 
  coord_flip()

# Count the frequency of each movie
t_frequency <- table(df_v$knownForTitles1)
t_frequency <- as.data.frame(t_frequency)

# Category column for tghe frequency count
t_frequency <- t_frequency %>% mutate(category = case_when(
    Freq > 10000  ~ ">10k",
    Freq <= 10000 & Freq >= 8000  ~ "8k-10k",
    Freq <= 8000 & Freq >= 6000  ~ "6k-8k",
    Freq <= 6000 & Freq >= 4000  ~ "4k-6k",
    Freq <= 4000 & Freq >= 2000  ~ "2k-4k",
    Freq <= 2000 & Freq >= 500  ~ "500-2k",
    Freq <= 500 & Freq >= 50  ~ "50-500",
    Freq < 50 ~ "<50",
    TRUE ~ "Other"
  ))

# Plot movie frequency
pdf("treemap.pdf", width = 12, height = 8)
treemap(t_frequency,
        index="category",
        vSize="Freq",
        type="index",
        title = "Movie frequency",
        fontsize.title = 20,
        fontsize.labels = 14,
        fontsize.legend = 12,
        border.col = "white", # Color of the borders
        palette = "Set3", # Color palette for the groups
        fontcolor.labels = "black", # Font color for the labels
        align.labels = list(c("center", "center"), c("left", "top")), # Label alignment
        title.legend = "Groups and Subgroups" # Title for the legend
)
dev.off()

          # Count number of presence of each movie in dataset (nb of person that took part in)
agg_t_fr <- aggregate(t_frequency$Freq, by=list(t_frequency$category), FUN=length)
