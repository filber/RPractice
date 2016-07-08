require(doParallel)
require(quantstrat)

period = 'days'
k.training = 6
k.testing = 6
obj.func = function(x) {     which(x == max(x)) }
obj.args = list(x =quote(tradeStats.list$Net.Trading.PL))

my.applyStrategy<-function (strategy, portfolios, mktdata = NULL, parameters = NULL, 
                            ..., debug = FALSE, symbols = NULL, initStrat = FALSE, updateStrat = FALSE, 
                            initBySymbol = FALSE, gc = FALSE, delorders = FALSE) {
  if (isTRUE(debug)) 
    ret <- list()
  if (!is.strategy(strategy)) {
    strategy <- try(getStrategy(strategy))
    if (inherits(strategy, "try-error")) 
      stop("You must supply an object of type 'strategy'.")
  }
  if (missing(mktdata) || is.null(mktdata)) 
    load.mktdata = TRUE
  else load.mktdata = FALSE
  for (portfolio in portfolios) {
    if (isTRUE(initStrat)) 
      initStrategy(strategy = strategy, portfolio, symbols, 
                   ... = ...)
    if (isTRUE(debug)) 
      ret[[portfolio]] <- list()
    pobj <- .getPortfolio(portfolio)
    symbols <- ls(pobj$symbols)
    sret <- new.env(hash = TRUE)
    for (symbol in symbols) {
      if (isTRUE(load.mktdata)) {
        if (isTRUE(initBySymbol)) 
          initSymbol(strategy, symbol, ... = ...)
        mktdata <- get(symbol)
      }
      sret$indicators <- applyIndicators(strategy = strategy, 
                                         mktdata = mktdata, parameters = parameters, 
                                         ...)
      #此处
      sret$indicators<-merge.xts(mktdata,sret$indicators$stoch,all = c(TRUE,FALSE))
      if (inherits(sret$indicators, "xts") & nrow(mktdata) == 
            nrow(sret$indicators)) {
        mktdata <- sret$indicators
        sret$indicators <- NULL
      }
      
      sret$signals <- applySignals(strategy = strategy, 
                                   mktdata = mktdata, parameters = parameters, 
                                   ...)
      if (inherits(sret$signals, "xts") & nrow(mktdata) == 
            nrow(sret$signals)) {
        mktdata <- sret$signals
        sret$signals <- NULL
      }
      sret$rules <- list()
      pd <- FALSE
      for (i in 1:length(strategy$rules)) {
        if (length(strategy$rules[[i]]) != 0) {
          z <- strategy$rules[[i]]
          if (z[[1]]$path.dep == TRUE) {
            pd <- TRUE
          }
        }
      }
      sret$rules$nonpath <- applyRules(portfolio = portfolio, 
                                       symbol = symbol, strategy = strategy, mktdata = mktdata, 
                                       Dates = NULL, indicators = sret$indicators, 
                                       signals = sret$signals, parameters = parameters, 
                                       ..., path.dep = FALSE, debug = debug)
      rem.orders <- suppressWarnings(getOrders(portfolio = portfolio, 
                                               symbol = symbol, status = "open"))
      if (NROW(rem.orders) > 0) {
        pd <- TRUE
      }
      if (pd == TRUE) {
        sret$rules$pathdep <- applyRules(portfolio = portfolio, 
                                         symbol = symbol, strategy = strategy, mktdata = mktdata, 
                                         Dates = NULL, indicators = sret$indicators, 
                                         signals = sret$signals, parameters = parameters, 
                                         ..., path.dep = TRUE, debug = debug)
      }
      if (isTRUE(initBySymbol)) {
        if (hasArg(Interval)) {
          Interval <- match.call(expand.dots = TRUE)$Interval
          if (!is.null(Interval)) {
            temp.symbol <- get(symbol)
            ep_args <- blotter:::.parse_interval(Interval)
            temp.symbol <- temp.symbol[endpoints(temp.symbol, 
                                                 on = ep_args$on, k = ep_args$k)]
            if (hasArg(prefer)) {
              prefer <- match.call(expand.dots = TRUE)$prefer
              temp.symbol <- getPrice(temp.symbol, prefer = prefer)[, 
                                                                    1]
            }
            assign(symbol, temp.symbol, envir = .GlobalEnv)
          }
        }
        else {
          rm(list = symbol)
          gc()
        }
      }
      if (isTRUE(debug)) 
        ret[[portfolio]][[symbol]] <- sret
      if (isTRUE(delorders)) 
        .strategy[[paste("order_book", portfolio, sep = ".")]][[symbol]] <- NULL
      if (isTRUE(gc)) 
        gc()
    }
    if (isTRUE(updateStrat)) 
      updateStrategy(strategy, portfolio, Symbols = symbols, 
                     ... = ...)
  }
  if (isTRUE(debug)) 
    return(ret)
}

my.apply.paramset<-function (strategy.st, paramset.label, portfolio.st, account.st, 
          mktdata = NULL, nsamples = 0, user.func = NULL, user.args = NULL, 
          calc = "slave", audit = NULL, packages = NULL, verbose = FALSE, 
          paramsets, ...) {
#   must.have.args(match.call(), c("strategy.st", "paramset.label", 
#                                  "portfolio.st"))
#   strategy <- must.be.strategy(strategy.st)
#   must.be.paramset(strategy, paramset.label)
  strategy <- getStrategy(strategy.st)
#   if (!is.null(audit)) 
#     must.be.environment(audit)
  portfolio <- .getPortfolio(portfolio.st)
  account <- getAccount(account.st)
  orderbook <- getOrderBook(portfolio.st)
  distributions <- strategy$paramsets[[paramset.label]]$distributions
  constraints <- strategy$paramsets[[paramset.label]]$constraints
  if (missing(paramsets)) {
    param.combos <- expand.distributions(distributions)
    param.combos <- apply.constraints(constraints, distributions, 
                                      param.combos)
    rownames(param.combos) <- NULL
    if (nsamples > 0) 
      param.combos <- select.samples(nsamples, param.combos)
  }
  else {
    param.combos <- paramsets
  }
  if (ncol(param.combos) == 1) 
    param.combos <- as.matrix(param.combos)
  env.functions <- c("clone.portfolio", "clone.orderbook", 
                     "install.param.combo")
  env.instrument <- as.list(FinancialInstrument:::.instrument)
  symbols <- names(getPortfolio(portfolio.st)$symbols)
  if (is.null(audit)) 
    .audit <- new.env()
  else .audit <- audit
  combine <- function(...) {
    args <- list(...)
    results <- list()
    for (i in 1:length(args)) {
      r <- args[[i]]
      put.portfolio(r$portfolio.st, r$portfolio, envir = .audit)
      r$portfolio <- NULL
      put.orderbook(r$portfolio.st, r$orderbook, envir = .audit)
      r$orderbook <- NULL
      if (calc == "master") {
        updatePortf(r$portfolio.st, ...)
        r$tradeStats <- tradeStats(r$portfolio.st)
        if (!is.null(user.func) && !is.null(user.args)) 
          r$user.func <- do.call(user.func, user.args)
      }
      results[[r$portfolio.st]] <- r
      if (!is.null(r$tradeStats)) 
        results$tradeStats <- rbind(results$tradeStats, 
                                    cbind(r$param.combo, r$tradeStats))
      if (!is.null(r$user.func)) 
        results$user.func <- rbind(results$user.func, 
                                   cbind(r$param.combo, r$user.func))
    }
    return(results)
  }
  fe <- foreach(param.combo = iter(param.combos, by = "row"), 
                .verbose = verbose, .errorhandling = "pass", .packages = c("quantstrat", 
                                                                           packages), .combine = combine, .multicombine = TRUE, 
                .maxcombine = max(2, nrow(param.combos)), .export = c(env.functions, 
                                                                      symbols,'my.applyStrategy'), ...)
  fe$args <- fe$args[1]
  fe$argnames <- fe$argnames[1]
  results <- fe %dopar% {
    param.combo.num <- rownames(param.combo)
    print(paste("Processing param.combo", param.combo.num))
    print(param.combo)
    if (!getDoSeqRegistered()) {
      rm(list = ls(pos = .blotter), pos = .blotter)
      rm(list = ls(pos = .strategy), pos = .strategy)
    }
    list2env(env.instrument, envir = FinancialInstrument:::.instrument)
    for (sym in symbols) assign(sym, get(sym), .GlobalEnv)
    put.portfolio(portfolio.st, portfolio)
    put.account(account.st, account)
    put.orderbook(portfolio.st, orderbook)
    put.strategy(strategy)
    result <- list()
    result$param.combo <- param.combo
    result$portfolio.st <- paste(portfolio.st, param.combo.num, 
                                 sep = ".")
    clone.portfolio(portfolio.st, result$portfolio.st)
    clone.orderbook(portfolio.st, result$portfolio.st)
    if (exists("redisGetContext")) {
      redisContext <- redisGetContext()
      redisClose()
    }
    strategy <- install.param.combo(strategy, param.combo, 
                                    paramset.label)
    my.applyStrategy(strategy, portfolios = result$portfolio.st, 
                  mktdata = mktdata, ...)
    if (exists("redisContext")) {
      redisConnect(host = redisContext$host)
    }
    if (calc == "slave") {
      updatePortf(result$portfolio.st, ...)
      result$tradeStats <- tradeStats(result$portfolio.st)
      if (!is.null(user.func) && !is.null(user.args)) 
        result$user.func <- do.call(user.func, user.args)
    }
    result$portfolio <- getPortfolio(result$portfolio.st)
    result$orderbook <- getOrderBook(result$portfolio.st)
    print(paste("Returning results for param.combo", param.combo.num))
    return(result)
  }
  if (is.null(audit)) 
    .audit <- NULL
  else {
    assign("distributions", distributions, envir = .audit)
    assign("constraints", constraints, envir = .audit)
    assign("paramset.label", paramset.label, envir = .audit)
    assign("param.combos", param.combos, envir = .audit)
    assign("tradeStats", results$tradeStats, envir = .audit)
    assign("user.func", results$user.func, envir = .audit)
  }
  return(results)
}




# START -------------------------------------------------------------------

results <- list()#保存Walk-Forward Analysis的全部结果
ep <- endpoints(Data, on=period)
total.start <- ep[1 + k.training] + 1
total.timespan <- paste(index(Data[total.start]), '', sep='/')

k <- 1 #循环计数

while(TRUE)
{
  result <- list()# 保留WalkForward的中间结果
  
  # 训练窗口的起始和结束
  training.start <- ep[k] + 1
  training.end   <- ep[k + k.training]
  
  # 如果训练窗口已经超出了最后一条数据,则结束
  if(is.na(training.end))
    break
  # 训练窗口的时间范畴
  result$training.timespan <- training.timespan <- paste(index(Data[training.start]), index(Data[training.end]), sep='/')
  
  # 测试窗口的起始和结束
  testing.start <- ep[k + k.training] + 1
  testing.end   <- ep[k + k.training + k.testing]
  # 如果测试窗口已经超出了最后一条数据,则结束训练
  if(is.na(testing.end))
    break
  # 测试窗口的时间范畴
  testing.timespan <- paste(index(Data[testing.start]), index(Data[testing.end]), sep='/')
  
  print(paste('=== training', PARAM$PARAMSET.LABEL, 'on', training.timespan))
  
  # run backtests on training window
  DQStrategy<-getStrategy(q.strategy)
  userEnv<-new.env()
#   进行并发处理
  cl <- makePSOCKcluster(names=4)
  registerDoParallel(cl,out='wf.txt')
  result$apply.paramset <- my.apply.paramset(strategy.st=DQStrategy, paramset.label=PARAM$PARAMSET.LABEL,
                                          portfolio.st=q.strategy, account.st=q.strategy,
                                          mktdata=Data[training.timespan], nsamples=PARAM$PARAMSET.NSAMPLES,
                                          calc='slave', audit=userEnv)
  stopCluster(cl)
  tradeStats.list <- result$apply.paramset$tradeStats
  
  # select best param.combo
  param.combo.idx <- do.call(obj.func, obj.args)
  
  if(!missing(k.testing) && k.testing>0)
  {
    if(!is.function(obj.func))
      stop(paste(obj.func, 'unknown obj function', sep=': '))
    
    
    if(length(param.combo.idx) == 0)
      stop('obj.func() returned empty result')
    
    param.combo <- tradeStats.list[param.combo.idx, 1:grep('Portfolio', names(tradeStats.list)) - 1]
    param.combo.nr <- row.names(tradeStats.list)[param.combo.idx]
    
    assign('obj.func', obj.func, envir=userEnv)
    assign('param.combo.idx', param.combo.idx, envir=userEnv)
    assign('param.combo.nr', param.combo.nr, envir=userEnv)
    assign('param.combo', param.combo, envir=userEnv)
    
    # 配置策略,使其使用obj.func选出来的参数组合
    DQStrategy <- install.param.combo(DQStrategy, param.combo, PARAM$PARAMSET.LABEL)
    
    result$testing.timespan <- testing.timespan
    
    print(paste('=== testing param.combo', param.combo.nr, 'on', testing.timespan))
    print(param.combo)
    
    # run backtest using selected param.combo
    my.applyStrategy(DQStrategy, portfolios=q.strategy, mktdata=Data[testing.timespan])
  } else {
    if(is.null(tradeStats.list))
      warning(paste('no trades in training window', training.timespan, '; skipping test'))
    
    k <- k + 1
  }
  
  results[[k]] <- result
  
  k <- k + k.testing
}



# 更新投资组合信息 ----------------------------------------------------------------
updatePortf(q.strategy, Dates = total.timespan, sep = "")
results$tradeStats <- tradeStats(q.strategy)

