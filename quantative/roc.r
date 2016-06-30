require(quantstrat)

addTA(ta = ROC(x = Cl(GTJA),n = 15),col='red')
addTA(ta = SMA(x = Cl(ROC(x = GTJA,n = 15)),n = 10),on=3)

#策略参数值
ROC_Period<-14
MAROC_Period<-10
ROC_First_High_Limit<-0.003
ROC_Second_High_Limit<-0.013
ROC_First_Low_Limit<-(-0.008)
ROC_Second_Low_Limit<-(-0.014)

#指标1:收盘价ROC
add.indicator(strategy = q.strategy, name = "ROC",
              arguments = list(x = quote(Cl(GTJA)),n = ROC_Period),
              label = "ROC")

#指标2:收盘价MAROC
add.indicator(strategy = q.strategy, name = "SMA",
              arguments = list(x = quote(ROC(Cl(GTJA),getStrategy(q.strategy)$indicators$ROC$arguments$n)),
                               n = MAROC_Period),
              label = "MAROC")


#信号1:ROC上穿MAROC
add.signal(q.strategy, name = "sigCrossover",
           arguments = list(columns = c("ROC","MAROC"), relationship = "gt"),
           label = "ROC.gt.MAROC")

#信号2:ROC下穿MAROC
add.signal(q.strategy, name = "sigCrossover",
           arguments = list(columns = c("ROC","MAROC"), relationship = "lt"),
           label = "ROC.lt.MAROC")

#信号3:ROC上穿第一道压力线
add.signal(q.strategy, name = "sigThreshold",
           arguments = list(column = "Close.ROC",threshold = ROC_First_High_Limit,relationship = "gt"),
           label = "ROC.gt.first")

#信号4:ROC下破第一道支撑线
add.signal(q.strategy, name = "sigThreshold",
           arguments = list(column = "Close.ROC",threshold = ROC_First_Low_Limit,relationship = "lt"),
           label = "ROC.lt.first")

#信号5:ROC大于上限
add.signal(q.strategy, name = "sigThreshold",
           arguments = list(column = "Close.ROC",threshold = ROC_Second_High_Limit,relationship = "gt"),
           label = "ROC.gt.up")

#信号6:ROC小于下限
add.signal(q.strategy, name = "sigThreshold",
           arguments = list(column = "Close.ROC",threshold = ROC_Second_Low_Limit,relationship = "lt"),
           label = "ROC.lt.down")

#信号7:ROC在第一道和第二道压力线之间发生死叉
add.signal(q.strategy, name = "sigFormula",
           arguments = list(formula = "(ROC.lt.MAROC==1)&(ROC.gt.first==1)"),
           label = "ROC.first.death")

#信号8:ROC在第一道和第二道支撑线之间发生金叉
add.signal(q.strategy, name = "sigFormula",
           arguments = list(formula = "(ROC.gt.MAROC==1)&(ROC.lt.first==1)"),
           label = "ROC.first.golden")

#信号9:ROC发生高位死叉
add.signal(q.strategy, name = "sigFormula",
           arguments = list(formula = "(ROC.lt.MAROC==1)&(ROC.gt.up==1)"),
           label = "ROC.up.death")

#信号10:ROC发生低位金叉
add.signal(q.strategy, name = "sigFormula",
           arguments = list(formula = "(ROC.gt.MAROC==1)&(ROC.lt.down==1)"),
           label = "ROC.down.golden")

#规则1:低位金叉买入
add.rule(q.strategy, name = "ruleSignal",label = "ruleROCGoldenCross",
         arguments = list(
            sigcol = "ROC.down.golden",sigval = TRUE,
            orderqty = 500, ordertype = "market",osFUN="osMaxPos",orderside = "long", pricemethod = "market",portfolio=q.strategy),
         type = "enter")
#规则2:高位死叉卖出
add.rule(q.strategy, name = "ruleSignal",label = "ruleROCDeathCross",
         arguments = list(
           sigcol = "ROC.up.death",sigval = TRUE,
           orderqty = -500, ordertype = "market", orderside = "long",osFUN="osMaxPos", pricemethod = "market",portfolio=q.strategy),
         type = "exit")
#规则3:ROC在第一道和第二道支撑线之间发生金叉买进
add.rule(q.strategy, name = "ruleSignal",label = "ruleFirstGolden",
         arguments = list(
           sigcol = "ROC.first.golden",sigval = TRUE,
           orderqty = 500, ordertype = "market",orderside = "long",osFUN="osMaxPos",pricemethod = "market",portfolio=q.strategy),
         type = "enter")
#规则4:ROC在第一道和第二道压力线之间发生死叉卖出
add.rule(q.strategy, name = "ruleSignal",label = "ruleFirstDeath",
         arguments = list(
           sigcol = "ROC.first.death",sigval = TRUE,
           orderqty = -500, ordertype = "market", orderside = "long",osFUN="osMaxPos", pricemethod = "market",portfolio=q.strategy),
         type = "exit")


ROC_Period<-3:15
MAROC_Period<-2:10
ROC_High_Limit<-seq(from = 0,to = 0.02,by = 0.001)
ROC_Low_Limit<-seq(from = 0,to = -0.02,by = -0.001)

#参数1:指标1收盘价ROC的周期
add.distribution(strategy = q.strategy,paramset.label = 'ROC',
                 component.type = 'indicator',component.label = 'ROC',
                 variable = list(n = ROC_Period),
                 label = 'ROC_Period')
#参数2:指标2收盘价MAROC的周期
add.distribution(strategy = q.strategy,paramset.label = 'ROC',
                 component.type = 'indicator',component.label = 'MAROC',
                 variable = list(n = MAROC_Period),
                 label = 'MAROC_Period')
#参数3:信号5ROC上限值
add.distribution(strategy = q.strategy,paramset.label = 'ROC',
                 component.type = 'signal',component.label = 'ROC.gt.up',
                 variable = list(threshold = ROC_High_Limit),
                 label = 'ROC_High_Limit')
#参数4:信号6ROC下限值
add.distribution(strategy = q.strategy,paramset.label = 'ROC',
                 component.type = 'signal',component.label = 'ROC.lt.down',
                 variable = list(threshold = ROC_Low_Limit),
                 label = 'ROC_Low_Limit')
#参数5:信号5ROC第一道压力线
add.distribution(strategy = q.strategy,paramset.label = 'ROC',
                 component.type = 'signal',component.label = 'ROC.gt.first',
                 variable = list(threshold = ROC_High_Limit),
                 label = 'ROC_FIRST_High_Limit')
#参数6:信号6ROC第一道支撑线
add.distribution(strategy = q.strategy,paramset.label = 'ROC',
                 component.type = 'signal',component.label = 'ROC.lt.first',
                 variable = list(threshold = ROC_Low_Limit),
                 label = 'ROC_FIRST_Low_Limit')
#参数约束1:上限值>下限值
add.distribution.constraint(strategy = q.strategy,paramset.label = 'ROC',
               distribution.label.1 = 'ROC_High_Limit',
               distribution.label.2 = 'ROC_Low_Limit',
               operator = '>',label = 'ROC_High_Low_Constraint')
#参数约束2:第一道压力线>第一道支撑线
add.distribution.constraint(strategy = q.strategy,paramset.label = 'ROC',
                            distribution.label.1 = 'ROC_FIRST_High_Limit',
                            distribution.label.2 = 'ROC_FIRST_Low_Limit',
                            operator = '>',label = 'ROC_First_High_Low_Constraint')