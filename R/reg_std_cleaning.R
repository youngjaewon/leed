library(dplyr)
library(xml2)
library(rvest)
library(stringr)

input.URL <- "http://www.gbig.org/buildings/8596/details"
page <- xml2::read_html(input.URL)
index <- page %>% html_nodes(xpath = '//*[@class="media feed-event project"]//*[@class="event"]') %>% html_text() %>% grep(pattern="LEED") %>% max
reg.std <- page %>% html_nodes(xpath = '//*[@class="media feed-event project"]//*[@class="event"]') %>% html_text() %>% (function(x){x[index]})
reg.date <- page %>% html_nodes(xpath = '//*[@class="media feed-event project"]//*[@class="date"]') %>% html_text() %>% (function(x){x[index]})
