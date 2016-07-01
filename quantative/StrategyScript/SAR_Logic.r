# SAR(停止转向指标)

# INDICATOR ---------------------------------------------------------------------

#指标1:SAR
add.indicator(strategy = q.strategy, name = "SAR",
              arguments = list(HL = quote(Data),
                              accel = c(PARAM$SAR.INDICATOR.SAR.ACCEL,PARAM$SAR.INDICATOR.SAR.ACCEL.MAX)),
              label = "SAR")

# SIGNAL ------------------------------------------------------------------
#信号1:最低价跌破SAR
add.signal(q.strategy, name = "sigCrossover",
           arguments = list(columns = c("Low","SAR"), relationship = "lt"),
           label = "LOW.LT.SAR")

#信号2:最高价上穿SAR
add.signal(q.strategy, name = "sigCrossover",
           arguments = list(columns = c("High","SAR"), relationship = "gt"),
           label = "HIGH.GT.SAR")

# RULE ------------------------------------------------------------------
#规则1:最低价跌破SAR则卖出
add.rule(q.strategy, name = "ruleSignal",label = "LOW.LT.SAR.SELL",
         arguments = list(
           sigcol = "LOW.LT.SAR",sigval = TRUE,
           orderqty = PARAM$ORDER.QTY.SELL, ordertype = "market", orderside = "long",osFUN="osMaxPos", pricemethod = "market",portfolio=q.strategy),
         type = "exit")

#规则2:最高价上穿SAR则买入
add.rule(q.strategy, name = "ruleSignal",label = "HIGH.GT.SAR.BUY",
         arguments = list(
           sigcol = "HIGH.GT.SAR",sigval = TRUE,
           orderqty = PARAM$ORDER.QTY.BUY, ordertype = "market",osFUN="osMaxPos",orderside = "long", pricemethod = "market",portfolio=q.strategy),
         type = "enter")


# DISTRIBUTION ------------------------------------------------------------------

#参数1:指标SAR的加速因子
add.distribution(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                 component.type = 'indicator',component.label = 'ROC',
                 variable = list(n = PARAM$ROC.DIS.INDICATOR.ROC.N),
                 label = 'ROC.DIS.INDICATOR.ROC.N')
