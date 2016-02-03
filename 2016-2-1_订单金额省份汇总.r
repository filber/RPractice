library(mongolite)
library(ggplot2)

start <- as.numeric(as.POSIXct(strptime("2016-02-01 12:00:00","%Y-%m-%d %H:%M:%S"))) * 1000
end <- as.numeric(as.POSIXct(strptime("2016-02-02 00:00:00","%Y-%m-%d %H:%M:%S"))) * 1000

#Connect To MongoDB
con <- mongo(collection = "mobile_collection",url = 'mongodb://sdkriskdbreadwrite:Re&wR%40u@192.168.10.37:27027/sdkriskdb')
#Execute query
result<-con$aggregate(pipeline=paste('[
      {"$match":{
                "order.created" : {
                  "$gt" : {"$date":{"$numberLong":"',format(start,scientific=1),'"}},
                  "$lt" : {"$date":{"$numberLong":"',format(end,scientific=1),'"}}
                }
      }},
      {"$group":
                { 
                    "_id" : {"area":"$order.body.orderphonearea"},
                    "totalCount" : {
                        "$sum" : 1
                    }, 
                    "totalAmt" : {
                        "$sum" : "$order.body.pay_amt"
                    },
                    "totalSuccessCount":{
                        "$sum" :{
                      	  "$cond": { "if": { "$eq": ["$notice.body.rspcode",0]},"then": 1, "else": 0}
                      	}
                    },
                    "totalSuccessAmt":{
                      	"$sum" :{
                      	  "$cond": { "if": { "$eq": ["$notice.body.rspcode",0]},"then": "$order.body.pay_amt", "else": 0}
                      	}
                    }
                }
      },
      {"$project":{
                "area":"$_id.area",
                "totalCount":1,
                "totalAmt":1,
                "totalSuccessCount":1,
                "totalSuccessAmt":1,
                "_id":0
                }
      },
      {"$sort":{
              "totalCount":-1
      }},
      {"$limit":100}]',sep=""))

result$sucCountRate=result$totalSuccessCount/result$totalCount


ggplot(result,aes(x=totalCount,y=totalSuccessCount)) +
  geom_point() +
  geom_text(aes(label=area),colour="red")  #地域 