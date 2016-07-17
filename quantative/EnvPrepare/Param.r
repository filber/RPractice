

# Model Parameter List ------------------------------------------------------------------
PARAM<-list()

#系统模式(apply:测试,optimize:优化,simulate:模拟盘)
PARAM$FLAG<-commandArgs(trailingOnly = TRUE)[1]
PARAM$FLAG<-if(is.na(PARAM$FLAG))'apply'else PARAM$FLAG

# Strategy Config ---------------------------------------------------------
#初始仓位数
PARAM$INIT.POS.QTY <- 0
#最大仓位数
PARAM$INIT.MAX.POS.QTY <- 0
#最小仓位数
PARAM$INIT.MIN.POS.QTY <- 0
#最大仓位数
PARAM$SIM.MAX.POS.QTY <- 1000
#最小仓位数
PARAM$SIM.MIN.POS.QTY <- 0

#账户初始化时间
PARAM$INIT.TIMESTAMP<-"2010-01-01"
#模拟交易起始时间戳
PARAM$SIM.TIMESTAMP<-'2016-06-15'


#买入股数
PARAM$ORDER.QTY.BUY <- 1000
#卖出股数
PARAM$ORDER.QTY.SELL <- -1000

# Optimization Config -----------------------------------------------------
# Paramset Samples
PARAM$PARAMSET.NSAMPLES <- 300
