library(dplyr)
library(xml2)
library(rvest)

activity <- "C:/Users/ywon7/Desktop/GitHub/leed/data/activity.csv" %>% read.csv

building.URL <- activity$building.URL %>% as.character %>% paste0("/details")

page.list <- NULL

data.list <- NULL

date.list <- NULL

std.list <- NULL

for (i in 1:length(building.URL)){
  page.list[[i]] <- tryCatch(
    xml2::read_html(building.URL[i]),
    error = function(e){ "error" }
  )
  
  if( page.list[[i]][1] != "error" ){
    date.vector <- page.list[[i]] %>% html_nodes(xpath = '//*[@class="media feed-event project"]//*[@class="date"]') %>% html_text
    reg.date <- date.vector[length(date.vector)] #registered date
    
    std.vector <- page.list[[i]] %>% html_nodes(xpath = '//*[@class="media feed-event project"]//*[@class="event"]') %>% html_text
    reg.std <- std.vector[length(std.vector)] #registered standard
    
    owner.type <- page.list[[i]] %>% html_node(xpath = '//*[@class="buildings-aside-inner"]//tr/td[2]') %>% html_text
    
    data.list[[i]] <- data.frame(building.URL=building.URL[i], reg.date=reg.date, reg.std=reg.std, owner.type=owner.type)
    
    cat("1..")
  } else{
    data.list[[i]] <- data.frame(building.URL=NA, reg.date=NA, reg.std=NA, owner.type=NA)
  }
  
  if(i %% 100 == 0){
    print(i)
  }
  
  if(i %% 1000 == 0){
    write.csv( bind_rows(data.list), paste0("C:/Users/ywon7/Desktop/GitHub/leed/building_",i,".csv") )
  }
}

View( bind_rows(data.list) )
