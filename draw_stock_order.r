library(ggplot2)
library(mongolite)
con <- mongo(collection = "stock",url = 'mongodb://localhost:27017/stock')

#sh600516--方大碳素
#sh601000--唐山港
#sh600383--金地集团
#sh600755--厦门国贸
#sh600622--嘉宝集团
#sh601390--中国中铁
db_record<-con$aggregate(pipeline='[
                  {"$match":{"code":"sh600622",
                             "data_date":{"$in":["2016-03-29"]},
                             "data_time":{"$gt":"09:00","$lt":"15:00"}}},
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
                {"$match":{"count":{"$gt":0},"price":{"$ne":0}}}
                         ]')
db_record$time<-as.POSIXct(db_record$time,format="%H:%M:%S")
ggplot(db_record,aes(x = time,y = price)) +
  geom_point(aes(size=count,shape=flag,color=count)) +
  facet_grid(. ~ date) +
  geom_text(aes(y=current_price),label="-",colour="red") +
  scale_colour_gradient(high = "#132B43", low = "#56B1F7")
