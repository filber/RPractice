lapply(list('ggplot2','dplyr','foreign','knitr','sp','plyr','maptools','gpclib','rgeos'),require,character.only=TRUE)

ChinaPolygonsLevel1<-readShapePoly("CHN/CHN_adm1.shp")

ChinaPolygonsLevel1@data$NL_NAME_1 <- gsub("^.*\\|", "", ChinaPolygonsLevel1@data$NL_NAME_1)
ChinaPolygonsLevel1@data[grep("黑龍江省", ChinaPolygonsLevel1@data$NL_NAME_1),]$NL_NAME_1 <- "黑龙江"
ChinaPolygonsLevel1@data[grep("新疆维吾尔自治区", ChinaPolygonsLevel1@data$NL_NAME_1),]$NL_NAME_1 <- "新疆"
ChinaPolygonsLevel1@data[grep("内蒙古自治区", ChinaPolygonsLevel1@data$NL_NAME_1),]$NL_NAME_1 <- "内蒙古"
ChinaPolygonsLevel1@data[grep("宁夏回族自治区", ChinaPolygonsLevel1@data$NL_NAME_1),]$NL_NAME_1 <- "宁夏"
ChinaPolygonsLevel1@data[grep("广西壮族自治区", ChinaPolygonsLevel1@data$NL_NAME_1),]$NL_NAME_1 <- "广西"
ChinaPolygonsLevel1@data[grep("西藏自治区", ChinaPolygonsLevel1@data$NL_NAME_1),]$NL_NAME_1 <- "西藏"## English names
ChinaPolygonsLevel1@data$NAME_1 <- as.character(ChinaPolygonsLevel1@data$NAME_1)
ChinaPolygonsLevel1@data[grep("Xinjiang Uygur", ChinaPolygonsLevel1@data$NAME_1),]$NAME_1 <- "Xinjiang"
ChinaPolygonsLevel1@data[grep("Nei Mongol", ChinaPolygonsLevel1@data$NAME_1),]$NAME_1 <- "Nei Menggu"
ChinaPolygonsLevel1@data[grep("Ningxia Hui", ChinaPolygonsLevel1@data$NAME_1),]$NAME_1 <- "Ningxia"
ChinaPolygonsLevel1@data$NAME_1 <- as.factor(ChinaPolygonsLevel1@data$NAME_1)



# Convert the spacial polygon shapes to data frame# Use level1 as index
ChinaLevel1Data <- ChinaPolygonsLevel1@data
ChinaLevel1Data$id <- ChinaLevel1Data$NAME_1# Fortify the data (polygon map as dataframe)
ChinaLevel1dF <- fortify(ChinaPolygonsLevel1, region = "NAME_1")



## Now we can make a simple map
g <- ggplot()
g <- g + geom_map(data = ChinaLevel1Data, aes(map_id = id, fill = ENGTYPE_1, col = TYPE_1), map = ChinaLevel1dF)
g <- g + expand_limits(x = ChinaLevel1dF$long, y =  ChinaLevel1dF$lat)
g <- g + coord_equal()
g <- g + labs(x="Longitude", y="Latitude", title="Map of China level 1 subdivisions per type (using ggplot)")
g <- g + theme_bw()
print(g)



## Merge polygons and associated data in one data frame by id (name of the province in chinese)
ChinaLevel1 <- merge(ChinaLevel1dF, ChinaLevel1Data, by = "id")

#此处对查询结果和省名进行合并.
result<-merge(x = result,y=provincePY,by.x = "area",by.y="PROVINCENO")
ChinaLevel1Data <- merge(ChinaLevel1Data, result, by = "id")

## Create the ggplot using standard approach
## group is necessary to draw in correct order, try without to understand the problem
g <- ggplot(ChinaLevel1, aes(x = long, y = lat, fill = totalCount,direction=-1,group = group))
## projected shadow
g <- g+ geom_polygon(aes(x = long + 0.7, y = lat - 0.5), color = "grey50", size = 0.2, fill = "grey50")
## Province boundaries
g <- g + geom_polygon(color = "white", size = 0.2)
## to keep correct ratio in the projection
g <- g + coord_equal()
g <- g + labs(title = "China - level 1 subdivisions")
print(g)




## Getting the center of each subdivision (to plot names or others)## ddply is from the plyr package

Level1Centers <-
  ddply(ChinaLevel1dF, .(id), summarize, clat = mean(lat), clong = mean(long))
## Merge results in one data frame
ChinaLevel1Data <- merge(ChinaLevel1Data, Level1Centers, all = TRUE)

## Add the province chinese names
h <- g + geom_text(data = ChinaLevel1Data , aes(
  x = jitter(clong, amount = 1), y = jitter(clat, amount = 1), label = NAME_1, size = 0.2, group = NULL, fill=NULL), show_guide = FALSE
) 

## Theme configuration
h <- h + theme_bw() + 
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        legend.position = c(0.9, 0.2),
        legend.text = element_text(size = rel(0.7)),
        legend.background = element_rect(color = "gray50", size = 0.3,
                                         fill = "white"))

## Change Palette
h <- h + scale_fill_brewer(palette="Pastel1", name="Type")
print(h)