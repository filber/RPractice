# 时间戳
timestamp<-as.character.Date(Sys.time(),format='%H%M%S')
# 名称前缀
chartPrefix<-paste('Results/',stockSymbol,'_',timestamp,'_',sep = '')

# 技术指标 --------------------------------------------------------------------
png(file = paste(chartPrefix,'TA.png',sep = ''),width=800,height=600)
chartSeries(x = Data, name = 'TA',theme = chartTheme("white"),TA = 'addSMA(n=5);addSMA(n=10);addVo()')
# ROC
addTA(ta = ROC(x = Cl(Data),n = ROC.INDICATOR.ROC.N),col='red')
addTA(ta = SMA(x = Cl(ROC(x = Data,n = ROC.INDICATOR.ROC.N)),n = ROC.INDICATOR.MAROC.N),on=3)
# addTA(ta = SMA(x = Cl(ROC(x = Data,n = ROC.INDICATOR.ROC.N)),n = 5),on=TA.INDEX)
dev.off()

# 仓位变化 --------------------------------------------------------------------
png(file = paste(chartPrefix,'POSN.png',sep = ''),width=800,height=600)
chart.Posn(q.strategy, Symbol = stockSymbol)
dev.off()
