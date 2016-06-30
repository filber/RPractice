
if(is.na(optimizeFlag)) {
  # 交易统计
  tradestats<-tradeStats(Portfolio = q.strategy, Symbol = stockSymbol)
  write.csv(tradestats, file = paste(resultPrefix,'STATS.csv',sep = ''))
  
  # 指令簿
  orderbook<-get.orderbook(portfolio = q.strategy)$DQStrategy$Data
  write.csv(orderbook, file = paste(resultPrefix,'ORDERS.csv',sep = ''))  
} else {
  # 交易统计
  write.csv(paramset.TradeStats, file = paste(resultPrefix,'PARAM_STATS.csv',sep = ''))  
}

# # 模型参数 ---------------------------------------------------------------------
# for(paramIndex in length(PARAM)) {
#   eval(parse("PARAM$ORDER.QTY.BUY"))
#   
#   write(x = PARAM[param],file = paste(resultPrefix,'PARAM.txt',sep = ''),append = TRUE)
# }
# 
# lapply(X = PARAM,FUN = function(x){
#   
#   write(x,file = paste(resultPrefix,'PARAM.txt',sep = ''),append = TRUE)
# })
