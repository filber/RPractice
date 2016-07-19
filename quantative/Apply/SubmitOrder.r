
# 取得指令簿
orderbook<-get.orderbook(portfolio = q.strategy)$DQStrategy$Data
if(!is.null(orderbook)){
  for(i in 1:nrow(orderbook)){
    logonId<-sprintf("OrderType=LMT;LogonID=%d",logon$Data$LogonID)
    w_wsq_data<-w.wsq(PARAM$STOCK.SYMBOL,"rt_high_limit,rt_low_limit")
    #涨停价格
    RT_HIGH_LIMIT<- w_wsq_data$Data$RT_HIGH_LIMIT
    #跌停价格
    RT_LOW_LIMIT<- w_wsq_data$Data$RT_LOW_LIMIT
    
    order<-orderbook[i]
    Order.Qty<- as.integer(order$Order.Qty)
    Order.Type<-if(Order.Qty>0)'Buy' else 'Sell'
    # 提交订单
    simOrder<-w.torder(PARAM$STOCK.SYMBOL,Order.Type,RT_HIGH_LIMIT,abs(Order.Qty),logonId)
    print('提交订单成功!')
    print(simOrder)
  }
}