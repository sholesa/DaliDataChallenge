# Header ------------------------------------------------------------------
# Avery Sholes 
# 22S Dali Data Challenge
# Viz 3 Scipt 1

# Load Packages -----------------------------------------------------------


library(usmap)
library(ggplot2)
library(tidyverse)

# Load data ---------------------------------------------------------------

df <- read_csv("../data/Sample - Superstore.csv")

df2 <- df %>%
  group_by(Segment, `Sub-Category`) %>% 
  summarise(
    sales = sum(Sales)
  )

ggplot(df2, aes(`Sub-Category`, sales)) +
  geom_col(aes(fill = Segment)) +
  scale_fill_manual(values = c("red", "darkblue", "darkgreen")) +
  theme_light() +
  labs(y = "Sales (in thousands of dollars)",
       title = "Sales per Purchase Sub-Category, Grouped by Use") +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    ) +
  scale_y_continuous(labels = c(0, "100", "200", "300"))

ggsave("../Figures/fig_03.png")


