# ROC ---------------------------------------------------------------------
png(file = paste(resultPrefix,'ROC.png',sep = ''),width=800,height=600)
chartSeries(x = Data, name = 'ROC',theme = chartTheme("white"),TA = '
            addSMA(n=5);addSMA(n=10);addVo();
            addTA(ta = ROC(x = Cl(Data),n = PARAM$ROC.INDICATOR.ROC.N),col="red");
            addTA(ta = SMA(x = Cl(ROC(x = Data,n = PARAM$ROC.INDICATOR.ROC.N)),n = PARAM$ROC.INDICATOR.MAROC.N),on=3)')
dev.off()

# SAR ---------------------------------------------------------------------
png(file = paste(resultPrefix,'SAR.png',sep = ''),width=800,height=600)
chartSeries(x = Data, name = 'SAR',theme = chartTheme("white"),TA = '
            addSMA(n=5);addSMA(n=10);addVo();
            addSAR(accel = c(PARAM$SAR.INDICATOR.SAR.ACCEL,PARAM$SAR.INDICATOR.SAR.ACCEL.MAX));')
dev.off()

# 仓位&盈利&回撤 --------------------------------------------------------------------
png(file = paste(resultPrefix,'POSN.png',sep = ''),width=800,height=600)
chart.Posn(q.strategy, Symbol = stockSymbol)
dev.off()

