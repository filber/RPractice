library(ghyp)#用于处理generalized hyperbolic distribution和其特例.
library(timeSeries)
#install.packages("fEcofin", repos="http://R-Forge.R-project.org")
library(fEcofin)#数据包


# 1.准备 ----------------------------------------------------------------------
#加载数据
data(DowJones30)
#取得一列数据HWP并转化为时间序列
y<-timeSeries(DowJones30[,'HWP'],charvec = as.character(DowJones30[,1]))
#首先将y对数化,然后转换为相邻记录的difference.相当于将涨跌幅变相体现出来.
yret<-na.omit(diff(log(y))*100)


# 2.拟合 --------------------------------------------------------------------
#采用最大似然概率对单个序列进行GHD拟合.
ghdfit<-fit.ghypuv(data = yret,symmetric = FALSE,control=(list(maxit=1000)))

#采用最大似然概率对单个序列进行HYP拟合.
hypfit<-fit.hypuv(data = yret,symmetric = FALSE,control=(list(maxit=1000)))

#采用最大似然概率对单个序列进行NIG拟合.
nigfit<-fit.NIGuv(data = yret,symmetric = FALSE,control=(list(maxit=1000)))


# 3.密度 --------------------------------------------------------------------
#核密度估计,用于估计未知样本的密度函数
ef<-density(yret)
#GHD密度
ghddens<-dghyp(x = ef$x,object = ghdfit)
#HYP密度
hypdens<-dghyp(x = ef$x,object = hypfit)
#NIG密度
nigdens<-dghyp(x = ef$x,object = nigfit)
#高斯分布的密度
nordens<-dnorm(x = ef$x,mean = mean(yret),sd = sd(c(yret[,1])))


# 4.密度绘图 --------------------------------------------------------------------
col.def<-c('black','red','blue','green','orange')
plot(ef,xlab = ' ',ylab=expression(f(x)),ylim=c(0,0.3))#经验分布曲线,经验分布是采用样本估计整体分布的一种方式.
lines(ef$x,ghddens,col='red')#GHD分布曲线
lines(ef$x,hypdens,col='blue')#HYP分布曲线
lines(ef$x,nigdens,col='green')#NIG分布曲线
lines(ef$x,nordens,col='orange')#高斯分布曲线
#图例
legend('topleft',legend=c('emperical','GHD','HYP','NIG','NORM'),
       col=col.def,lty=seq(from = 1,to = length(col.def)),cex=0.6)


# 5.QQ图 -------------------------------------------------------------------
# 说明:QQ图用于鉴别样本的分布是否近似于某种类型的分布
#GHD的QQ图
qqghyp(ghdfit,line = TRUE,ghyp.col = col.def[2],plot.legend = FALSE,gaussian = FALSE,main = '')
#HYP的QQ图
qqghyp(hypfit,add = TRUE,line = FALSE,ghyp.col = col.def[3],plot.legend = FALSE,gaussian = FALSE,ghyp.pch = 2)
#NIG的QQ图
qqghyp(nigfit,add = TRUE,line = FALSE,ghyp.col = col.def[4],plot.legend = FALSE,gaussian = FALSE,ghyp.pch = 3)
legend('topleft',legend=c('GHD','HYP','NIG'),col=col.def[-c(1,5)],pch=1:3,cex=0.6)


# 6.诊断 --------------------------------------------------------------------
#使用赤池信息准则(Akaike Information Criterion,AIC)来度量拟合的优度,病选出一个最优的模型
AIC<-stepAIC.ghyp(data = yret,dist = c('ghyp','hyp','NIG'),symmetric = FALSE,control=(list(maxit=1000)))
View(AIC$fit.table)
#最优的模型为GHD
print(AIC$best.model)
#验证GHD和NIG的似然比率
LR.ghd.nig<-lik.ratio.test(ghdfit,nigfit)
#验证GHD和HYP的似然比率
LR.ghd.hpy<-lik.ratio.test(ghdfit,hypfit)