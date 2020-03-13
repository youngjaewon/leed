library(dplyr)
library(xml2)
library(rvest)
library(stringr)

df <- read.csv("C:/Users/ywon7/Desktop/GitHub/leed/data/activity_building_unique_geocoded_cleaned.csv")
df <- df[!is.na(df$building.URL),]

df$reg.std <- as.character(df$reg.std)
df$reg.date <- as.character(df$reg.date)

target.idx <- grep("LEED",df$reg.std, invert=TRUE)

building.URL <- df$building.URL

df$new.reg.std <- NA
df$new.reg.date <- NA

for(i in target.idx){
  input.URL <- building.URL[i] %>% as.character
  page <- xml2::read_html(input.URL)
  index <- page %>% html_nodes(xpath = '//*[@class="media feed-event project"]//*[@class="event"]') %>% html_text() %>% grep(pattern="LEED") %>% max
  reg.std <- page %>% html_nodes(xpath = '//*[@class="media feed-event project"]//*[@class="event"]') %>% html_text() %>% (function(x){x[index]})
  reg.date <- page %>% html_nodes(xpath = '//*[@class="media feed-event project"]//*[@class="date"]') %>% html_text() %>% (function(x){x[index]})
  
  df$new.reg.std[i] <- reg.std
  df$new.reg.date[i] <- reg.date
  
  if(i %% 100 == 0){cat("100..")}
}

df$reg.std[!is.na(df$new.reg.std)] <- df$new.reg.std[!is.na(df$new.reg.std)]
df$reg.date[!is.na(df$new.reg.date)] <- df$new.reg.date[!is.na(df$new.reg.date)]

df$new.reg.date <- NULL
df$new.reg.std <- NULL

write.csv(df, file = "C:/Users/ywon7/Desktop/GitHub/leed/data/final_before_cert.csv")
