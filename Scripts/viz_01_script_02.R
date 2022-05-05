
# Header ------------------------------------------------------------------
# Avery Sholes 
# 22S Dali Data Challenge
# Viz 1 Scipt 2


# Load Packages -----------------------------------------------------------


library(usmap)
library(ggplot2)
library(tidyverse)
library(ggiraph)
library(plotly)
library(processx)


# Load Data ---------------------------------------------------------------


viz1df <- read_csv("../data/exported_viz1df.csv")
usa <- map_data('usa')
state <- map_data("state")

temp <- viz1df %>%
  distinct(State, .keep_all = TRUE) %>%
  mutate(State = tolower(State))

# merge with state borders
state_merged <- merge(state, temp, by.x = "region", by.y = "State")


# Make plot ---------------------------------------------------------------


g2 <- ggplot() + 
  geom_polygon(data=state_merged,
    aes(x=long, y=lat, fill=tech_pct, group=group),
    color = "white") +
  scale_fill_gradient(low = "black", high = "red") +
  guides() +
  labs(fill = "State % of sales\n that are Tech-related",
       title = "Percentage of Tech Purchases from the Superstore by State",
       subtitle = "Hover over states to see percentage") +
  theme_bw() +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())
  
# make interactive
p <- ggplotly(g2, dynamicTicks = TRUE)

p
