options(warn = -1)

# EnvPrepare --------------------------------------------------------------
# 准备数据
source('EnvPrepare/Data.r')
# 准备投资组合
source('EnvPrepare/Portfolio.r')

# StrategyScript ----------------------------------------------------------
# 加载策略
source('StrategyScript/Common_Logic.r')


# ApplyStrategy -----------------------------------------------------------
# 执行策略
source('Apply/ApplyStrategy.r')


# Optimization ------------------------------------------------------------
# 执行优化

# Diagnostics -------------------------------------------------------------
# 生成诊断图片
source('Diagnostics/Diagnostics.r')

# Report -------------------------------------------------------------
# 生成测试报告
