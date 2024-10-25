# load packages
library(tidyverse)

#set directory
setwd("/Users/natal/Documents/Purdue/Data_science_biol/Final_project")

# load data and view
species <- read_csv("species_index_table.csv")
glimpse(species)
pairs <- read_csv("pair_index_table.csv")
glimpse(pairs)
divergence <- read_csv("divergence_table.csv")
glimpse(divergence)

# merge to include class information with species pairs
pairs_species <- pairs %>%
  left_join(species, by = c("species_index1" = "Species_index")) %>%
  rename(Class1 = Class) %>%
  left_join(species, by = c("species_index2" = "Species_index")) %>%
  rename(Class2 = Class)

# average divergence for each nucleotide model
divergence_summary <- divergence %>%
  summarise(
    avg_raw = mean(raw, na.rm = TRUE),
    avg_k2p = mean(k2p, na.rm = TRUE),
    avg_k3p = mean(k3p, na.rm = TRUE),
    avg_jc = mean(jc, na.rm = TRUE)
  )
print(divergence_summary)

# merge species pairs wih divergence and calculate average k2p distance
divergence_class <- pairs_species %>%
  select(pair, Class1) %>%
  left_join(divergence, by = "pair") %>%
  group_by(Class1) %>%
  summarise(avg_k2p = mean(k2p, na.rm = TRUE)) %>%
  arrange(desc(avg_k2p))
print(divergence_class)

# use pivot longer to get divergence all in one column
divergence_long <- divergence %>%
  pivot_longer(cols = c(raw, k2p, k3p, jc), names_to = "model", values_to = "divergence_value")
glimpse(divergence_long)

# box plot of average divergence for each model
model <- ggplot(divergence_long, aes(x = model, y = divergence_value, fill = model)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.6) +  
  geom_jitter(width = 0.2, height = 0, alpha = 0.3, color = "black") +  
  labs(title = "Divergence across Models", x = "Model", y = "Divergence") +
  theme_minimal()

# box plots of average k2p divergence by Class
class <- ggplot(divergence_class, aes(x = reorder(Class1, -avg_k2p), y = avg_k2p)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Average k2p Divergence by Class", x = "Class", y = "Average k2p Divergence") +
  theme_minimal()

# plot side by side
model | class
