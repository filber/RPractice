#执行参数优化
userEnv<-new.env()

paramset.out <- apply.paramset(strategy.st = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,audit = userEnv,
                               account.st = q.strategy,portfolio.st = q.strategy,
                               mktdata = Data,nsamples = PARAM$PARAMSET.NSAMPLES)

paramset.TradeStats <- userEnv$tradeStats