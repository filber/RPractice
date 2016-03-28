library(ggplot2)
retrieveStockTrans<-function(d,fileName){
  stock<- read.csv(file = paste("D:/new_tdx/T0002/export/",fileName,".txt",sep=""))
  stock$date<-d
  stock$no<-seq(from = 1,to=dim(stock)[1])
  stock
}

stock<-retrieveStockTrans("20160324","fdts_2016_03_24")
#stock<-rbind(stock,retrieveStockTrans("20160322","hryy_2016_03_22"))
#stock<-rbind(stock,retrieveStockTrans("20160323","hryy_2016_03_23"))
#stock<-rbind(stock,retrieveStockTrans("20160324","hryy_2016_03_24"))
#stock<-rbind(stock,retrieveStockTrans("20160325","hryy_2016_03_25"))

ggplot(stock,aes(x = no,y = price,group=1)) +
  geom_point(aes(size=amount,shape=flag,color=flag)) +
  facet_grid(. ~ date)

stock_subset<-subset(stock,subset = amount>2000)
ggplot(stock_subset,aes(x = no,y = price,group=1)) +
  geom_point(aes(size=amount,shape=flag,color=flag)) +
  facet_grid(. ~ date)
  geom_hline(yintercept=10.2,linetype="dashed") +
  geom_hline(yintercept=9.8,linetype="dashed")
summary(stock_subset)
sum(subset(stock_subset,subset=flag=='B')$amount)
sum(subset(stock_subset,subset=flag=='S')$amount)

summary(stock)
sum(subset(stock,subset=flag=='B')$amount)
sum(subset(stock,subset=flag=='S')$amount)
