library(mongolite)

#Query Condition for bankcardhash
query_card<-function(card){
  paste('{"order.body.bankcardhash":{"$in":['
                  ,paste('"',card,'"',collapse = ',',sep=''),']}}',sep='')
}

#Query Condition for orderphone&rcgphone
query_phone<-function(phone){
  paste('{"order.body.order_phone" : {
                "$in" : ['
        ,paste('"',phone,'"',collapse = ',',sep=''),
        ']}
              },
              {"order.body.rcg_phone" : {
                "$in" : ['
        ,paste('"',phone,'"',collapse = ',',sep=''),
        ']}
              }',sep='')
}

#Query IVR Risk Database
searchIVRRiskDB<-function(query){
  #Connect To MongoDB
  con <- mongo(collection = "mobile_collection",url = 'mongodb://sdkriskdbreadwrite:Re&wR%40u@192.168.10.37:27027/sdkriskdb')
  #Execute query
  result<-con$aggregate(pipeline=paste('[
              {"$match":{"$or":[',query,']}},
              {"$project":{
                "_id":0,
                "created" : "$order.created",
                "bankcardhash" : "$order.body.bankcardhash",
                "bankcardmask" : "$order.body.bankcardmask",
                "cardtype" : "$order.body.card_type",
                "bankcardarea":"$order.body.bankcardarea",
                "bankcardcity":"$order.body.cityno",
                "orderphone" : "$order.body.order_phone",
                "orderphonearea":"$order.body.orderphonearea",
                "orderphonecity":"$order.body.orderphonecity",
                "rcgphone" : "$order.body.rcg_phone",
                "rcgphonecity":"$order.body.cardphonecity",
                "rcgphonearea":"$order.body.cardphonearea",
                "payamt" : "$order.body.pay_amt",
                "orderrsp" : "$order.body.rspcode",
                "orderriskresult" : "$order.body.riskresultmsg",
                "noticersp" : "$notice.body.rspcode", 
                "paytranresult" : "$notice.body.pay_tran_result",
                "regdate" : "$order.body.regdate",
                "trannum" : "$order.body.trannum",
                "transucnum" : "$order.body.transucnum",
                "firstsuctime" : "$order.body.firstsuctime",
                "firsttrantime" : "$order.body.firsttrantime",
                "lastsuctime" : "$order.body.lastsuctime",
                "lasttrantime" : "$order.body.lasttrantime"
              }},
              {"$sort":{"created":1}},
              {"$limit":100}]',seg=""))
  #Data Preparation
  result$payamt=as.integer(result$payamt)/100
  result$paytranresult[is.na(result$paytranresult)]=result$orderriskresult[is.na(result$paytranresult)]
  result$regdate=as.POSIXct(as.character(result$regdate),format="%Y%m%d%H%M%S",origin = "GMT")
  result$firstsuctime=as.POSIXct(as.character(result$firstsuctime),format="%Y%m%d%H%M%S",origin = "GMT")
  result$firsttrantime=as.POSIXct(as.character(result$firsttrantime),format="%Y%m%d%H%M%S",origin = "GMT")
  result$firsttrantime=as.POSIXct(as.character(result$firsttrantime),format="%Y%m%d%H%M%S",origin = "GMT")
  result$lastsuctime=as.POSIXct(as.character(result$lastsuctime),format="%Y%m%d%H%M%S",origin = "GMT")
  result$lasttrantime=as.POSIXct(as.character(result$lasttrantime),format="%Y%m%d%H%M%S",origin = "GMT")
  result
}


recursiveLink_Phone_2_Phone<-function(phone,maxLoopCount=10){
  beforeLength <- length(phone)
  afterLength <- beforeLength +1
  loopCount <- 1
  #Phone Spread Phone
  while(loopCount<maxLoopCount && beforeLength!=afterLength){
    PhoneLinkPhoneTemp<-searchIVRRiskDB(query = query_phone(phone))
    beforeLength <- length(phone)
    phone<-unique(c(phone,PhoneLinkPhoneTemp$orderphone,PhoneLinkPhoneTemp$rcgphone))
    afterLength <- length(phone)
    loopCount <- loopCount +1
  }
  phone
}

link_Card_2_Phone<-function(card){
  #Phone Spread Bankcardhash
  cardLinkPhoneTemp<-searchIVRRiskDB(query = query_card(card))
  unique(c(cardLinkPhoneTemp$orderphone,cardLinkPhoneTemp$rcgphone))
}

link_Phone_2_Card<-function(phone){
  #Phone Spread Bankcardhash
  phoneLinkCardTemp<-searchIVRRiskDB(query = query_phone(phone))
  unique(c(phoneLinkCardTemp$bankcardhash))
}