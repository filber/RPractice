library(ggplot2)
library(gcookbook)


#2.1. Scatter Plot
#使用graphics中的plot绘制scatter plot
plot(mtcars$wt,mtcars$mpg)

qplot(mtcars$wt,mtcars$mpg)
#equals to 
qplot(x = wt,y = mpg,data = mtcars)
#equals to 
#(1)aes担任mapping的作用
#(2)geom_point负责画点
ggplot(data = mtcars,mapping = aes(x = wt,y = mpg))+geom_point()

#2.2. Line Graph
#先画线,再画点
plot(pressure$temperature,pressure$pressure,type='l')
points(pressure$temperature,pressure$pressure)

plot(pressure$temperature,pressure$pressure/2,type='l',col='red')
points(pressure$temperature,pressure$pressure/2,col='red')
#equals to
qplot(x = pressure$temperature,y=pressure$pressure,geom=c('line','point'))
#equals to
ggplot(data = pressure,mapping = aes(x = temperature,y = pressure))+geom_point()+geom_line()

#2.3. Bar Graph
barplot(height = BOD$demand,names.arg = BOD$Time)
barplot(table(mtcars$cyl))
#equals to
qplot(x = BOD$Time,y = BOD$demand,geom = 'bar',stat = 'identity')
#将x轴的值转化为factor,这样的话使用discrete而非continuous对其展示.
qplot(factor(x = BOD$Time),y = BOD$demand,geom = 'bar',stat = 'identity')
#equals to
ggplot(mtcars,aes(x = factor(cyl)))+geom_bar()


#2.4. Histogram
hist(mtcars$mpg)
hist(mtcars$mpg,breaks = 10)
#equals to 
qplot(mtcars$mpg,geom='histogram')
#equals to 
ggplot(mtcars,aes(x=mpg))+geom_histogram(binwidth=4)


#2.5. Box Plot
