require(mongolite)
require(xts)
require(quantmod)

con <- mongo(collection = "stock",url = 'mongodb://114.215.151.231:27017/stock')
dbSymbol<-'601211.SH'
startDate<-20160606
endDate<-20160627
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
chartSeries(x = stockMinutes,name = "国泰君安",theme = chartTheme("white"),TA = 'addSMA(n=5);addSMA(n=10);addVo()')
addTA(ta = ROC(x = Cl(stockMinutes),n = 6),col='red')
addTA(ta = SMA(x = Cl(ROC(x = stockMinutes,n = 6)),n = 4),on=3)

GTJA<-stockMinutes
