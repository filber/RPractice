
if(PARAM$FLAG=='apply') {
  # 交易统计
  tradestats<-tradeStats(Portfolio = q.strategy, Symbol = stockSymbol)
  write.csv(tradestats, file = paste(resultPrefix,'STATS.csv',sep = ''))
  
  # 指令簿
  orderbook<-get.orderbook(portfolio = q.strategy)$DQStrategy$Data
  write.csv(orderbook, file = paste(resultPrefix,'ORDERS.csv',sep = ''))  
} else if(PARAM$FLAG=='optimize') {
  # 交易统计
  write.csv(paramset.TradeStats, file = paste(resultPrefix,'PARAM_STATS.csv',sep = ''))  
}

# 模型参数 ---------------------------------------------------------------------
for(i in 1:length(PARAM)) {
  write(names(PARAM[i]),paste(resultPrefix,'PARAM.txt',sep = ''), append=TRUE)
  lapply(PARAM[i],write,paste(resultPrefix,'PARAM.txt',sep = ''), append=TRUE)
}