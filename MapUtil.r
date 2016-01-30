library(maps)
library(mapdata)
library(mapproj)
china<-map(database = "china",plot = TRUE,interior = TRUE)
ggplot(china,aes(x=long,y=lat,group=group)) +
  geom_path() +coord_map("mercator")