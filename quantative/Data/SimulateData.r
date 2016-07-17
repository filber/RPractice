require(mongolite)
require(quantstrat)

dbSymbol<-"601211.SH"
today<-'20160708'

con <- mongo(collection = "stock",url = 'mongodb://114.215.151.231:27017/stock')
db_record<-con$aggregate(pipeline=paste('[
{"$match":{"code":"',dbSymbol,'",
                                        "data_date":{"$gte":',today,'}}},
{"$project":{
                                        "_id" : 0,
                                        "date":"$data_date",
                                        "time":"$data_time",
                                        "Price":"$current_price",
                                        "Volume":"$last_vol"
}}]',sep=""))

db_record$time<-as.POSIXct(sprintf("%d%06d",db_record$date,db_record$time),format="%Y%m%d%H%M%S")
db_record$date<-NULL
Data<-as.xts(x = db_record[-1],order.by = db_record$time)
Data<-to.minutes(x = Data,k = 1)

lastTimestamp<-tail(db_record,n = 1)$time
