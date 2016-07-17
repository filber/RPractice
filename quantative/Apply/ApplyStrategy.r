
#应用策略进行模拟
out <- applyStrategy(strategy = q.strategy, portfolios = q.strategy,mktdata = Data)
#更新投资组合
updatePortf(q.strategy)
#更新账号
updateAcct(q.strategy)
#更新资产
updateEndEq(q.strategy)