library(RCurl)
library(ggplot2)
response<-getURL(url = "http://market.finance.sina.com.cn/downxls.php?date=2016-03-28&symbol=sh600516",.encoding = "GBK")
response_vector<-strsplit(response,split = "\n")[[1]][-1]
trans_frame<-data.frame()
for(i in seq(from=1,to=length(response_vector))){
  item<-strsplit(response_vector[i],split="\t")[[1]]
  trans_time<-item[1]
  trans_price<-as.numeric(item[2])
  trans_change<-item[3]
  trans_count<-as.numeric(item[4])
  trans_amount<-as.numeric(item[5])
  trans_flag<-item[6]
  trans_frame<-rbind(data.frame(time=trans_time,price=trans_price,change=trans_change,count=trans_count,amount=trans_amount,flag=trans_flag),trans_frame)
}
ggplot(trans_frame,aes(x = time,y = price,group=1)) +
  geom_point(aes(size=count,shape=flag,color=flag))

stock<-read_excel(path = "sh600516_2016-03-24.xls")
stock<-read.csv("sh600516_2016-03-24.csv")

grid.newpage()
pushViewport(viewport(layout = grid.layout(2,1)))
print(p1,vp=viewport(layout.pos.row = 1,layout.pos.col = 1))
print(p1,vp=viewport(layout.pos.row = 2,layout.pos.col = 1))