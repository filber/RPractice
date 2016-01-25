library(mongolite)
library(ggplot2)

#Connect To MongoDB
con <- mongo(collection = "mobile_collection",url = 'mongodb://sdkriskdbreadwrite:Re&wR%40u@192.168.10.37:27027/sdkriskdb')
#Execute query
findResult <- con$aggregate(pipeline='[
              {"$match":{"$or":[
                {"order.body.rcg_phone" : {"$in":["13994603218","18435719237","13643406577"]}}
              ]}},
              {"$project":{
                "_id":0,
                "created" : "$order.created",
                "bankcardmask" : "$order.body.bankcardmask",
                "orderphone" : "$order.body.order_phone",
                "rcgphone" : "$order.body.rcg_phone",
                "payamt" : "$order.body.pay_amt",
                "orderrsp" : "$order.body.rspcode",
                "noticersp" : "$notice.body.rspcode", 
                "paytranresult" : "$notice.body.pay_tran_result"
              }},
              {"$sort":{"created":1}},
              {"$limit":100}]')

#Data Preparation
findResult$payamt=as.integer(findResult$payamt)/100
findResult$paytranresult[is.na(findResult$paytranresult)]="NONE"

View(findResult)

#Rough Draw,detect there are two segments
#ggplot(findResult,aes(x = created,y = payamt))+geom_line()

ggplot(findResult,aes(x = factor(created),y = payamt,group=1)) +
  geom_point(size=8,aes(shape=paytranresult)) +
  geom_line() +
  ylim(0,max(findResult$payamt)+100) +
  geom_vline(xintercept=8.5,linetype="dashed") +
  annotate("rect",ymin = 0,ymax = max(findResult$payamt),xmin = 11.5,xmax = 17.5,fill="blue",alpha=.1) +
  geom_text(aes(label=bankcardmask,vjust=-2),colour="red") +
  geom_text(aes(label=substr(orderphone,8,11),vjust=-4)) +
  geom_text(aes(label=substr(rcgphone,8,11),vjust=2)) +
  ylab("金额") + xlab("时间")
