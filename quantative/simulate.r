require(mongolite)
require(quantstrat)
require(WindR)

w.start(showmenu = FALSE)

logon<-w.tlogon('00000010','0','M:1850104788901','111111','SHSZ')

# EnvPrepare --------------------------------------------------------------
options(warn = -1)# 关闭警告信息
rm(list = ls(all=TRUE))# 清除所有变量
source('EnvPrepare/Param.r')# 加载参数

PARAM$FLAG<-'simulate'

lastTimestamp<-Sys.Date()-10
dbSymbol<-"601211.SH"
con <- mongo(collection = "stock",url = 'mongodb://114.215.151.231:27017/stock')
configcon <- mongo(collection = "stock_config",url = 'mongodb://114.215.151.231:27017/stock')

while(TRUE) {
  # 更新数据
  source('Data/SimulateData.r')
  # 初始化投资组合
  source('EnvPrepare/Portfolio.r')
  source('StrategyScript/Common_Logic.r')
  # 执行策略
  source('Apply/ApplyStrategy.r')
  # 提交指令
  source('Apply/SubmitOrder.r')
  Sys.sleep(3)
}
