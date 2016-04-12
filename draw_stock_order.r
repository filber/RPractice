library(ggplot2)
library(RCurl)
library(mongolite)
library(grid)

sina_detail_trans<-function(symbol,date_vector){
  trans_frame<-data.frame()
  for(j in seq(from=1,to=length(date_vector))){
    url<-paste("http://market.finance.sina.com.cn/downxls.php?date=",date_vector[j],"&symbol=",symbol,sep = "");
    response<-getURL(url = url,.encoding = "GBK")
    response_vector<-strsplit(response,split = "\n")[[1]][-1]
    trans_day_frame<-data.frame()
    for(i in seq(from=1,to=length(response_vector))){
      item<-strsplit(response_vector[i],split="\t")[[1]]
      trans_time<-as.POSIXct(item[1],format="%H:%M:%S")
      trans_price<-as.numeric(item[2])
      trans_change<-item[3]
      trans_count<-as.numeric(item[4])
      trans_amount<-as.numeric(item[5])
      trans_flag<-item[6]
      trans_day_frame<-rbind(data.frame(date=date_vector[j],time=trans_time,price=trans_price,change=trans_change,count=trans_count,amount=trans_amount,flag=trans_flag),trans_day_frame)
    }
    trans_frame<-rbind(trans_frame,trans_day_frame)
  }
  trans_frame
}

sina_detail_order<-function(symbol,date_vector){
  con <- mongo(collection = "stock",url = 'mongodb://localhost:27017/stock')
  
  db_record<-con$aggregate(pipeline=paste('[
    {"$match":{"code":"',symbol,'",
                               "data_date":{"$in":["',date_vector,'"]},
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
                                    {"flag":{"$literal":"S"},"i" : {"$literal" : 5},"count" : "$sell_order_count_5","price" : "$sell_order_price_5"}]
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
  db_record
}

#symbol<-'sh600622'
symbol<-commandArgs(trailingOnly = TRUE)[1]
stock_name<-commandArgs(trailingOnly = TRUE)[2]
date_vector<-c(commandArgs(trailingOnly = TRUE)[3])
trans<-sina_detail_trans(symbol,date_vector)
order<-sina_detail_order(symbol,date_vector)

stock_title<-paste(stock_name,"[",symbol,"]",date_vector,sep="")
p1<-ggplot(trans,aes(x = time,y = price,group=1)) +
  geom_point(aes(size=count,shape=flag,color=flag)) +
  ylim(min(order$price),max(order$price)) +
  xlim(min(order$time),max(order$time)) +
  scale_colour_manual(values=c("red","blue","grey")) +
  ggtitle(stock_title)

p2<-ggplot(order,aes(x = time,y = price)) +
  geom_point(aes(size=count,shape=flag,color=flag)) +
  geom_text(aes(y=current_price),label="-",colour="black") +
  ylim(min(order$price),max(order$price)) +
  scale_colour_manual(values=c(B="red",S="blue")) +
  xlim(min(order$time),max(order$time))

png(file = paste(stock_title,".png",sep=""),width=800,height=600)
grid.newpage()
pushViewport(viewport(layout = grid.layout(2,1)))
print(p1,vp=viewport(layout.pos.row = 1,layout.pos.col = 1))
print(p2,vp=viewport(layout.pos.row = 2,layout.pos.col = 1))
dev.off()