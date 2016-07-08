# KDJ参数值

# INDICATOR ---------------------------------------------------------------------
# J值
PARAM$KDJ.INDICATOR.KDJ.FASTK.N<-12
# K值
PARAM$KDJ.INDICATOR.KDJ.FASTD.N<-14
# D值
PARAM$KDJ.INDICATOR.KDJ.SLOWD.N<-10

# SIGNAL ---------------------------------------------------------------------
# X1
PARAM$KDJ.SIGNAL.K.GT.X1<-0.7
# X2
PARAM$KDJ.SIGNAL.K.LT.X2<-0.2


# DISTRIBUTION ------------------------------------------------------------------
#指标KDJ的FASTK的周期（J值）
PARAM$KDJ.DIS.INDICATOR.KDJ.FASTK.N<-10:15
#指标KDJ的FASTD的周期（K值）
PARAM$KDJ.DIS.INDICATOR.KDJ.FASTD.N<-10:15
#指标KDJ的SLOWD的周期（D值）
PARAM$KDJ.DIS.INDICATOR.KDJ.SLOWD.N<-10:15
#信号KDJ的上限值X1
PARAM$KDJ.DIS.SIGNAL.K.GT.X1<-seq(from = 0.7,to = 0.9,by = 0.02)
#信号KDJ的下限值
PARAM$KDJ.DIS.SIGNAL.K.LT.X2<-seq(from = 0.1,to = 0.3,by = 0.02)