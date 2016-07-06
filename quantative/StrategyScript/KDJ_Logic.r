# KDJ(随机指标指标)

# INDICATOR ---------------------------------------------------------------------

#指标1:KDJ
add.indicator(strategy = q.strategy, name = "stoch",
              arguments = list(HLC= HLC(Data),
              nFastK = PARAM$KDJ.INDICATOR.KDJ.FASTK.N,
              nFastD = PARAM$KDJ.INDICATOR.KDJ.FASTD.N,
              nSlowD = PARAM$KDJ.INDICATOR.KDJ.SLOWD.N,maType="EMA"),
              label = "KDJ")

# SIGNAL ------------------------------------------------------------------
#信号1:K值上穿D值
add.signal(q.strategy, name = "sigCrossover",
           arguments = list(columns = c("fastD","slowD"), relationship = "gt"),
           label = "K.GT.D")

#信号2:K值下穿D值
add.signal(q.strategy, name = "sigCrossover",
           arguments = list(columns = c("fastD","slowD"), relationship = "lt"),
           label = "K.LT.D")

#信号3:K值大于X1
add.signal(q.strategy, name = "sigThreshold",
           arguments = list(column = "fastD",threshold = PARAM$KDJ.SIGNAL.K.GT.X1,relationship = "gt"),
           label = "K.GT.X1")

#信号4:K小于X2
add.signal(q.strategy, name = "sigThreshold",
           arguments = list(column = "fastD",threshold = PARAM$KDJ.SIGNAL.K.LT.X2,relationship = "lt"),
           label = "K.LT.X2")

#信号5:KDJ发生高位死叉
add.signal(q.strategy, name = "sigFormula",
           arguments = list(formula = "(K.GT.X1==1)&(K.LT.D==1)"),
           label = "KDJ.DEATH.CROSS")

#信号6:KDJ发生低位金叉
add.signal(q.strategy, name = "sigFormula",
           arguments = list(formula = "(K.LT.X2==1)&(K.GT.D==1)"),
           label = "KDJ.GOLDEN.CROSS")

# RULE ------------------------------------------------------------------
#规则1:发生高位死叉则卖出
add.rule(q.strategy, name = "ruleSignal",label = "KDJ.SELL.DEATH.CROSS",
         arguments = list(
           sigcol = "KDJ.DEATH.CROSS",sigval = TRUE,
           orderqty = PARAM$ORDER.QTY.SELL, ordertype = "market", orderside = "long",osFUN="osMaxPos", pricemethod = "market",portfolio=q.strategy),
         type = "exit")

#规则2:发生低位金叉则买入
add.rule(q.strategy, name = "ruleSignal",label = "KDJ.BUY.GOLDEN.CROSS",
         arguments = list(
           sigcol = "KDJ.GOLDEN.CROSS",sigval = TRUE,
           orderqty = PARAM$ORDER.QTY.BUY, ordertype = "market",osFUN="osMaxPos",orderside = "long", pricemethod = "market",portfolio=q.strategy),
         type = "enter")

# DISTRIBUTION ------------------------------------------------------------------

#参数1:指标KDJ的FASTK的周期（J值）
add.distribution(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                 component.type = 'indicator',component.label = 'KDJ',
                 variable = list(nFastK = PARAM$KDJ.DIS.INDICATOR.KDJ.FASTK.N),
                 label = 'KDJ.DIS.INDICATOR.KDJ.FASTK.N')

#参数2:指标KDJ的FASTD的周期（K值）
add.distribution(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                 component.type = 'indicator',component.label = 'KDJ',
                 variable = list(nFastD = PARAM$KDJ.DIS.INDICATOR.KDJ.FASTD.N),
                 label = 'KDJ.DIS.INDICATOR.KDJ.FASTD.N')

#参数3:指标KDJ的SLOWD的周期（D值）
add.distribution(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                 component.type = 'indicator',component.label = 'KDJ',
                 variable = list(nSlowD = PARAM$KDJ.DIS.INDICATOR.KDJ.SLOWD.N),
                 label = 'KDJ.DIS.INDICATOR.KDJ.SLOWD.N')

#参数4:信号KDJ的上限值
add.distribution(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                 component.type = 'signal',component.label = 'K.GT.X1',
                 variable = list(threshold = PARAM$KDJ.DIS.SIGNAL.K.GT.X1),
                 label = 'KDJ.DIS.SIGNAL.K.GT.X1')

#参数5:信号KDJ的下限值
add.distribution(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                 component.type = 'signal',component.label = 'K.LT.X2',
                 variable = list(threshold = PARAM$KDJ.DIS.SIGNAL.K.LT.X2),
                 label = 'KDJ.DIS.SIGNAL.K.LT.X2')

#参数约束1:上限值>下限值
add.distribution.constraint(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                            distribution.label.1 = 'KDJ.DIS.SIGNAL.K.GT.X1',
                            distribution.label.2 = 'KDJ.DIS.SIGNAL.K.LT.X2',
                            operator = '>',label = 'KDJ.DIS.CONS.X1.GT.X2')