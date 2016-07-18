require(mongolite)
require(quantstrat)

# EnvPrepare --------------------------------------------------------------
options(warn = -1)# 关闭警告信息
rm(list = ls(all=TRUE))# 清除所有变量
source('EnvPrepare/Param.r')# 加载参数

PARAM$FLAG<-'simulate'

lastTimestamp<-Sys.Date()-10
dbSymbol<-"601211.SH"
con <- mongo(collection = "stock",url = 'mongodb://114.215.151.231:27017/stock')

while(TRUE) {
  source('Data/SimulateData.r')# 准备数据
  
  source('EnvPrepare/Portfolio.r')# 准备投资组合
  
  # StrategyScript ----------------------------------------------------------
  # 加载策略
  source('StrategyScript/Common_Logic.r')
  
  # Simulate ----------------------------------------------------------------
  # 执行策略
  source('Apply/ApplyStrategy.r')
  orderbook<-get.orderbook(portfolio = q.strategy)$DQStrategy$Data
  Sys.sleep(3)
}
