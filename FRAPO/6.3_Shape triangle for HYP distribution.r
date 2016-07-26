source(file = '6.1_Fitting HWP returns to the GHD.r')
#本清单用于检查HYP是否能被其他分布所逼近,同时重尾左移尖峰的特性对于Low-Frequency是否仍然有效

#收益周期
rd<-c(1,5,10,20,40)
#计算不同收益周期下的涨跌
#diff(log(y), lag=5)=log(y6)-log(y1)=log(y6/y1)
yrets<-na.omit(matrix(unlist(lapply(rd,function(x)diff(log(y), lag=x))),ncol=5))

## 计算xi/chi coefficients
xichi<-function(x){
  #提取模型的各项参数,并最终将其转化为两个值,以方便在2维平面上展示.
  param<-coef(x, type="alpha.delta")
  rho<-param[["beta"]]/param[["alpha"]]
  zeta<-param[["delta"]]*sqrt(param[["alpha"]]^2-param[["beta"]]^2)
  xi<-1/sqrt(1 + zeta)
  chi<-xi*rho
  result<-c(chi, xi)
  names(result)<-c("chi","xi")
  return(result)
}

#按照列(2)来进行HYP拟合
hypfits<-apply(yrets, 2, fit.hypuv, symmetric=FALSE)

points<-matrix(unlist(lapply(hypfits, xichi)),ncol=2, byrow=TRUE)
## Shape triangle
col.def <-c("black", "blue", "red","green", "orange")
leg.def<-paste(rd,rep("day return",5))
plot(points, ylim=c(-0.2, 1.2), xlim=c(-1.2, 1.2),col=col.def, pch=16, ylab=expression(xi),xlab=expression(chi))
lines(x=c(0,-1), y=c(0, 1))
lines(x=c(0, 1), y=c(0, 1))
lines(x=c(-1, 1), y=c(1, 1))
legend("bottomright", legend=leg.def,col=col.def, pch=16,cex=0.5)

text(x=0.0, y=1.05, label="Laplace",srt=0)
text(x=-1.0, y=1.05, label="Exponential", srt=0)
text(x=1.0, y=1.05, label="Exponential", srt=0)
text(x=0.0, y=-0.1, label="Normal", srt=0)
text(x=-0.6, y=0.5, label="Hyperbolic, left skewed",srt=302)
text(x=0.6, y=0.5, label="Hyperbolic, right skewed",srt=57)
