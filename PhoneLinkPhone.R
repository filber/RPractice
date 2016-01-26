library(mongolite)
library(ggplot2)

#Connect To MongoDB
con <- mongo(collection = "mobile_collection",url = 'mongodb://sdkriskdbreadwrite:Re&wR%40u@192.168.10.37:27027/sdkriskdb')
#Execute query
#phone <- c("13891843489","13649274024","13759782788","13474699331")

beforeLength <- length(phone)
afterLength <- beforeLength +1
loopCount <- 1
#Phone Spread Phone
while(loopCount<MaxLoopCount && beforeLength!=afterLength){
findResult <- con$aggregate(pipeline=paste('[
    {"$match":{"$or":[
              {"order.body.order_phone" : {
                "$in" : [',
                    paste('"',phone,'"',collapse = ',',sep=''),
                ']}
              },
              {"order.body.rcg_phone" : {
                "$in" : [',
                paste('"',phone,'"',collapse = ',',sep=''),
                ']}
              }
                                ]}},
    {"$project":{
                                "_id":0,
                                "orderphone" : "$order.body.order_phone",
                                "rcgphone" : "$order.body.rcg_phone"
                }
    }]',sep=""))


beforeLength <- length(phone)
phone<-unique(c(phone,findResult$orderphone,findResult$rcgphone))
afterLength <- length(phone)
loopCount <- loopCount +1
}
