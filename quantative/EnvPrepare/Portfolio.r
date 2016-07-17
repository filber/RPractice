require(quantstrat)

# 初始化金融产品
stockSymbol<-'Data'
initDate<-PARAM$INIT.TIMESTAMP

currency("RMB")
# stock(stockSymbol, currency = "RMB", multiplier = 1)
Sys.setenv(TZ="UTC")

# 初始化一个策略
q.strategy <- "DQStrategy"
DQStrategy<-strategy(q.strategy)
.strategy<-new.env()

# 初始化一个投资组合
if (!exists('.blotter')) .blotter <- new.env()
initPortf(q.strategy, stockSymbol, initDate = initDate,currency = "RMB",initPosQty = PARAM$INIT.POS.QTY)
# 约束最大持仓数和最小持仓数
addPosLimit(portfolio = q.strategy,symbol = stockSymbol,longlevels = 1,maxpos = PARAM$MAX.POS.QTY,minpos = PARAM$INIT.POS.QTY,timestamp = as.POSIXct(initDate))
if(PARAM$INIT.POS.QTY!=0){
    addPosLimit(portfolio = q.strategy,symbol = stockSymbol,longlevels = 1,maxpos = PARAM$MAX.POS.QTY,minpos = PARAM$MIN.POS.QTY,timestamp = as.POSIXct(PARAM$SIM.TIMESTAMP))
}

# 初始化一个账户
initAcct(q.strategy, portfolios = q.strategy, initDate = initDate,currency = "RMB", initEq = 2e+04)

# 初始化指令集
initOrders(portfolio = q.strategy, initDate = initDate)
