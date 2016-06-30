# 最终收益 vs 最大回撤 --------------------------------------------------------------------
png(file = paste(resultPrefix,'EndEqty_MaxDrdn.png',sep = ''),width=400,height=400)
plot(paramset.TradeStats$End.Equity,paramset.TradeStats$Max.Drawdown)
dev.off()

# 资产最多 vs 资产最少 --------------------------------------------------------------------
png(file = paste(resultPrefix,'MaxEqty_MinEqty.png',sep = ''),width=400,height=400)
plot(paramset.TradeStats$Max.Equity,paramset.TradeStats$Min.Equity)
dev.off()