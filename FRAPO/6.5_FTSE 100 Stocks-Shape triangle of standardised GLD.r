library(FRAPO)
library(fBasics)
## Loading of data
data(INDTRACK3)#加载FTSE100指数以及它的89个组成指数
P <- INDTRACK3[, -1]#只保留组成指数
R <- returnseries(P, method = "discret", trim = TRUE)#计算收益率

## Fitting and calculating beta and lambda
#按照列(2)进行拟合,得到拟合函数List
Fit <- apply(R, 2, gldFit, method = "rob", doplot = FALSE,trace = FALSE)

#取得GLD函数List的lambda3和lambda4列表
DeltaBetaParam <- matrix(unlist(lapply(Fit, function(x){
  l <- x@fit$estimate[c(3, 4)]#从Fit中取得lambda3和lambda4
  res <- c(l[2] - l[1], l[1] + l[2])
  res})), ncol = 2, byrow = TRUE)

## Shape triangle
#这种划分区域显示点的方式比较新颖
plot(DeltaBetaParam, xlim = c(-2, 2), ylim = c(-2, 0),
     xlab = expression(delta == lambda[4] - lambda[3]),
     ylab = expression(beta == lambda[3] + lambda[4]),
     pch = 19, cex = 0.5)
segments(x0 = -2, y0 = -2, x1 = 0, y1 = 0,
         col = "grey", lwd = 0.8, lty = 2)
segments(x0 = 2, y0 = -2, x1 = 0, y1 = 0,
         col = "grey", lwd = 0.8, lty = 2)
segments(x0 = 0, y0 = -2, x1 = 0, y1 = 0, col = "blue",
         lwd = 0.8, lty = 2)
segments(x0 = -0.5, y0 = -0.5, x1 = 0.5, y1 = -0.5,
         col = "red", lwd = 0.8, lty = 2)
segments(x0 = -1.0, y0 = -1.0, x1 = 1.0, y1 = -1.0,
         col = "red", lwd = 0.8, lty = 2)