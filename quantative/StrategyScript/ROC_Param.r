# ROC参数值

# INDICATOR ---------------------------------------------------------------------

#ROC周期
ROC.INDICATOR.ROC.N<-15

#MAROC周期
ROC.INDICATOR.MAROC.N<-10

# SIGNAL ------------------------------------------------------------------

#上限值
ROC.SIGNAL.ROC.GT.HIGH <- 0.015

#下限值
ROC.SIGNAL.ROC.LT.LOW <- -0.011

# DISTRIBUTION ------------------------------------------------------------------

#ROC周期分布
ROC.DIS.INDICATOR.ROC.N <- 3:15

#MAROC周期分布
ROC.DIS.INDICATOR.MAROC.N <- 2:10

#上限值分布
ROC.DIS.SIGNAL.ROC.GT.HIGH <- seq(from = 0,to = 0.02,by = 0.001)

#下限值分布
ROC.DIS.SIGNAL.ROC.LT.LOW <- seq(from = 0,to = -0.02,by = -0.001)
