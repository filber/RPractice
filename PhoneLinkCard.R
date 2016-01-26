library(mongolite)
library(ggplot2)

#Connect To MongoDB
con <- mongo(collection = "mobile_collection",url = 'mongodb://sdkriskdbreadwrite:Re&wR%40u@192.168.10.37:27027/sdkriskdb')

#Execute query
#phone <- c("13891843489","13649274024","13759782788","13474699331")
card <- c()

#Phone Spread Bankcardhash
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
              "bankcardhash" : "$order.body.bankcardhash"
                }
    }]',sep=""))

card<-unique(c(card,findResult$bankcardhash))
