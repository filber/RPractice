# Model Parameter List ------------------------------------------------------------------
PARAM<-list()

# Strategy Config ---------------------------------------------------------
#买入股数
PARAM$ORDER.QTY.BUY <- 1000
#卖出股数
PARAM$ORDER.QTY.SELL <- -1000

# ROC ---------------------------------------------------------------------
PARAM$PARAMSET.LABEL <- 'ROC'
source(file = "StrategyScript/ROC_Param.r")
source(file = "StrategyScript/ROC_Logic.r")

# SAR ---------------------------------------------------------------------
#PARAM$PARAMSET.LABEL <- 'SAR'

# Optimization Config -----------------------------------------------------
# Paramset Label
PARAM$PARAMSET.LABEL <- 'ROC'
# Paramset Samples
PARAM$PARAMSET.NSAMPLES <- 300