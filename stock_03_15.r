library(ggplot2)

stock<- read.csv(file = "jxzy_2016_03_17.txt")
stock$no<-seq(from = 1,to=dim(stock)[1])

ggplot(stock,aes(x = no,y = price,group=1)) +
  geom_point(aes(size=amount,shape=flag,color=amount)) +
  scale_colour_gradient(high = "#132B43", low = "#56B1F7")


stock_subset<-subset(stock,subset = amount>2000)
summary(stock_subset)
sum(subset(stock_subset,subset=flag=='B')$amount)
sum(subset(stock_subset,subset=flag=='S')$amount)

ggplot(stock_subset,aes(x=flag,fill=flag)) +
  geom_bar(stat="bin",colour="black")
