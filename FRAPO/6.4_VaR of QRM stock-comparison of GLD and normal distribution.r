## Loading of packages
library(lmomco)#用于拟合GLD
library(FRAPO)

## Data loading
data(SP500)
Idx <- SP500[, "QCOM"]#得到QCOM的价格序列
L <- -1 * returnseries(Idx, method = "discrete", trim = TRUE)#将价格序列转化为收益百分比

## Computing VaR (Normal & GLD) 99%, moving window 
ep <- 104:length(L)#滑动窗口的End Position序列
sp <- 1:length(ep)#滑动窗口的Start Position序列
level <- 0.99#概率值

VaR <- matrix(NA, ncol = 2, nrow = length(ep))#初始化一个161行2列的空矩阵,用来存储VaR

#循环计算161个窗口数据拟合出分布的VaR
for(i in 1:length(sp)){
  x <- L[sp[i]:ep[i]]#截出窗口内的数据
  lmom <- lmom.ub(x)
  fit <- pargld(lmom)#进行GLD拟合
  VaRGld <- quagld(level, fit)#计算GLD的VaR(Quantile)
  VaRNor <- qnorm(level, mean(x), sd(x))#计算正态分布的VaR
  VaR[i, ] <- c(VaRGld, VaRNor)
  print(paste("Result for", ep[i], ":", VaRGld, "and", VaRNor))
}

## Summarising results
#将亏损与VaRGLD和VaRNor合并
Res <- cbind(L[105:length(L)], VaR[-nrow(VaR), ])
colnames(Res) <- c("Loss", "VaRGld", "VaRNor")


## Plot of backtest results
plot(Res[, "Loss"], type = "p", xlab = "Time Index",
     ylab = "Losses in percent", pch = 19, cex = 0.5,
     ylim = c(-15, max(Res)))
abline(h = 0, col = "grey")
#VaRGld的波动较大,更为敏感,且在末端放生了下挫(losses整体下移了)
lines(Res[, "VaRGld"], col = "blue", lwd = 2)
lines(Res[, "VaRNor"], col = "red", lwd = 2)
legend("bottomleft", legend = c("Losses", "VaR GLD", "VaR Normal"),cex = 0.5,
       col = c("black", "blue", "red"),
       lty = c(NA, 1, 1), pch = c(19, NA, NA), bty = "n")
