library(RCurl)
library(ggplot2)

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

symbol<-"sh600724"
dates<-c("2016-04-06","2016-04-07","2016-04-08","2016-04-11","2016-04-12","2016-04-13")
trans_frame<-sina_detail_trans(symbol,dates)
ggplot(trans_frame,aes(x = time,y = price,group=1)) +
  geom_point(aes(size=count,shape=flag,color=flag)) +
  facet_wrap(~ date,ncol = 3) +
  ggtitle(label = symbol)