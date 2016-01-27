library(mongolite)
library(ggplot2)

MaxLoopCount<-1
phone <- c("13891843489","13649274024","13759782788","13474699331")
#该手机号触发了黑名单
#phone <- c(phone,"15847340391")


source(file = "PhoneLinkPhone.R")
source(file = "PhoneLinkCard.R")

#Connect To MongoDB
con <- mongo(collection = "mobile_collection",url = 'mongodb://sdkriskdbreadwrite:Re&wR%40u@192.168.10.37:27027/sdkriskdb')
#Execute query
findResult <- con$aggregate(pipeline=paste('[
              {"$match":{"$or":[
                {"order.body.bankcardhash":{"$in":['
                  ,paste('"',card,'"',collapse = ',',sep=''),
                ']}}
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
              {"$limit":100}]',seg=""))

#Data Preparation
findResult$payamt=as.integer(findResult$payamt)/100
findResult$paytranresult[is.na(findResult$paytranresult)]=findResult$orderriskresult[is.na(findResult$paytranresult)]

#Draw Graphics
p<-ggplot(findResult,aes(x = factor(substring(created,9,16)),y = payamt,group=1)) +
  geom_point(size=8,aes(shape=paytranresult)) +
  geom_line() +
  ylim(0,120) +
  #annotate("rect",ymin = 0,ymax = 120,xmin = 1.5,xmax = 2.5,fill="blue",alpha=.1) +  #盗卡区域
  #annotate("rect",ymin = 0,ymax = 120,xmin = 5.5,xmax = 6.5,fill="blue",alpha=.1) +  #盗卡区域
  #annotate("rect",ymin = 0,ymax = 120,xmin = 8.5,xmax = 11.5,fill="blue",alpha=.1) +  #盗卡区域
  geom_text(aes(label=bankcardmask,vjust=-2),colour="red") +  #银行卡后四位
  geom_text(aes(label=substr(orderphone,8,11),vjust=-4)) +    #充值手机号后四位
  geom_text(aes(label=substr(rcgphone,8,11),vjust=2)) +       #被充值手机号后四位
  geom_text(aes(label=paste("¥",payamt,sep=""),vjust=-6),colour="blue") + #金额
  ylab("金额") + xlab("时间") +
  coord_fixed(ratio = 1/20)

start_pivot<-1
end_pivot<-2
threshold<-3000
splitLines<-c()
while(end_pivot<length(findResult$created)){
  if(sd(findResult[start_pivot:end_pivot,]$created)>threshold){
    splitLines<-c(splitLines,end_pivot-0.5)
    p<-p+geom_vline(xintercept=end_pivot-0.5,linetype="dashed")    #时间分割线
    start_pivot<-end_pivot
    end_pivot<-end_pivot+1
  } else {
    end_pivot<-end_pivot+1
  }
}
p
