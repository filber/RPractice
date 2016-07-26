source(file = '6.1_Fitting HWP returns to the GHD.r')

#由于要计算的是收益而非风险,所以概率取左边的尾巴(0.1%-5%)
p<-seq(from = 0.001,to = 0.05,by = 0.001)

# 1.计算VaR --------------------------------------------------------------------
#VaR用于描述一定概率a与可能遭受到的最大损失
ghd.VaR<-abs(qghyp(p,ghdfit))
hyp.VaR<-abs(qghyp(p,hypfit))
nig.VaR<-abs(qghyp(p,nigfit))
#参见正态分布的VaR计算
nor.VaR<-abs(qnorm(p,mean=mean(yret),sd = sd(c(yret[,1]))))
emp.VaR<-abs(quantile(x = yret,probs = p))


# 2.VaR绘图 --------------------------------------------------------------------
# 收益的直方图
hist(yret,breaks = 100)
# 经验分布的VaR
plot(emp.VaR,type='l',xlab=' ',ylab='VaR',axes=FALSE,
     ylim=range(c(ghd.VaR,hyp.VaR,nig.VaR,nor.VaR,emp.VaR)))
#加外边框
box()
#添加百分比到横轴坐标
axis(1,at=seq(along=p),labels=names(emp.VaR),tick=FALSE)
#添加收益数值到纵轴坐标
axis(2,at=pretty(range(c(ghd.VaR,hyp.VaR,nig.VaR,nor.VaR,emp.VaR))))
lines(seq(along=p),ghd.VaR,col=col.def[2],lty=2)
lines(seq(along=p),hyp.VaR,col=col.def[3],lty=3)
lines(seq(along=p),nig.VaR,col=col.def[4],lty=4)
lines(seq(along=p),nor.VaR,col=col.def[5],lty=5)
#图例
legend('topright',legend=c('emperical','GHD','HYP','NIG','NORM'),
       col=col.def,lty=seq(from = 1,to = length(col.def)),cex=0.6)


# 3.计算ES ------------------------------------------------------------------
ghd.ES<-abs(ESghyp(p,ghdfit))
hyp.ES<-abs(ESghyp(p,hypfit))
nig.ES<-abs(ESghyp(p,nigfit))
#dnorm得到的是密度
#pnorm得到的是概率分布
#qnorm得到的是分位数(qnorm是pnorm的逆运算)
#参见正态分布的ES计算
nor.ES<-abs(mean(yret)-sd(c(yret[,1]))*dnorm(qnorm(1-p))/p)
#此处经验分布的ES计算方式应留意下
#obs.p得到的是给定概率面积下的元素数量
obs.p<-ceiling(x = p*length(yret))
#mean(sort(c(yret))[1:x])得到的是按照收益值正序排序后,取前x个元素的平均值--->经验分布的ES
emp.ES<-sapply(obs.p,FUN = function(x){abs(mean(sort(c(yret))[1:x]))})


# 4.对ES绘图 -----------------------------------------------------------------
plot(emp.ES,type='l',xlab=' ',ylab='ES',axes=FALSE,
     ylim=range(c(ghd.ES,hyp.ES,nig.ES,nor.ES,emp.ES)))
box()
axis(1,at=1:length(p),labels=names(emp.VaR),tick=FALSE)
axis(2,at=pretty(range(ghd.ES,hyp.ES,nig.ES,nor.ES,emp.ES)))
lines(1:length(p),ghd.ES,col=col.def[2],lty=2)
lines(1:length(p),hyp.ES,col=col.def[3],lty=3)
lines(1:length(p),nig.ES,col=col.def[4],lty=4)
lines(1:length(p),nor.ES,col=col.def[5],lty=5)
legend('topright',legend=c('emperical','GHD','HYP','NIG','NORM'),
       col=col.def,lty=seq(from = 1,to = length(col.def)),cex=0.6)
