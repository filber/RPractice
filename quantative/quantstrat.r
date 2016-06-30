require(quantstrat)


load(file = "GTJA_Minutes.RData");

#金融产品初始化
stockSymbol<-'GTJA'
currency("RMB")
stock(stockSymbol, currency = "RMB", multiplier = 1)
# 设定时区
Sys.setenv(TZ = "UTC")

# GTJA <- getSymbols.yahoo("601211.SS", from = "2016-01-02",auto.assign = FALSE)
chartSeries(x = GTJA, name = "国泰君安",theme = chartTheme("white"),TA = 'addSMA(n=5);addSMA(n=10);addVo()')

q.strategy <- "bFaber"
#初始化一个投资组合:名称,资产标识,初始时间(位置)
if (!exists('.blotter')) .blotter <- new.env()
initPortf(q.strategy, stockSymbol, initDate = "2016-01-01")
strategy(q.strategy, store = TRUE)
#初始化一个账户
initAcct(q.strategy, portfolios = q.strategy, initDate = "2016-01-01", initEq = 2e+04)
addPosLimit(portfolio = q.strategy,symbol = stockSymbol,longlevels = 1,maxpos = 1000,minpos = 0,timestamp = as.POSIXct("2016-01-01"))
portfolio<-getPortfolio(Portfolio = q.strategy)
getAccount(Account = q.strategy)
getPortfolio(Portfolio = q.strategy)

# 初始化指令集和策略
initOrders(portfolio = q.strategy, initDate = "2016-06-01")

source(file = "quantative//roc.r")

# 显示策略的内容(名称,资产,指标,信号,规则,约束等)
strategy <- getStrategy(q.strategy)
summary(strategy)

#使用这个策略
out <- applyStrategy(strategy = q.strategy, portfolios = q.strategy,mktdata = GTJA)
#执行参数优化
userEnv<-new.env()
paramset.out <- apply.paramset(strategy.st = q.strategy,paramset.label = "ROC",audit = userEnv,
                               account.st = q.strategy,portfolio.st = q.strategy,
                               mktdata = GTJA,nsamples = 1000)
tradestats<-userEnv$tradeStats
View(tradestats[with(tradestats,order(-Net.Trading.PL)),])
View(tradestats[with(tradestats,order(-Max.Drawdown)),])
hist(tradestats$Net.Trading.PL,breaks = 100)
tradeGraphs(stats = paramset.out$tradeStats,free.params = c("ROC_Period","MAROC_Period"),statistics = c("Net.Trading.PL"))
tradeGraphs(stats = paramset.out$tradeStats,free.params = c("ROC_High_Limit","ROC_Low_Limit"),statistics = c("Net.Trading.PL"))

updatePortf(q.strategy)
updateAcct(q.strategy)
updateEndEq(q.strategy)
portfolio.bFaber.8787518<-userEnv$portfolio.bFaber.8787518
chart.Posn("portfolio.bFaber.8787518", Symbol = stockSymbol)

chart.Posn(q.strategy, Symbol = 'Data')
txns<-getTxns(Portfolio = q.strategy, Symbol = stockSymbol)
# 交易统计
tradestats<-tradeStats(Portfolio = q.strategy, Symbol = stockSymbol)
# 指令簿(order book),最重要的是包含了每一条指令对应的rule是谁
orderbook <- getOrderBook(q.strategy)$bFaber$GTJA

#最大不利偏移率
# chart.ME(Portfolio = q.strategy, Symbol = stockSymbol, type = "MAE", scale = "percent")
#最大有利偏移率
# chart.ME(Portfolio = q.strategy, Symbol = stockSymbol, type = "MFE", scale = "percent")
