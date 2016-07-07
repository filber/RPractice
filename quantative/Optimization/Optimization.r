require(doParallel)

#执行参数优化
userEnv<-new.env()

#在主机上创建一个包含4节点的聚簇,每个节点是一个计算单元,通过socket传递表达式并反馈计算结果.
cl <- makePSOCKcluster(names=4)
#在master上对节点进行注册
registerDoParallel(cl)
paramset.out <- apply.paramset(strategy.st = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,audit = userEnv,
                               account.st = q.strategy,portfolio.st = q.strategy,
                               mktdata = Data,nsamples = PARAM$PARAMSET.NSAMPLES)
#停止聚簇
stopCluster(cl)

paramset.TradeStats <- userEnv$tradeStats