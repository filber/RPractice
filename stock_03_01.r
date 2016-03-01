library(ggplot2)

stock<- read.csv(file = "2016_03_0120160301.txt")
stock$X<-NULL
stock_label<-geom_text(aes(label=名称,vjust=4)) +geom_text(aes(label=涨幅,vjust=-2))
ggplot(stock,aes(y = 涨幅,x = 换手))+geom_point()+geom_vline(xintercept=5,linetype="dashed")+geom_text(aes(label=名称,size=2,vjust=1)) +geom_text(aes(label=涨幅,size=2,vjust=-1))

ggplot(stock,aes(y = 涨幅,x = 量比))+geom_point()+geom_vline(xintercept=1.4,linetype="dashed")+geom_text(aes(label=名称,size=2,vjust=1)) +geom_text(aes(label=涨幅,size=2,vjust=-1))

ggplot(stock,aes(y = 振幅,x = 流通市值))+geom_point()+geom_vline(xintercept=100,linetype="dashed")

ggplot(stock,aes(y = 振幅,x = 内外比))+geom_point()+geom_vline(xintercept=100,linetype="dashed")
