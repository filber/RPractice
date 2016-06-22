require(mongolite)
require(xts)
require(quantmod)

con <- mongo(collection = "stock",url = 'mongodb://114.215.151.231:27017/stock')
dbSymbol<-'601211.SH'
startDate<-20160616
endDate<-20160620
db_record<-con$aggregate(pipeline=paste('[
          {"$match":{"code":"',dbSymbol,'",
           "data_date":{"$gte":',startDate,',"$lte":',endDate,'}}},
          {"$project":{
                "_id" : 0,
                "date":"$data_date",
                "time":"$data_time",
                "price":"$current_price",
                "volume":"$last_vol"
          }}]',sep=''))

db_record$time<-as.POSIXct(sprintf("%d%06d",db_record$date,db_record$time),format="%Y%m%d%H%M%S")

stockXts<-xts(x = db_record[,c(-1,-2)],order.by = db_record[,2])

stockMinutes<-to.minutes(x = stockXts,k = 5)
chart_Series(x = stockMinutes,name = "国泰君安",TA="add_SMA(n=5,col=4);add_Vo()")
