library(ggplot2)
library(gcookbook)


#2.1. Scatter Plot
#x和y均为continuous的vector
plot(mtcars$wt,mtcars$mpg)
#equals to 
qplot(mtcars$wt,mtcars$mpg)
#equals to 
qplot(x = wt,y = mpg,data = mtcars)
#equals to 
#(1)aes担任mapping的作用
#(2)geom_point负责画点
ggplot(data = mtcars,mapping = aes(x = wt,y = mpg))+geom_point()

#2.2. Line Graph
#先画线,再画点,points函数具备追加功能.
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
#x是factor,则会默认绘制Box Plot
plot(x=ToothGrowth$supp,y=ToothGrowth$len)
#equals to
boxplot(len~supp,data = ToothGrowth)
#equals to
qplot(ToothGrowth$supp,ToothGrowth$len,geom='boxplot')

#x轴用suppo和dose交叉组合
boxplot(len~supp+dose,data = ToothGrowth)
qplot(interaction(ToothGrowth$supp,ToothGrowth$dose),ToothGrowth$len,geom='boxplot')
ggplot(ToothGrowth,aes(x = interaction(supp,dose),y = len))+geom_boxplot()


#2.6. Function Curve
curve(expr = x^3-5*x,from = -10,to = 10)
myfun <- function(xvar) {
  1/(1 +exp(-xvar + 10))
}
#expr接受一个以numeric vector做输入,同时输出一个numeric vector的函数.
curve(expr = myfun(x),from=0,to=20)
#使用add=TRUE表明在现有图形上追加绘制.
curve(1-myfun(x),add = TRUE,col = "red")

qplot(x = c(0,20),fun=myfun,stat='function',geom = 'line')
#equals to
ggplot(data.frame(x=c(0, 20)),aes(x=x)) +stat_function(fun=myfun,geom="line")
