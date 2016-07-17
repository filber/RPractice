#!/usr/bin/Rscript --vanilla
#
# Jan Humme (@opentrades) - April 2013
#
# Tested and found to work correctly using blotter r1457
#
# After Jaekle & Tamasini: A new approach to system development and portfolio optimisation (ISBN 978-1-905641-79-6)
#
# Paragraph 3.7 walk forward analysis

require(quantstrat)
.blotter<-new.env()
.strategy<-new.env()
source(paste0(path.package("quantstrat"),"/demo/luxor.include.R"))
source(paste0(path.package("quantstrat"),"/demo/luxor.getSymbols.R"))
# load(file = "Data/GTJA_Minutes.RData");
# GBPUSD =Data
# GBPUSD = to.minutes30(GBPUSD)
# GBPUSD = align.time(GBPUSD, 1800)

source(paste0(path.package("quantstrat"),"/demo/luxor.5.strategy.ordersets.R"))

### foreach and doMC

require(foreach)
# require(doMC)
# registerDoMC(cores=8)

# require(doParallel)
# cl <- makePSOCKcluster(names=4)
# registerDoParallel(cl)

### robustbase and PerformanceAnalytics

if (!requireNamespace("robustbase", quietly=TRUE))
  stop("package 'robustbase' required, but not installed")
if (!requireNamespace("PerformanceAnalytics", quietly=TRUE))
  stop("package 'PerformanceAnalytics' required, but not installed")

### blotter

initPortf(portfolio.st, symbols='GBPUSD', currency='USD')
initAcct(account.st, portfolios=portfolio.st, currency='USD', initEq=100000)

### quantstrat

initOrders(portfolio.st)

load.strategy(strategy.st)

enable.rule(strategy.st, 'chain', 'StopLoss')
#enable.rule(strategy.st, 'chain', 'StopTrailing')
enable.rule(strategy.st, 'chain', 'TakeProfit')

addPosLimit(
            portfolio=portfolio.st,
            symbol='GBPUSD',
            timestamp=startDate,
            maxpos=.orderqty)

### objective function

ess <- function(account.st, portfolio.st)
{
    require(robustbase, quietly=TRUE)
    require(PerformanceAnalytics, quietly=TRUE)

    portfolios.st <- ls(pos=.blotter, pattern=paste('portfolio', portfolio.st, '[0-9]*',sep='.'))
    
    #通过初始资金和投资组合来计算最终的收益.
    pr <- PortfReturns(Account = account.st, Portfolios=portfolios.st)

    #计算单一资产的期望损失(Expected Shortfall)或称为CVaR(Conditional Value at Risk)
    my.es <- ES(R=pr, clean='boudt')

    return(my.es)
}

my.obj.func <- function(x)
{
    
    #return(max(x$tradeStats$Max.Drawdown) == x$tradeStats$Max.Drawdown)
    #return(max(x$tradeStats$Net.Trading.PL) == x$tradeStats$Net.Trading.PL)
    
    #obj.func的参数x其实是apply.paramset的返回值.
    #而在apply.paramset中有下述几句:
    #1. r$user.func <- do.call(user.func, user.args)#调用user.func
    #2. results$user.func <- rbind(results$user.func, cbind(r$param.combo, r$user.func))#将结果存储于result并返回
    #所以此处优选出来的其实就是资产GBPUSD中每日价值最多的那一项参数组合
    return(max(x$user.func$GBPUSD.DailyEndEq) == x$user.func$GBPUSD.DailyEndEq)
}

### walk.forward
.audit<-NULL
r <- modified.walk.forward(strategy.st,
                  paramset.label='WFA',
                  portfolio.st=portfolio.st,
                  account.st=account.st,
                  period='days',
                  k.training=3,
                  k.testing=1,
                  obj.func=my.obj.func,
                  #quote中引用的变量在walk.forward函数的上下文可以被访问到
                  obj.args=list(x=quote(result$apply.paramset)),
                  
                  #user.func与user.args均属于传给apply.paramset的额外参数
                  user.func=ess,#在运算完每个param.combo结束时会被调用
                  user.args=list('account.st'=account.st, 'portfolio.st'=portfolio.st),
                  audit.prefix='wfa',
                  anchored=FALSE,
                  verbose=TRUE)

### analyse
#停止聚簇
# stopCluster(cl)

pdf(paste('GBPUSD', .from, .to, 'pdf', sep='.'))
chart.Posn(portfolio.st)
dev.off()

ts <- tradeStats(portfolio.st)
save(ts, file=paste('GBPUSD', .from, .to, 'RData', sep='.'))

