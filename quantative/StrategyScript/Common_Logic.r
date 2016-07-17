osMinMaxPos<-function (data, timestamp, orderqty, ordertype, orderside, portfolio, 
          symbol, ruletype, ...) 
{
  #取得时间戳所对应的仓位
  pos <- getPosQty(portfolio, symbol, timestamp)
  #取得时间戳所处位置的仓位约束
  PosLimit <- getPosLimit(portfolio, symbol, timestamp)
  if (is.null(PosLimit)) 
    stop(paste("no position limit defined for portfolio", portfolio))
  
  #对指令所代表的仓位进行转换
  if (is.character(orderqty)) {
    if (ruletype == "risk" && orderqty == "all") {
      orderqty <- pos * -1
    }
    else {
      stop("orderqty ", orderqty, " is not supported for non-risk ruletypes")
    }
  }
  
  #orderqty>0表明这是一笔买单
  if (orderqty > 0) {
    if ((orderqty + pos) > PosLimit[, "MaxPos"]) {
      orderqty <- PosLimit[, "MaxPos"] - pos
    }
    return(as.numeric(orderqty))
  }
  
  #orderqty<0表明这是一笔卖单
  if (orderqty < 0) {
    if ((orderqty + pos) < PosLimit[, "MinPos"]) {
      orderqty <- PosLimit[, "MinPos"] - pos
    }
    return(as.numeric(orderqty))
  }
  return(0)
}

# ROC ---------------------------------------------------------------------
PARAM$PARAMSET.LABEL <- 'ROC'
source(file = "StrategyScript/ROC_Param.r")
# source(file = "StrategyScript/ROC_Logic.r")

# SAR ---------------------------------------------------------------------
PARAM$PARAMSET.LABEL <- 'SAR'
source(file = "StrategyScript/SAR_Param.r")
#source(file = "StrategyScript/SAR_Logic.r")

# RSI ---------------------------------------------------------------------
PARAM$PARAMSET.LABEL <- 'RSI'
source(file = "StrategyScript/RSI_Param.r")
# source(file = "StrategyScript/RSI_Logic.r")

# KDJ ---------------------------------------------------------------------
PARAM$PARAMSET.LABEL <- 'KDJ'
source(file = "StrategyScript/KDJ_Param.r")
source(file = "StrategyScript/KDJ_Logic.r")

# Optimization Config -----------------------------------------------------
# Paramset Label
PARAM$PARAMSET.LABEL <- 'KDJ'
