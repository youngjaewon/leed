library(dplyr)
library(xml2)
library(rvest)
library(stringr)

df <- read.csv("C:/Users/ywon7/Desktop/GitHub/leed/data/final_before_cert.csv")

pilot.idx <- grep("Pilot",df$reg.std)

df$pilot <- grepl("Pilot",df$reg.std)

df$cert.date <- NA

pilot.URL <- df$building.URL[df$pilot] %>% as.character

for(input.URL in pilot.URL){
  page <- xml2::read_html(input.URL)
  index <- page %>% html_nodes(xpath = '//*[@class="media feed-event project"]//*[@class="event"]') %>% html_text() %>% grep(pattern="LEED") %>% max
  index <- index - 1
  cert.date <- page %>% html_nodes(xpath = '//*[@class="media feed-event project"]//*[@class="date"]') %>% html_text() %>% (function(x){x[index]})
  
  if(identical(cert.date, character(0))){
    df$cert.date[match(input.URL, df$building.URL)] <- NA
  }else{
    df$cert.date[match(input.URL, df$building.URL)] <- cert.date
  }
}

which(is.na(df$cert.date) & df$pilot)

df$reg.std <- df$reg.std %>% as.character

df <- df[-c(977,1468,2314),]

write.csv(df, "C:/Users/ywon7/Desktop/GitHub/leed/data/final.csv")
