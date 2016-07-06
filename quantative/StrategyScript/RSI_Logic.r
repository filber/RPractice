# RSI(相对强弱指标)

# INDICATOR ---------------------------------------------------------------------

#指标1:短期RSI
add.indicator(strategy = q.strategy, name = "RSI",
              arguments = list(price= quote(Cl(Data)),n = PARAM$RSI.INDICATOR.RSI.SHORT.N),
              label = "RSI.SHORT")

#指标2:长期RSI
add.indicator(strategy = q.strategy, name = "RSI",
              arguments = list(price= quote(Cl(Data)),n = PARAM$RSI.INDICATOR.RSI.LONG.N),
              label = "RSI.LONG")

# SIGNAL ------------------------------------------------------------------

#信号1:短期RSI上穿长期RSI
add.signal(q.strategy, name = "sigCrossover",
           arguments = list(columns = c("RSI.SHORT","RSI.LONG"), relationship = "gt"),
           label = "RSI.SHORT.GT.RSI.LONG")

#信号2:短期RSI下穿长期RSI
add.signal(q.strategy, name = "sigCrossover",
           arguments = list(columns = c("RSI.SHORT","RSI.LONG"), relationship = "lt"),
           label = "RSI.SHORT.LT.RSI.LONG")

#信号3:RSI大于X1
add.signal(q.strategy, name = "sigThreshold",
           arguments = list(column = "RSI.SHORT",threshold = PARAM$RSI.SIGNAL.RSI.SHORT.GT.X1,relationship = "gt",cross=TRUE),
           label = "RSI.SHORT.GT.X1")

#信号4:RSI小于X2
add.signal(q.strategy, name = "sigThreshold",
           arguments = list(column = "RSI.SHORT",threshold = PARAM$RSI.SIGNAL.RSI.SHORT.LT.X2,relationship = "lt",cross=TRUE),
           label = "RSI.SHORT.LT.X2")

#信号5:RSI大于X1且发生金叉
add.signal(q.strategy, name = "sigFormula",
           arguments = list(formula = "(RSI.SHORT.GT.X1==1)&(RSI.SHORT.GT.RSI.LONG==1)"),
           label = "RSI.GOLDEN.CROSS")

#信号6:RSI小于X2且发生死叉
add.signal(q.strategy, name = "sigFormula",
           arguments = list(formula = "(RSI.SHORT.LT.X2==1)&(RSI.SHORT.LT.RSI.LONG==1)"),
           label = "RSI.DEATH.CROSS")

#信号7:RSI小于X3
add.signal(q.strategy, name = "sigThreshold",
           arguments = list(column = "RSI.SHORT",threshold = PARAM$RSI.SIGNAL.RSI.SHORT.LT.X3,relationship = "lt",cross=TRUE),
           label = "RSI.SHORT.LT.X3")

#信号8:RSI大于X4
add.signal(q.strategy, name = "sigThreshold",
           arguments = list(column = "RSI.SHORT",threshold = PARAM$RSI.SIGNAL.RSI.SHORT.GT.X4,relationship = "gt",cross=TRUE),
           label = "RSI.SHORT.GT.X4")

# RULE ------------------------------------------------------------------
#规则1:短期RSI大于X1且上穿长期RSI买入
add.rule(q.strategy, name = "ruleSignal",label = "RSI.BUY.GOLDEN.CROSS",
         arguments = list(
           sigcol = "RSI.GOLDEN.CROSS",sigval = TRUE,
           orderqty = PARAM$ORDER.QTY.BUY, ordertype = "market",osFUN="osMaxPos",orderside = "long", pricemethod = "market",portfolio=q.strategy),
         type = "enter")

#规则2:短期RSI小于X2且下穿长期RSI卖出
add.rule(q.strategy, name = "ruleSignal",label = "RSI.SELL.DEATH.CROSS",
         arguments = list(
           sigcol = "RSI.DEATH.CROSS",sigval = TRUE,
           orderqty = PARAM$ORDER.QTY.SELL, ordertype = "market", orderside = "long",osFUN="osMaxPos", pricemethod = "market",portfolio=q.strategy),
         type = "exit")

#规则3:短期RSI小于X3买入
add.rule(q.strategy, name = "ruleSignal",label = "RSI.BUY.LT.X3",
         arguments = list(
           sigcol = "RSI.SHORT.LT.X3",sigval = TRUE,
           orderqty = PARAM$ORDER.QTY.BUY, ordertype = "market",osFUN="osMaxPos",orderside = "long", pricemethod = "market",portfolio=q.strategy),
         type = "enter")

#规则4:短期RSI大于X4卖出
add.rule(q.strategy, name = "ruleSignal",label = "RSI.SELL.GT.X4",
         arguments = list(
           sigcol = "RSI.SHORT.GT.X4",sigval = TRUE,
           orderqty = PARAM$ORDER.QTY.SELL, ordertype = "market", orderside = "long",osFUN="osMaxPos", pricemethod = "market",portfolio=q.strategy),
         type = "exit")

# DISTRIBUTION ------------------------------------------------------------------

#参数1:指标短期RSI的周期
add.distribution(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                 component.type = 'indicator',component.label = 'RSI.SHORT',
                 variable = list(n = PARAM$RSI.DIS.INDICATOR.RSI.SHORT.N),
                 label = 'RSI.DIS.INDICATOR.RSI.SHORT.N')

#参数2:指标长期RSI的周期
add.distribution(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                 component.type = 'indicator',component.label = 'RSI.LONG',
                 variable = list(n = PARAM$RSI.DIS.INDICATOR.RSI.LONG.N),
                 label = 'RSI.DIS.INDICATOR.RSI.LONG.N')

#参数约束1:短期RSI周期小于长期RSI周期
add.distribution.constraint(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                            distribution.label.1 = 'RSI.DIS.INDICATOR.RSI.SHORT.N',
                            distribution.label.2 = 'RSI.DIS.INDICATOR.RSI.LONG.N',
                            operator = '<',label = 'RSI.DIS.CONS.SHORT.LT.LONG')

#参数3:信号X1
add.distribution(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                 component.type = 'signal',component.label = 'RSI.SHORT.GT.X1',
                 variable = list(threshold = PARAM$RSI.DIS.SIGNAL.RSI.SHORT.GT.X1),
                 label = 'RSI.DIS.SIGNAL.RSI.SHORT.GT.X1')

#参数4:信号X2
add.distribution(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                 component.type = 'signal',component.label = 'RSI.SHORT.LT.X2',
                 variable = list(threshold = PARAM$RSI.DIS.SIGNAL.RSI.SHORT.LT.X2),
                 label = 'RSI.DIS.SIGNAL.RSI.SHORT.LT.X2')

#参数5:信号X3
add.distribution(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                 component.type = 'signal',component.label = 'RSI.SHORT.LT.X3',
                 variable = list(threshold = PARAM$RSI.DIS.SIGNAL.RSI.SHORT.LT.X3),
                 label = 'RSI.DIS.SIGNAL.RSI.SHORT.LT.X3')

#参数6:信号X4
add.distribution(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                 component.type = 'signal',component.label = 'RSI.SHORT.GT.X4',
                 variable = list(threshold = PARAM$RSI.DIS.SIGNAL.RSI.SHORT.GT.X4),
                 label = 'RSI.DIS.SIGNAL.RSI.SHORT.GT.X4')

#参数约束2:X4大于X1
add.distribution.constraint(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                            distribution.label.1 = 'RSI.DIS.SIGNAL.RSI.SHORT.GT.X4',
                            distribution.label.2 = 'RSI.DIS.SIGNAL.RSI.SHORT.GT.X1',
                            operator = '>',label = 'RSI.DIS.CONS.X4.GT.X1')

#参数约束3:X1大于X2
add.distribution.constraint(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                            distribution.label.1 = 'RSI.DIS.SIGNAL.RSI.SHORT.GT.X1',
                            distribution.label.2 = 'RSI.DIS.SIGNAL.RSI.SHORT.LT.X2',
                            operator = '>',label = 'RSI.DIS.CONS.X1.GT.X2')

#参数约束3:X2大于X3
add.distribution.constraint(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                            distribution.label.1 = 'RSI.DIS.SIGNAL.RSI.SHORT.LT.X2',
                            distribution.label.2 = 'RSI.DIS.SIGNAL.RSI.SHORT.LT.X3',
                            operator = '>',label = 'RSI.DIS.CONS.X2.GT.X3')
