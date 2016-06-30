# ROC(波动率)

# INDICATOR ---------------------------------------------------------------------

#指标1:收盘价ROC
add.indicator(strategy = q.strategy, name = "ROC",
              arguments = list(x = quote(Cl(Data)),n = PARAM$ROC.INDICATOR.ROC.N),
              label = "ROC")

#指标2:收盘价MAROC
add.indicator(strategy = q.strategy, name = "SMA",
              arguments = list(x = quote(ROC(Cl(Data),getStrategy(q.strategy)$indicators$ROC$arguments$n)),
                               n = PARAM$ROC.INDICATOR.MAROC.N),
              label = "MAROC")

# SIGNAL ------------------------------------------------------------------

#信号1:ROC上穿MAROC
add.signal(q.strategy, name = "sigCrossover",
           arguments = list(columns = c("ROC","MAROC"), relationship = "gt"),
           label = "ROC.GT.MAROC")

#信号2:ROC下穿MAROC
add.signal(q.strategy, name = "sigCrossover",
           arguments = list(columns = c("ROC","MAROC"), relationship = "lt"),
           label = "ROC.LT.MAROC")

#信号3:ROC大于压力线
add.signal(q.strategy, name = "sigThreshold",
           arguments = list(column = "Close.ROC",threshold = PARAM$ROC.SIGNAL.ROC.GT.HIGH,relationship = "gt"),
           label = "ROC.GT.HIGH")

#信号4:ROC小于支撑线
add.signal(q.strategy, name = "sigThreshold",
           arguments = list(column = "Close.ROC",threshold = PARAM$ROC.SIGNAL.ROC.LT.LOW,relationship = "lt"),
           label = "ROC.LT.LOW")

#信号5:ROC发生高位死叉
add.signal(q.strategy, name = "sigFormula",
           arguments = list(formula = "(ROC.LT.MAROC==1)&(ROC.GT.HIGH==1)"),
           label = "ROC.DEATH.CROSS")

#信号6:ROC发生低位金叉
add.signal(q.strategy, name = "sigFormula",
           arguments = list(formula = "(ROC.GT.MAROC==1)&(ROC.LT.LOW==1)"),
           label = "ROC.GOLDEN.CROSS")

# RULE ------------------------------------------------------------------

#规则1:低位金叉买入
add.rule(q.strategy, name = "ruleSignal",label = "ROC.BUY.GOLDEN.CROSS",
         arguments = list(
           sigcol = "ROC.GOLDEN.CROSS",sigval = TRUE,
           orderqty = PARAM$ORDER.QTY.BUY, ordertype = "market",osFUN="osMaxPos",orderside = "long", pricemethod = "market",portfolio=q.strategy),
         type = "enter")

#规则2:高位死叉卖出
add.rule(q.strategy, name = "ruleSignal",label = "ROC.BUY.DEATH.CROSS",
         arguments = list(
           sigcol = "ROC.DEATH.CROSS",sigval = TRUE,
           orderqty = PARAM$ORDER.QTY.SELL, ordertype = "market", orderside = "long",osFUN="osMaxPos", pricemethod = "market",portfolio=q.strategy),
         type = "exit")

# DISTRIBUTION ------------------------------------------------------------------

#参数1:指标ROC的周期
add.distribution(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                 component.type = 'indicator',component.label = 'ROC',
                 variable = list(n = PARAM$ROC.DIS.INDICATOR.ROC.N),
                 label = 'ROC.DIS.INDICATOR.ROC.N')

#参数2:指标MAROC的周期
add.distribution(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                 component.type = 'indicator',component.label = 'MAROC',
                 variable = list(n = PARAM$ROC.DIS.INDICATOR.ROC.N),
                 label = 'ROC.DIS.INDICATOR.MAROC.N')

#参数3:信号ROC上限值
add.distribution(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                 component.type = 'signal',component.label = 'ROC.GT.HIGH',
                 variable = list(threshold = PARAM$ROC.DIS.SIGNAL.ROC.GT.HIGH),
                 label = 'ROC.DIS.SIGNAL.ROC.GT.HIGH')

#参数4:信号ROC下限值
add.distribution(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                 component.type = 'signal',component.label = 'ROC.LT.LOW',
                 variable = list(threshold = PARAM$ROC.DIS.SIGNAL.ROC.LT.LOW),
                 label = 'ROC.DIS.SIGNAL.ROC.LT.LOW')

#参数约束1:上限值>下限值
add.distribution.constraint(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                            distribution.label.1 = 'ROC.DIS.SIGNAL.ROC.GT.HIGH',
                            distribution.label.2 = 'ROC.DIS.SIGNAL.ROC.LT.LOW',
                            operator = '>',label = 'ROC.DIS.CONS.HIGH.GT.LOW')