require(quantstrat)

#金融产品初始化
stockSymbol<-'GTJA'
currency("RMB")
stock(stockSymbol, currency = "RMB", multiplier = 1)
# 设定时区
Sys.setenv(TZ = "UTC")

GTJA <- getSymbols.yahoo("601211.SS", from = "2016-01-02",auto.assign = FALSE)
GTJA_Weekly <- to.weekly(x = GTJA,indexAt="endof")
# GTJA_Weekly$SMA4w <- SMA(Cl(GTJA_Weekly), 4)

q.strategy <- "bFaber"
#初始化一个投资组合:名称,资产标识,初始时间(位置)
if (!exists('.blotter')) .blotter <- new.env()
initPortf(q.strategy, stockSymbol, initDate = "2016-01-01")
#初始化一个账户
initAcct(q.strategy, portfolios = q.strategy, initDate = "2016-01-01", initEq = 1e+06)
getPortfolio(Portfolio = q.strategy)
getAccount(Account = q.strategy)

# 初始化指令集和策略
initOrders(portfolio = q.strategy, initDate = "2016-01-01")
strategy(q.strategy, store = TRUE)
ls(all = T) #quantstrat创建了.strategy环境
# 显示策略的内容(名称,资产,指标,信号,规则,约束等)
strategy <- getStrategy(q.strategy)
summary(strategy)

#------一下是quantstrat的精华----------
# 加入一个指标,4周均线
#name为指标的函数名称,arguments中为要传递给指标函数的参数
add.indicator(strategy = q.strategy, name = "SMA",
              #此处使用quote是为了引用expression,比较精髓
              arguments = list(x = quote(Cl(GTJA_Weekly)),n = 4),
              label = "SMA4W")
# 加入信号:向上交叉4周线
add.signal(q.strategy, name = "sigCrossover",
              arguments = list(columns = c("Close","SMA4W"), relationship = "gt"),
              label = "Cl.gt.SMA")
# 加入信号:向下交叉4周线
add.signal(q.strategy, name = "sigCrossover",
              arguments = list(columns = c("Close","SMA4W"), relationship = "lt"),
              label = "Cl.lt.SMA")
# 加入买入规则
add.rule(q.strategy, name = "ruleSignal",label = "ruleSignalBuy",
         arguments = list(
                          #指定需要检查信号名称和信号值
                          sigcol = "Cl.gt.SMA",sigval = TRUE,
                          # 数量为900股
                          orderqty = 900, ordertype = "market", orderside = "long", pricemethod = "market"),
         type = "enter",#方向为买入
         #path dependent规则即每当数据集发生变化则计算.
         #path.dep为False时,在indcator&signal之后,在path-dependent规则之前进行计算.
         path.dep = TRUE)
# 加入卖出规则
add.rule(q.strategy, name = "ruleSignal",label = "ruleSignalSell",
         arguments = list(
                          sigcol = "Cl.lt.SMA",sigval = TRUE,
                          orderqty = "all", ordertype = "market", orderside = "long",pricemethod = "market"),
         type = "exit", path.dep = TRUE)


#使用这个策略
out <- applyStrategy(strategy = q.strategy, portfolios = q.strategy,mktdata = GTJA_Weekly)

updatePortf(q.strategy)
updateAcct(q.strategy)
updateEndEq(q.strategy)

chart_Series(x = GTJA_Weekly, name = "国泰君安_周K", TA = "add_SMA(n=4,col=4)")
chart.Posn(q.strategy, Symbol = stockSymbol)
getTxns(Portfolio = q.strategy, Symbol = stockSymbol)
# 交易统计
tradestats<-tradeStats(Portfolio = q.strategy, Symbol = stockSymbol)
# 指令簿(order book),最重要的是包含了每一条指令对应的rule是谁
orderbook <- getOrderBook(q.strategy)$bFaber$GTJA

#最大不利偏移率
chart.ME(Portfolio = q.strategy, Symbol = stockSymbol, type = "MAE", scale = "percent")
#最大有利偏移率
chart.ME(Portfolio = q.strategy, Symbol = stockSymbol, type = "MFE", scale = "percent")
