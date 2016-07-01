# ROC参数值

# INDICATOR ---------------------------------------------------------------------
# 加速因子
PARAM$SAR.INDICATOR.SAR.ACCEL<-0.02
# 加速因子最大值
PARAM$SAR.INDICATOR.SAR.ACCEL.MAX<-0.2

# DISTRIBUTION ------------------------------------------------------------------
#加速因子
PARAM$SAR.DIS.SAR.ACCEL <- seq(from = 0.01,to = 0.1,by = 0.01)
#加速因子最大值
PARAM$ROC.DIS.SAR.ACCEL.MAX <- seq(from = 0.1,to = 1,by = 0.1)

PARAM$SAR.DIS.SAR.ACCEL.LIST<-list()
lapply(PARAM$SAR.DIS.SAR.ACCEL,print(X))
#       lapply(PARAM$SAR.DIS.SAR.ACCEL,FUN = print(A))
}
)