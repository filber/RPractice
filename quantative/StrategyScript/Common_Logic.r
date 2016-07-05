# Model Parameter List ------------------------------------------------------------------
PARAM<-list()

# Strategy Config ---------------------------------------------------------
#买入股数
PARAM$ORDER.QTY.BUY <- 1000
#卖出股数
PARAM$ORDER.QTY.SELL <- -1000

# ROC ---------------------------------------------------------------------
# PARAM$PARAMSET.LABEL <- 'ROC'
source(file = "StrategyScript/ROC_Param.r")
# source(file = "StrategyScript/ROC_Logic.r")

# SAR ---------------------------------------------------------------------
PARAM$PARAMSET.LABEL <- 'SAR'
source(file = "StrategyScript/SAR_Param.r")
#source(file = "StrategyScript/SAR_Logic.r")

# RSI ---------------------------------------------------------------------
PARAM$PARAMSET.LABEL <- 'RSI'
source(file = "StrategyScript/RSI_Param.r")
source(file = "StrategyScript/RSI_Logic.r")

# Optimization Config -----------------------------------------------------
# Paramset Label
PARAM$PARAMSET.LABEL <- 'RSI'
# Paramset Samples
PARAM$PARAMSET.NSAMPLES <- 300