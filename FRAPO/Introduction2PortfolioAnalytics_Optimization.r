library(ROI)
library(DEoptim)
library(PortfolioAnalytics)
require(ROI.plugin.glpk)
require(ROI.plugin.quadprog)
data(edhec)
R <- edhec[, 1:6]
colnames(R) <- c("CA", "CTAG", "DS", "EM", "EQMN", "ED")
funds <- colnames(R)
# Create an initial portfolio object with leverage and box constraints
init <- portfolio.spec(assets=funds)
init <- add.constraint(portfolio=init, type="leverage",min_sum=0.99, max_sum=1.01)
init <- add.constraint(portfolio=init, type="box", min=0.05, max=0.65)


# 1.Maximize mean return with ROI -------------------------------------------
maxret <- add.objective(portfolio=init, type="return", name="mean")
opt_maxret <- optimize.portfolio(R=R, portfolio=maxret,optimize_method="ROI",trace=TRUE)
print(opt_maxret)

plot(opt_maxret, risk.col="StdDev", return.col="mean",
     main="Maximum Return Optimization", chart.assets=TRUE,
     xlim=c(0, 0.05), ylim=c(0,0.0085))


# 2.Minimize variance with ROI --------------------------------------------
minvar <- add.objective(portfolio=init, type="risk", name="var")
opt_minvar <- optimize.portfolio(R=R, portfolio=minvar,optimize_method="ROI", trace=TRUE)
print(opt_minvar)
plot(opt_minvar, risk.col="StdDev", return.col="mean",
     main="Minimize Variance Optimization", chart.assets=TRUE,
     xlim=c(0, 0.05), ylim=c(0,0.0085))


# 3.Maximize quadratic utility with ROI -----------------------------------
qu <- add.objective(portfolio=init, type="return", name="mean")
# 风险厌恶系数为0.25
qu <- add.objective(portfolio=qu, type="risk", name="var", risk_aversion=0.00001)
# 进行二项式优化(mean~var)
opt_qu <- optimize.portfolio(R=R, portfolio=qu,optimize_method="ROI",trace=TRUE)
print(opt_qu)

plot(opt_qu, risk.col="StdDev", return.col="mean",
     main="Maximize Quadratic Optimization", chart.assets=TRUE,
     xlim=c(0, 0.05), ylim=c(0,0.0085))


# 4.Minimize expected tail loss with ROI ----------------------------------
etl <- add.objective(portfolio=init, type="risk", name="ETL")
opt_etl <- optimize.portfolio(R=R, portfolio=etl,
                                optimize_method="ROI",
                                trace=TRUE)
print(opt_etl)
plot(opt_etl, risk.col="StdDev", return.col="mean",
     main="Minimize ETL Optimization", chart.assets=TRUE,
     xlim=c(0, 0.05), ylim=c(0,0.0085))


# 5.Maximize mean return per unit ETL with random portfolios ----------------
meanETL <- add.objective(portfolio=init, type="return", name="mean")
meanETL <- add.objective(portfolio=meanETL, type="risk", name="ETL",arguments=list(p=0.95))
opt_meanETL <- optimize.portfolio(R=R, portfolio=meanETL,
                                    optimize_method="random",
                                    trace=TRUE, search_size=2000)
print(opt_meanETL)

stats_meanETL <- extractStats(opt_meanETL)
dim(stats_meanETL)
head(stats_meanETL)

plot(opt_meanETL, risk.col="ETL", return.col="mean",
     main="Maximize Mean/ETL Optimization",neighbors=25,#neighbors用于绘制临近的25个组合
     xlim=c(0, 0.05), ylim=c(0,0.0085))
pct_contrib <- ES(R=R, p=0.95, portfolio_method="component",
                  weights=extractWeights(opt_meanETL))
barplot(pct_contrib$pct_contrib_MES,las=3, col="lightblue")


# 6.Maximize mean return per unit ETL with ETL risk budgets ---------------
# 将box constraints统一修改为0~100%
init$constraints[[2]]$min <- rep(0, 6)
init$constraints[[2]]$max <- rep(1, 6)
rb_meanETL <- add.objective(portfolio=init, type="return", name="mean")
rb_meanETL <- add.objective(portfolio=rb_meanETL, type="risk", name="ETL",arguments=list(p=0.95))
# 单支股票贡献的risk不能超过40%
rb_meanETL <- add.objective(portfolio=rb_meanETL, type="risk_budget",name="ETL", max_prisk=0.4, arguments=list(p=0.95))
.storage<-new.env()
opt_rb_meanETL <- optimize.portfolio(R=R, portfolio=rb_meanETL,
                                     optimize_method="DEoptim",
                                     search_size=2000,
                                     trace=TRUE, traceDE=5)
print(opt_rb_meanETL)
plot(opt_rb_meanETL, risk.col="ETL", return.col="mean",
     main="Risk Budget mean-ETL Optimization",
     xlim=c(0,0.12), ylim=c(0.005,0.009))
plot.new()
#绘制最佳weight中各asset对风险的贡献占比
chart.RiskBudget(opt_rb_meanETL, risk.type="percentage", neighbors=25)


# 7.Maximize mean return per unit ETL with ETL equal contribution ---------
eq_meanETL <- add.objective(portfolio=init, type="return", name="mean")
eq_meanETL <- add.objective(portfolio=eq_meanETL, type="risk", name="ETL",arguments=list(p=0.95))

#使得concentration最小化,感觉是使得每个资产的贡献的方差最小??
eq_meanETL <- add.objective(portfolio=eq_meanETL, type="risk_budget",name="ETL", min_concentration=TRUE,arguments=list(p=0.95))

opt_eq_meanETL <- optimize.portfolio(R=R, portfolio=eq_meanETL,
                                     optimize_method="DEoptim",
                                     search_size=2000,
                                     trace=TRUE, traceDE=5)

print(opt_eq_meanETL)

plot.new()
plot(opt_eq_meanETL, risk.col="ETL", return.col="mean",
       main="Risk Budget mean-ETL Optimization",
       xlim=c(0,0.12), ylim=c(0.005,0.009))
#Chart the contribution to risk in percentage terms. It is clear in this chart that the optimization
#results in a near equal risk contribution portfolio.
plot.new()
chart.RiskBudget(opt_eq_meanETL, risk.type="percentage", neighbors=25)

#同时进行三个优化:
#(1)opt_meanETL-Maximize mean return per unit ETL
#(2)opt_rb_meanETL-Maximize mean return per unit ETL with ETL risk budgets
#(3)opt_eq_meanETL-Maximize mean return per unit ETL with ETL equal contribution
opt_combine <- combine.optimizations(list(meanETL=opt_meanETL,
                                          rbmeanETL=opt_rb_meanETL,
                                          eqmeanETL=opt_eq_meanETL))
# View the weights and objective measures of each optimization
extractWeights(opt_combine)

obj_combine <- extractObjectiveMeasures(opt_combine)
chart.Weights(opt_combine, plot.type="bar", legend.loc="topleft", ylim=c(0, 1))

plot.new()
chart.RiskReward(opt_combine, risk.col="ETL", return.col="mean",
                   main="ETL Optimization Comparison", xlim=c(0.018, 0.026),
                   ylim=c(0.005, 0.008))

STARR <- obj_combine[, "mean"] / obj_combine[, "ETL"]
barplot(STARR, col="blue", cex.names=0.8, cex.axis=0.8,main="mean/ETL", ylim=c(0,1))
plot.new()
chart.RiskBudget(opt_combine, match.col="ETL", risk.type="percent",
                   ylim=c(0,1), legend.loc="topright")