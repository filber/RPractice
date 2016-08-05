library(PortfolioAnalytics)


# 1.准备数据 --------------------------------------------------------------------
data(edhec)
# 取四支股票的收益率作为样本
returns<-edhec[,1:4]
fund.names <- c("CA", "CTAG", "DS", "EM")
colnames(returns) <- fund.names


# 2.添加约束 --------------------------------------------------------------
pspec <- portfolio.spec(assets=fund.names)
print.default(pspec)
# 约束权重永远为100%
pspec <- add.constraint(portfolio=pspec,type="full_investment")


# 3.添加对象 ------------------------------------------------------------------
# 下述的ETL,ES,StdDev等均来源于PerformanceAnalytics


# 3.1.添加risk对象 ----------------------------------
# Risk对象在求解过程中采用minimize的方式
# ETL-Expected Tail Loss
pspec <- add.objective(portfolio=pspec,type="risk",name="ETL",arguments=list(p=0.95))
# ES-Expected Shortfall
pspec <- add.objective(portfolio=pspec,type="risk", name="ES",arguments=list(p=0.925, clean="boudt"))
# 标准差
pspec <- add.objective(portfolio=pspec,type="risk", name="StdDev")

# 3.2.添加risk_budget对象 ----------------------------------
# 约束max_prisk为0.3,即没有一个asset对总风险的贡献大于30%
pspec <- add.objective(portfolio=pspec, type="risk_budget", name="ETL",arguments=list(p=0.95), max_prisk=0.3)

# 3.3.添加return对象
# Return对象在求解过程中采用maximize的方式
pspec <- add.objective(portfolio=pspec,type="return",name="mean")
