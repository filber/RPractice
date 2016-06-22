require(TTR)
require(quantmod)
data(ttrc)

dmi.adx<-ADX(HLC = ttrc[,c("High","Low","Close")],n = 10,maType = "SMA")
