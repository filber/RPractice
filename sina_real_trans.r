library(RCurl)
library(ggplot2)
library(mongolite)
library(grid)

symbol<-commandArgs(trailingOnly = TRUE)[1]
#symbol<-"sz000671"

today<-as.character.Date(Sys.Date())
url<-paste("http://vip.stock.finance.sina.com.cn/quotes_service/view/cn_bill_download.php?sort=ticktime&asc=1&volume=30000&amount=0&type=0&symbol=",symbol,"&day=",today,sep = "");

sina_real_trans<-read.csv(file = url,col.names=c("code","name","time","price","amount","pre_price","flag"),encoding="GBK")
sina_real_trans$time<-as.POSIXct(sina_real_trans$time,format="%H:%M:%S")
sina_real_trans$amount<-sina_real_trans$amount/100

con <- mongo(collection = "stock",url = 'mongodb://localhost:27017/stock')
db_record<-con$aggregate(pipeline=paste('[
                  {"$match":{"code":"',symbol,'",
                         "data_date":{"$in":["',today,'"]},
                         "data_time":{"$gt":"09:30","$lt":"15:00"}}},
                  {"$project":{
                                           "_id" : 0,
                                           "code":1,
                                           "current_price":"$current_price",
                                           "date":"$data_date",
                                           "time":"$data_time",
                                           "order" : [
                  {"flag":{"$literal":"B"},"i" : {"$literal" : 1},"count" : "$buy_order_count_1","price" : "$buy_order_price_1"},
                  {"flag":{"$literal":"B"},"i" : {"$literal" : 2},"count" : "$buy_order_count_2","price" : "$buy_order_price_2"},
                  {"flag":{"$literal":"B"},"i" : {"$literal" : 3},"count" : "$buy_order_count_3","price" : "$buy_order_price_3"},
                  {"flag":{"$literal":"B"},"i" : {"$literal" : 4},"count" : "$buy_order_count_4","price" : "$buy_order_price_4"},
                  {"flag":{"$literal":"B"},"i" : {"$literal" : 5},"count" : "$buy_order_count_5","price" : "$buy_order_price_5"},
                  {"flag":{"$literal":"S"},"i" : {"$literal" : 1},"count" : "$sell_order_count_1","price" : "$sell_order_price_1"},
                  {"flag":{"$literal":"S"},"i" : {"$literal" : 2},"count" : "$sell_order_count_2","price" : "$sell_order_price_2"},
                  {"flag":{"$literal":"S"},"i" : {"$literal" : 3},"count" : "$sell_order_count_3","price" : "$sell_order_price_3"},
                  {"flag":{"$literal":"S"},"i" : {"$literal" : 4},"count" : "$sell_order_count_4","price" : "$sell_order_price_4"},
                  {"flag":{"$literal":"S"},"i" : {"$literal" : 5},"count" : "$sell_order_count_5","price" : "$sell_order_price_5"}
                                           ]
                  }},
                  {"$unwind":"$order"},
                  {"$project":{
                                           "code":1,
                                           "date":1,
                                           "time":1,
                                           "current_price":"$current_price",
                                           "flag":"$order.flag",
                                           "position":"$order.i",
                                           "count":"$order.count",
                                           "price":"$order.price"
                  }},
                  {"$match":{"count":{"$gt":500},"price":{"$ne":0}}}
                         ]',sep=""))
db_record$time<-as.POSIXct(db_record$time,format="%H:%M:%S")

stock_title<-paste(head(sina_real_trans$name,n = 1),"[",symbol,"]",today,sep="")
p1<-ggplot(sina_real_trans,aes(x = time,y = price,group=1)) +
  geom_point(aes(size=amount,shape=flag,color=flag)) +
  ylim(min(db_record$price),max(db_record$price)) +
  xlim(min(db_record$time),max(db_record$time)) +
  ggtitle(stock_title)
p2<-ggplot(db_record,aes(x = time,y = price)) +
    geom_point(aes(size=count,shape=flag,color=flag)) +
    geom_text(aes(y=current_price),label="-",colour="red") +
  ylim(min(db_record$price),max(db_record$price)) +
  xlim(min(db_record$time),max(db_record$time))

png(file = paste(stock_title,".png",sep=""),width=800,height=600)
grid.newpage()
pushViewport(viewport(layout = grid.layout(2,1)))
print(p1,vp=viewport(layout.pos.row = 1,layout.pos.col = 1))
print(p2,vp=viewport(layout.pos.row = 2,layout.pos.col = 1))
dev.off()