require(blotter)

#------1.初始化------
#设立时区
Sys.setenv(TZ = "UTC")
#初始化现金
currency(primary_id = "RMB")
#初始化股票
stock("GTJA", currency = "RMB", multiplier = 1)
#设置 .instrument环境
ls(envir = FinancialInstrument:::.instrument)
#验证是否初始化现金成功
get("RMB", envir = FinancialInstrument:::.instrument)
#验证是否初始化股票成功
get("GTJA", envir = FinancialInstrument:::.instrument)

#------2.准备数据------
#取得股票的原始数据(TODO:要加工为从Mongo取得数据)
GTJA <- getSymbols.yahoo("601211.SS", from = "2016-01-02",auto.assign = FALSE)
#转化为合适的周期,可以使用.
GTJA_Weekly <- to.weekly(x = GTJA,indexAt="endof")

#设置四周的移动平均值
GTJA_Weekly$SMA4w <- SMA(Cl(GTJA_Weekly), 4)
#绘制数据
chart_Series(x = GTJA_Weekly, name = "国泰君安_周K", TA = "add_SMA(n=4,col=4)")

#------3.创建组合和账户------
b.strategy <- "bFaber"
#初始化一个投资组合:名称,资产标识,初始时间(位置)
if (!exists('.blotter')) .blotter <- new.env()
initPortf(b.strategy, "GTJA", initDate = "2016-01-01")
#初始化一个账户
initAcct(b.strategy, portfolios = b.strategy, initDate = "2016-01-01", initEq = 1e+06)
getPortfolio(Portfolio = b.strategy)
getAccount(Account = b.strategy)

#------4.交易规则的实现------
#在这个过程中实现组合和账户的更新
for( i in 1:nrow(GTJA_Weekly))
{
  CurrentDate <- time(GTJA_Weekly)[i]#对日期更新
  equity<-getEndEq(b.strategy, CurrentDate)#取得Acct中最新的值
  ClosePrice <- as.numeric(Cl(GTJA_Weekly[i,]))#取得当日收盘价
  Posn <- getPosQty(b.strategy, Symbol='GTJA', Date=CurrentDate)#取得当日持有股票数
  UnitSize <-as.numeric(trunc(equity/ClosePrice))#如果全仓则需要买入的股数
  MA <- as.numeric(GTJA_Weekly[i,'SMA4w'])
  if(!is.na(MA)) #如果移动均线开始
  {
    #没有头寸,测试是否买入
    if( Posn == 0 ) {
      if( ClosePrice > MA ) {#Faber买入信号:收盘价大于均线
        #全仓买入
        addTxn(b.strategy, Symbol='GTJA', TxnDate=CurrentDate,
               TxnPrice=ClosePrice, TxnQty = UnitSize , TxnFees=0)
      }
    }
    #有头寸，检测是否退出
    else {
      if( ClosePrice < MA ) {#Faber卖出信号:收盘价小于均线
        #全仓卖出
        addTxn(b.strategy, Symbol='GTJA', TxnDate=CurrentDate,
               TxnPrice=ClosePrice, TxnQty = -Posn , TxnFees=0)
      }
    }
  }
  #计算盈亏并更新
  updatePortf(b.strategy, Dates = CurrentDate)
  updateAcct(b.strategy, Dates = CurrentDate)
  updateEndEq(b.strategy, Dates = CurrentDate)
}

#------5.展示组合的表现------
#取得交易明细
txns<-getTxns(Portfolio = b.strategy, Symbol = "GTJA")
#计算投资组合的统计信息(收益率,回撤等)
tstats <- tradeStats(Portfolio = b.strategy, Symbol = "GTJA")
rets<-PortfReturns(Account = b.strategy)
#查看总体累计,日收益和日回撤
charts.PerformanceSummary(rets, colorset = redfocus)
#年化回报
Return.annualized(R = rets)
#年化的夏普比
SharpeRatio.annualized(R = rets)

myTheme <- chart_theme()
myTheme$col$dn.col <- "green"
myTheme$col$up.col <- "red"
myTheme$col$dn.border <- "grey"
myTheme$col$up.border <- "grey"
chart.Posn(b.strategy, Symbol = "GTJA", Dates = "2008::",theme = myTheme,TA = "add_SMA(n=4,col=4)")
