# SAR(停止转向指标)

# INDICATOR ---------------------------------------------------------------------
ModifySAR<-function(HL, accel,accel.max){
  SAR(HL,c(accel,accel.max))
}

#指标1:SAR
add.indicator(strategy = q.strategy, name = "ModifySAR",
              arguments = list(HL = quote(Data),
                              accel = PARAM$SAR.INDICATOR.SAR.ACCEL,
                              accel.max = PARAM$SAR.INDICATOR.SAR.ACCEL.MAX),
              label = "SAR")

# SIGNAL ------------------------------------------------------------------
#信号1:最低价跌破SAR
add.signal(q.strategy, name = "sigCrossover",
           arguments = list(columns = c("Close","SAR"), relationship = "lt"),
           label = "LOW.LT.SAR")

#信号2:最高价上穿SAR
add.signal(q.strategy, name = "sigCrossover",
           arguments = list(columns = c("Close","SAR"), relationship = "gt"),
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
                 component.type = 'indicator',component.label = 'SAR',
                 variable = list(accel = PARAM$SAR.DIS.SAR.ACCEL),
                 label = 'SAR.DIS.INDICATOR.SAR.ACCEL')
#参数2:指标SAR的加速因子最大值
add.distribution(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                 component.type = 'indicator',component.label = 'SAR',
                 variable = list(accel.max=PARAM$SAR.DIS.SAR.ACCEL.MAX),
                 label = 'SAR.DIS.INDICATOR.SAR.ACCEL.MAX')

#参数约束1:加速因子<加速因子最大值
add.distribution.constraint(strategy = q.strategy,paramset.label = PARAM$PARAMSET.LABEL,
                            distribution.label.1 = 'SAR.DIS.INDICATOR.SAR.ACCEL',
                            distribution.label.2 = 'SAR.DIS.INDICATOR.SAR.ACCEL.MAX',
                            operator = '<',label = 'SAR.DIS.CONS.ACCEL.LT.MAX')