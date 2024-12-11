lapply(paste('package:',names(sessionInfo()$otherPkgs),sep=""),detach,character.only=TRUE,unload=TRUE)
library(tidyverse)
library(patchwork)

#set directory
setwd("/Users/natal/Documents/Purdue/Data_science_biol/Final_project")

# load data and view
species <- read_csv("species_index_table.csv")
glimpse(species)
pairs <- read_csv("pair_index_table.csv")
glimpse(pairs)
divergence <- read_csv("divergence_table.csv")
glimpse(divergence)

# calculate interquartile range (iqr) and define outliers
##doing this due to a few strange values that I will need to look into later 
Q1 <- quantile(divergence$k2p, 0.05, na.rm = TRUE)
Q3 <- quantile(divergence$k2p, 0.95, na.rm = TRUE)
IQR <- Q3 - Q1

# define lower and upper bounds for non-outliers
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR

# filter out extreme outliers in k2p divergence
filtered_divergence <- divergence %>%
  filter(k2p >= lower_bound & k2p <= upper_bound)
str(filtered_divergence)

# merge the species and pairs datasets
pairs_traits <- pairs %>%
  left_join(species, by = c("species_index1" = "Species_index")) %>%
  rename(Species1 = Species, Type1 = Type, Class1 = Class,
         Genome_size1 = Genome_size, Body_size_kg1 = Body_size_kg, Generation_time_yrs1 = Generation_time_yrs) %>%
  left_join(species, by = c("species_index2" = "Species_index")) %>%
  rename(Species2 = Species, Type2 = Type, Class2 = Class,
         Genome_size2 = Genome_size, Body_size_kg2 = Body_size_kg, Generation_time_yrs2 = Generation_time_yrs) %>%
  left_join(filtered_divergence, by = "pair") %>%
  select(pair, Class1, Class2, raw, k2p, k3p, jc,
         Genome_size1, Genome_size2, Body_size_kg1, Body_size_kg2, Generation_time_yrs1, Generation_time_yrs2)

# calculate averaged trait values, handling missing data by using data from the other species in the pair
## did this due to a few species I could not find all data for
pairs_traits <- pairs_traits %>%
  mutate(
    Genome_size_avg = case_when(
      !is.na(Genome_size1) & !is.na(Genome_size2) ~ (Genome_size1 + Genome_size2) / 2,
      !is.na(Genome_size1) ~ Genome_size1,
      !is.na(Genome_size2) ~ Genome_size2,
      TRUE ~ NA_real_
    ),
    Body_size_kg_avg = case_when(
      !is.na(Body_size_kg1) & !is.na(Body_size_kg2) ~ (Body_size_kg1 + Body_size_kg2) / 2,
      !is.na(Body_size_kg1) ~ Body_size_kg1,
      !is.na(Body_size_kg2) ~ Body_size_kg2,
      TRUE ~ NA_real_
    ),
    Generation_time_yrs_avg = case_when(
      !is.na(Generation_time_yrs1) & !is.na(Generation_time_yrs2) ~ (Generation_time_yrs1 + Generation_time_yrs2) / 2,
      !is.na(Generation_time_yrs1) ~ Generation_time_yrs1,
      !is.na(Generation_time_yrs2) ~ Generation_time_yrs2,
      TRUE ~ NA_real_
    )
  )

# remove pairs with missing trait values for any trait
## this shouldn't occur in the current dataset, but want the code to be transferrable to future datasets
pairs_traits_clean <- pairs_traits %>%
  drop_na(Genome_size_avg, Body_size_kg_avg, Generation_time_yrs_avg)

# subset data to exclude "Reptilia"
## did this for this dataset due to very low reptilia sample size
pairs_traits_clean <- pairs_traits_clean[pairs_traits_clean$Class1 != "Reptilia", ]

#### ANOVAs

# pivot long for analysis
divergence_long <- pairs_traits_clean %>%
  select(pair, raw, jc, k2p, k3p) %>%
  pivot_longer(cols = c(raw, jc, k2p, k3p), 
               names_to = "metric", 
               values_to = "divergence")

# divergence model ANOVA
anova_results <- aov(divergence ~ metric + Error(pair / metric), data = divergence_long)
summary(anova_results)

# post-hoc test (Tukey HSD) for pairwise comparisons
pairwise_results <- TukeyHSD(aov(divergence ~ metric, data = divergence_long))
pairwise_results

# divergence models box plot
ggplot(divergence_long, aes(x = metric, y = divergence, fill = metric)) +
  geom_boxplot(outlier.shape = NA) + # avoid plotting outliers for clarity
  geom_jitter(width = 0.2, alpha = 0.5) + # add jittered points for individual data
  scale_fill_viridis_d(option = "C") + # Viridis color palette for discrete data
  labs(title = "Comparison of Divergence Metrics",
       x = "Divergence Metric",
       y = "Divergence Value") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")

# ANOVA for divergence between classes
anova_class <- aov(k2p ~ Class1, data = pairs_traits_clean)
summary(anova_class)

# post-hoc test (Tukey HSD) for pairwise comparisons between classes
posthoc_class <- TukeyHSD(anova_class)
posthoc_class

# boxplot of divergence (k2p) by Class with transparent jitter points
ggplot(pairs_traits_clean, aes(x = Class1, y = k2p, fill = Class1)) +
  geom_boxplot(outlier.shape = NA) + # Removes outliers from boxplot to avoid overlap with jitter points
  geom_jitter(alpha = 0.4, color = "black", width = 0.2) + # Transparent jitter points
  labs(x = "Class", y = "Divergence (k2p)", title = "Divergence by Class") +
  theme_minimal() +
  theme(text = element_text(size = 15)) +
  scale_fill_viridis_d(option = "D") # Viridis palette for discrete data

#### linear regressions 

# split data by Class1
class_data <- split(pairs_traits_clean, pairs_traits_clean$Class1)

# fit separate linear models with log-transformed variables and view residuals
models_with_residuals <- lapply(names(class_data), function(class_name) {
  # get data for the current class
  data <- class_data[[class_name]]
  
  # log-transform variables, ensuring no negative or zero values
  data <- data %>%
    mutate(
      log_k2p = log(k2p),
      log_Genome_size_avg = log(Genome_size_avg),
      log_Body_size_kg_avg = log(Body_size_kg_avg),
      log_Generation_time_yrs_avg = log(Generation_time_yrs_avg)
    )
  
  # fit the linear model with log-transformed variables
  model <- lm(log_k2p ~ log_Genome_size_avg + log_Body_size_kg_avg + log_Generation_time_yrs_avg, data = data)
  
  # extract residuals for diagnostics
  residuals <- resid(model)
  fitted_values <- fitted(model)
  
  # create a residual plot
  residual_plot <- ggplot(data, aes(x = fitted_values, y = residuals)) +
    geom_point() +
    geom_hline(yintercept = 0, linetype = "dashed") +
    labs(
      title = paste("Residuals for Class:", class_name),
      x = "Fitted Values",
      y = "Residuals"
    ) +
    theme_minimal()
  
  list(
    class_name = class_name,
    model = model,
    summary = summary(model),
    residual_plot = residual_plot
  )
})


model_summaries <- lapply(models_with_residuals, function(x) x$summary)
residual_plots <- lapply(models_with_residuals, function(x) x$residual_plot)

names(model_summaries) <- names(class_data) 
model_summaries

# view residual plots for each class
# use print(residual_plots[[1]]) or plot them in a loop
for (i in seq_along(residual_plots)) {
  print(residual_plots[[i]])
}


### final plots
# genome size vs divergence
plot1 <- ggplot(pairs_traits_clean, aes(x = Genome_size_avg, y = k2p, color = Class1)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Average Genome Size", y = "Divergence (k2p)", title = "Genome Size vs Divergence") +
  theme_minimal() +
  theme(text = element_text(size = 15)) +
  scale_color_viridis_d(option = "D") 

# body size vs divergence
plot2 <- ggplot(pairs_traits_clean, aes(x = Body_size_kg_avg, y = k2p, color = Class1)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Average Body Size (kg)", y = "Divergence (k2p)", title = "Body Size vs Divergence") +
  theme_minimal() +
  theme(text = element_text(size = 15)) +
  scale_color_viridis_d(option = "C") 

# generation time vs divergence
plot3 <- ggplot(pairs_traits_clean, aes(x = Generation_time_yrs_avg, y = k2p, color = Class1)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Average Generation Time (yrs)", y = "Divergence (k2p)", title = "Generation Time vs Divergence") +
  theme_minimal() +
  theme(text = element_text(size = 15)) +
  scale_color_viridis_d(option = "C") 

# combine plots
combined_plot <- plot1 / plot2 / plot3
combined_plot
