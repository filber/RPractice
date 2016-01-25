library(mongolite)
library(ggplot2)

#Connect To MongoDB
con <- mongo(collection = "mobile_collection",url = 'mongodb://sdkriskdbreadwrite:Re&wR%40u@192.168.10.37:27027/sdkriskdb')
#Execute query

findResult <- con$aggregate(pipeline='[
              {"$match":{"$or":[
                {"order.body.bankcardhash":{"$in":["7C100F13126F98E1840856B2ECF51BCEB3C18588","A5065B8B3969DC7C0CCCF01FDCC5525924DA8FEE","1FD0AE1D6275A3758FAE573C7AF618B19CEEE407","8CAB35CEA32F773C66E77E1CC89EA66F05AAA08E"]}}
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

ggplot(findResult,aes(x = factor(substring(created,6,16)),y = payamt,group=1)) +
  geom_point(size=8,aes(shape=paytranresult)) +
  geom_line() +
  geom_vline(xintercept=9.5,linetype="dashed") +    #时间间隔较长的区域分割线
  geom_vline(xintercept=14.5,linetype="dashed") +    #时间间隔较长的区域分割线
  ylim(0,120) +
  annotate("rect",ymin = 0,ymax = 120,xmin = .5,xmax = 7.5,fill="blue",alpha=.1) +  #盗卡成功区域
  geom_text(aes(label=bankcardmask,vjust=-2),colour="red") +  #银行卡后四位
  geom_text(aes(label=substr(orderphone,8,11),vjust=-4)) +    #充值手机号后四位
  geom_text(aes(label=substr(rcgphone,8,11),vjust=2)) +       #被充值手机号后四位
  geom_text(aes(label=paste("¥",payamt,sep=""),vjust=-6),colour="blue") + #金额
  ylab("金额") + xlab("时间") +
  coord_fixed(ratio = 1/20)
