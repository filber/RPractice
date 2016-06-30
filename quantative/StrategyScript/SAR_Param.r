# ROC参数值

# INDICATOR ---------------------------------------------------------------------

#ROC周期
PARAM$ROC.INDICATOR.ROC.N<-15

#MAROC周期
PARAM$ROC.INDICATOR.MAROC.N<-14

# SIGNAL ------------------------------------------------------------------

#上限值
PARAM$ROC.SIGNAL.ROC.GT.HIGH <- 0.019

#下限值
PARAM$ROC.SIGNAL.ROC.LT.LOW <- -0.012

# DISTRIBUTION ------------------------------------------------------------------

#ROC周期分布
PARAM$ROC.DIS.INDICATOR.ROC.N <- 6:15

#MAROC周期分布
PARAM$ROC.DIS.INDICATOR.MAROC.N <- 6:15

#上限值分布
PARAM$ROC.DIS.SIGNAL.ROC.GT.HIGH <- seq(from = 0.005,to = 0.02,by = 0.001)

#下限值分布
PARAM$ROC.DIS.SIGNAL.ROC.LT.LOW <- seq(from = -0.005,to = -0.02,by = -0.001)
