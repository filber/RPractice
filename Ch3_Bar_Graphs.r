library(ggplot2)
library(gcookbook)


#3.1. Making Basic Bar Graph
#x轴discrete,y轴continuous
ggplot(data = pg_mean,aes(x = group,y = weight))+geom_bar(stat = "identity")

#x轴continuous,y轴continuous
ggplot(data = BOD,aes(x = Time,y = demand))+geom_bar(stat = "identity")

#改变填充颜色
ggplot(data = pg_mean,aes(x = group,y = weight))+geom_bar(stat = "identity",fill='lightblue',colour='black')


#3.2. Grouping Bars Together
#使用fill来对group bars再进行分组,使用dodge将一个bar内不同fill的隔离开
ggplot(cabbage_exp,aes(x=Date,y=Weight,fill=Cultivar)) +geom_bar(stat='identity',position='dodge')
#不加dodge则一个柱内部会分为上下,即StackedBarPlot
ggplot(cabbage_exp,aes(x=Date,y=Weight,fill=Cultivar)) +geom_bar(stat='identity')

#设置bar的边线颜色为black
ggplot(cabbage_exp,aes(x=Date,y=Weight,fill=Cultivar)) +geom_bar(stat='identity',color='black',position='dodge')
#增加scale_fill_brewer使得填充色更柔和
ggplot(cabbage_exp,aes(x=Date,y=Weight,fill=Cultivar)) +geom_bar(stat='identity',color='black',position='dodge')+scale_fill_brewer(palette="Pastel1")

#data只取了前5行
ggplot(data=cabbage_exp[1:5,],aes(x=Date,y=Weight,fill=Cultivar)) +geom_bar(stat='identity',color='black',position='dodge')+scale_fill_brewer(palette="Pastel1")


#3.3. Making a Bar Graph of Counts
#无需指定y轴,直接统计x值的counts
ggplot(data=diamonds,aes(x=cut))+geom_bar()
ggplot(data=diamonds,aes(x=carat))+geom_bar()

#3.4. Using Colors in Bar Graph
ggplot(subset(uspopchange,rank(Change)>40),aes(x=Abb,y=Change,fill=Region))+geom_bar(stat="identity")
