library(tidyverse)
library(rvest)
library(XML)
library(RCurl)

atla_website <- "https://avatar.fandom.com/wiki/Avatar_Wiki:Transcripts"

atla_hrefs <- atla_website %>%
  read_html() %>%
  html_nodes(xpath = '//table[@style="width:100%;" and position()>1 and position()<5]//a') %>%
  html_attr('href') 
  

atla_links <- paste0("https://avatar.fandom.com", atla_hrefs, sep = "")
atla_links <- atla_links[!str_detect(atla_links, "_\\(commentary\\)$|Escape_from_the_Spirit_World$")]

atla_ep_titles <- atla_links %>%
  str_replace_all("https://avatar.fandom.com/wiki/Transcript:", "") %>%
  str_replace_all("_", " ") %>%
  str_replace_all("%27", "'")

atla <- data.frame(episode_link = atla_links,
           book = rep(c("Book 1 - Water", "Book 2 - Earth", "Book 3 - Fire"), c(20, 20, 21)), 
           episode_name = atla_ep_titles)

ep_characters <- "https://avatar.fandom.com/wiki/Transcript:The_Runaway" %>%
  read_html() %>%
  html_nodes(xpath = "//table[@class='wikitable']") %>%
  html_table() %>%
  pluck(1) %>% 
  simplify() %>% 
  enframe(value = "character") %>% 
  mutate(episode_title = "The Runaway") %>%
  select(-name)

ep_transcript <- "https://avatar.fandom.com/wiki/Transcript:The_Runaway" %>%
  read_html() %>%
  html_nodes(xpath = "//table[@class='wikitable']") %>%
  html_table() %>%
  pluck(2) %>% 
  simplify() %>% 
  enframe(value = "transcript") %>% 
  mutate(episode_title = "The Runaway") %>%
  select(-name)

