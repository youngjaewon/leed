
activity <- read.csv("C:/Users/ywon7/Desktop/GitHub/leed/data/activity_w_program.csv")
activity$X <- NULL

building <- read.csv("C:/Users/ywon7/Desktop/GitHub/leed/data/building.csv")
building$X <- NULL

activity_building <- cbind(activity, building)
write.csv(activity_building, file="C:/Users/ywon7/Desktop/GitHub/leed/data/activity_building.csv")

activity_building$building.URL %>% unique -> unique_URL

activity_building %>% distinct(unique_URL) -> df

df <- activity_building[!duplicated(activity_building[,c('building.URL')]),]

write.csv(df, file="C:/Users/ywon7/Desktop/GitHub/leed/data/activity_building_unique.csv")
