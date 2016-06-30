# 技术指标 --------------------------------------------------------------------
png(file = paste(resultPrefix,'TA.png',sep = ''),width=800,height=600)
chartSeries(x = Data, name = 'TA',theme = chartTheme("white"),TA = '
            addSMA(n=5);addSMA(n=10);addVo();
            addTA(ta = ROC(x = Cl(Data),n = PARAM$ROC.INDICATOR.ROC.N),col="red");
            addTA(ta = SMA(x = Cl(ROC(x = Data,n = PARAM$ROC.INDICATOR.ROC.N)),n = PARAM$ROC.INDICATOR.MAROC.N),on=3)')

# addTA(ta = SMA(x = Cl(ROC(x = Data,n = ROC.INDICATOR.ROC.N)),n = 5),on=TA.INDEX)

dev.off()

# 仓位&盈利&回撤 --------------------------------------------------------------------
png(file = paste(resultPrefix,'POSN.png',sep = ''),width=800,height=600)
chart.Posn(q.strategy, Symbol = stockSymbol)
dev.off()

