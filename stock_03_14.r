library(ggplot2)

stock<- read.csv(file = "table.csv")
stock$flag1<-NULL

stock$no<-seq(from = 1,to=dim(stock)[1])

ggplot(stock,aes(x = no,y = price,group=1)) +
  geom_point(size=2,aes(shape=flag)) +
  geom_line()

//点的大小表示量的大小?
//横轴表示时间
//纵轴表示价位

stock_subset<-subset(x = stock,subset = amount>30000)
ggplot(stock,aes(x = no,y = price,group=1)) +
  geom_point(aes(size=amount,shape=flag,color=amount)) +
  scale_colour_gradient(high = "#132B43", low = "#56B1F7")