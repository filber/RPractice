library(quantmod)

gtja<-getSymbols.yahoo(Symbols = "601211.SS",from = "2016-04-01",env = parent.frame(),auto.assign=FALSE)
# chartSeries(gtja,theme = 'white')

#取得拆股数据
gtja_splits<-getSplits(Symbol = '601211.SS',from = "2016-01-02",auto.assign = FALSE)
#取得分红数据
gtja_dividends<-getDividends(Symbol = '601211.SS',from = "2016-01-02",auto.assign = FALSE)

adj_gtja <- adjustOHLC(x = gtja,symbol.name = "601211.SS")

Theme.white <- chartTheme("white")
Theme.white$bg.col <- "white"
Theme.white$dn.col <- "green" #下跌为绿
Theme.white$up.col <- "red" #上涨为红
Theme.white$border <- "lightgray"


#TA中可以包含多个Expression.
# chartSeries(adj_gtja,theme = Theme.white, TA = 'addSMA(n=3,col="blue");addSMA(n=8,col="black");addMACD();addVo()')



m<-specifyModel(Next(OpCl(gtja)) ~ Lag(OpHi(gtja)))
#training.per为训练的起始时间和结束时间,结束日期如果设置得过近好像会报错
m.built<-buildModel(x = m,method = "lm",training.per = c('2016-04-01','2016-06-14'))
# modelData(x = modelBuilt)

modelResult<-tradeModel(x = m.built)
#结果汇总
modelResult$model
#收益
modelResult$return
#交易信号吗?
modelResult$signal
