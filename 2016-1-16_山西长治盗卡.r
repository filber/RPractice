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
                "orderriskresult" : "$order.body.riskresultmsg",
                "noticersp" : "$notice.body.rspcode", 
                "paytranresult" : "$notice.body.pay_tran_result"
              }},
              {"$sort":{"created":1}},
              {"$limit":100}]')

#Data Preparation
findResult$payamt=as.integer(findResult$payamt)/100
findResult$paytranresult[is.na(findResult$paytranresult)]=findResult$orderriskresult[is.na(findResult$paytranresult)]

#View(findResult)

#Rough Draw,detect there are two segments
#ggplot(findResult,aes(x = created,y = payamt))+geom_line()

ggplot(findResult,aes(x = factor(substring(created,6,19)),y = payamt,group=1)) +
  geom_point(size=8,aes(shape=paytranresult)) +
  geom_line() +
  ylim(-200,max(findResult$payamt)+800) +
  geom_vline(xintercept=8.5,linetype="dashed") +
  annotate("rect",ymin = -150,ymax = 750,xmin = 11.5,xmax = 17.5,fill="blue",alpha=.1) +
  geom_text(aes(label=bankcardmask,vjust=-2),colour="red") +
  geom_text(aes(label=substr(orderphone,8,11),vjust=-4)) +
  geom_text(aes(label=substr(rcgphone,8,11),vjust=2)) +
  geom_text(aes(label=paste("¥",payamt,sep=""),vjust=-6),colour="blue") + #金额
  ylab("金额") + xlab("时间") +
  coord_fixed(ratio = 1/500)
  
