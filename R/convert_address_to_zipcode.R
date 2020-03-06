df <- read.csv("C:/Users/ywon7/Desktop/GitHub/leed/data/activity_building_unique.csv")

address <- sapply(df$address %>% as.character, function(x){ return( unlist(strsplit(x, split = ", "))[1] ) }) %>% as.character

city <- sapply(df$address %>% as.character
                      , function(x){
                          x1 <- unlist(strsplit(x, split = ", "))
                          return(x1[length(x1)-2])
                        }
                      ) %>% as.character

address.URL <- paste0('https://m.usps.com/m/QuickZipAction?mode=0&tAddress='
                      , address
                      , '&tCity='
                      , city
                      ,'&sState=CA&jsonInd=Y')

page.list <- NULL

for(i in length(address)){
  page.list <- xml2::read_html(address.URL[i])
}


###############

install.packages("rjson")
library(rjson)

read_html("https://m.usps.com/m/QuickZipAction?mode=0&tAddress=1314%202nd%20St&tCity=Santa%20Monica&sState=CA&jsonInd=Y") %>% html_text %>% fromJSON


x <- df$address %>% as.character %>% head
x <- x[1]
unlist(strsplit(x, split = ", "))[c(-2)]

query <- list(address = "1314 2ND ST",
              city = "SANTA MONICA",
              state = "CA")

resp <- httr::GET("https://m.usps.com/m/QuickZipAction", query=query)


