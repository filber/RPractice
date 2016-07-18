# EnvPrepare --------------------------------------------------------------
options(warn = -1)# 关闭警告信息
rm(list = ls(all=TRUE))# 清除所有变量
source('EnvPrepare/Param.r')# 加载参数
source('EnvPrepare/Data.r')# 准备数据
source('EnvPrepare/Portfolio.r')# 准备投资组合
# source('utils.r')

# StrategyScript ----------------------------------------------------------
# 加载策略
source('StrategyScript/Common_Logic.r')

# Result Folder ------------------------------------------------------------
if(PARAM$FLAG != 'simulate') {
  resultPrefix<-paste('Results/',as.character.Date(Sys.time(),format='%Y%m%d_%H%M%S'),'/',sep = '')
  dir.create(resultPrefix)
}

# ApplyStrategy -----------------------------------------------------------
if(PARAM$FLAG == 'apply') {
  # 执行策略
  source('Apply/ApplyStrategy.r')
  # 生成诊断图片
  source('Diagnostics/ApplyDiagnostics.r')
}

# Optimization ------------------------------------------------------------
if(PARAM$FLAG == 'optimize') {
  # 执行优化
  source('Optimization/Optimization.r')
  # 生成诊断图片
  source('Diagnostics/OptimizeDiagnostics.r')
}

if(PARAM$FLAG != 'simulate') {
  # Report ------------------------------------------------------------------
  # 生成测试报告
  source('Report/Report.r')
  
  # Save -------------------------------------------------------------
  # 保存所有变量到镜像文件
  save(list = ls(all=TRUE),file = paste(resultPrefix,'Img.RData',sep = ''))
}

# Simulate ----------------------------------------------------------------
if(PARAM$FLAG == 'simulate') {
  # 执行策略
  source('Apply/ApplyStrategy.r')
}