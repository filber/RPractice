
db_record_temp<-con$aggregate(pipeline=paste('[
{"$match":{
          "code":"',dbSymbol,'",
          "data_date":{"$gte":',as.character.Date(lastTimestamp,format='%Y%m%d'),'},
          "data_time":{"$gt":',as.integer(as.character.Date(lastTimestamp,format='%H%M%S')),'}
}},
{"$project":{
                                        "_id" : 0,
                                        "date":"$data_date",
                                        "time":"$data_time",
                                        "Price":"$current_price",
                                        "Volume":"$last_vol"
}}]',sep=""))

db_record_temp$time<-as.POSIXct(sprintf("%d%06d",db_record_temp$date,db_record_temp$time),format="%Y%m%d%H%M%S")
db_record_temp$date<-NULL

if(!exists('db_record')){
  db_record <- db_record_temp
} else if(nrow(db_record_temp)!=0){
  db_record <- rbind(db_record,db_record_temp)
}
lastTimestamp<-tail(db_record,n = 1)$time

Data<-as.xts(x = db_record[-1],order.by = db_record$time)
Data<-to.minutes(x = Data,k = 1)

#模拟交易的起始时间约束为Data的倒数第二条记录的时间戳
PARAM$SIM.TIMESTAMP <- index(tail(Data,n=2)[1])


