# Script for Git & RStudio Lecture
# ANLY 533 - November 16th, 2017

# libraries
library(tidyverse)
library(rvest)
library(stringr)

# Scrape some data about presidents from wikipedia
html <- read_html("https://en.wikipedia.org/wiki/List_of_Presidents_of_the_United_States")
presidents <- html_table(html_nodes(html, "table")[[2]], fill = T)

# clean up data frame
colnames(presidents) <- c("pres_number", "term_dates", "unknown", "name", "prior_office", "unknown2", "party", "term_years", "vice_president")

fix_rows <- rbind(presidents[44:45,], presidents[58:59,], presidents[69:70,])

fix_rows <- fix_rows[,-1] 

colnames(fix_rows) <- c("pres_number", "term_dates", "unknown", "name", "prior_office", "unknown2", "party", "term_years")
fix_rows$vice_president <- fix_rows$term_years

fix_rows2 <- presidents[29:30,] %>%
        select(-term_dates) %>%
        mutate(x = "Office Vacant")
colnames(fix_rows2) <- c("pres_number", "term_dates", "unknown", "name", "prior_office", "unknown2", "party", "term_years", "vice_president")


fix_rows <- rbind(fix_rows, fix_rows2)

presidents <- rbind(presidents, fix_rows)

# create final cleaned data frame
presidents <- presidents[-1,] %>%
        select(-unknown, -unknown2) %>%
        filter(!duplicated(term_dates)) %>%
        filter(name != "") %>%
        mutate(name = str_extract(name, ".+\\n"),
               pres_number = as.numeric(pres_number)) %>%
        select(pres_number, name, term_dates, prior_office) %>%
        arrange(pres_number)

write_csv(presidents, "president_data.csv")


# This is a new piece of code for class
1 + 1

washington <- presidents[1,]

write_csv(washington, "wash.csv")

100000000 + 438962

# one more thing...