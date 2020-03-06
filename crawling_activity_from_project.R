library(dplyr)
library(xml2)

project.data <- "C:/Users/ywon7/Desktop/GitHub/leed/project.csv" %>% read.csv

project.id <- project.data$project_source_id %>% stringr::str_replace_all(pattern="\\D", replacement="")

project.URL <- paste0("http://www.gbig.org/activities/leed-",project.id)

data.list <- NULL

page.list <- NULL

for (i in 1:length(project.URL)){
  page.list[[i]] <- xml2::read_html(project.URL[i])
  
  data.list[[i]] <- page.list[[i]] %>% html_nodes(xpath = '//*[@id="intent"]//td') %>% html_text() %>% t %>% data.frame
  
  colnames(data.list[[i]]) <- page.list[[i]] %>% html_nodes(xpath = '//*[@id="intent"]//th') %>% html_text()
  
  data.list[[i]]$address <- page.list[[i]] %>% html_nodes(xpath = '//*[@id="intent"]//address/a') %>% html_text()
  
  data.list[[i]]$building.URL <- page.list[[i]] %>% html_nodes(xpath = '//*[@id="intent"]//address/a') %>% html_attr(name = "href")
  
  cat("1..")
}

write.csv(bind_rows(data.list), file="C:/Users/ywon7/Desktop/activity.csv") 
