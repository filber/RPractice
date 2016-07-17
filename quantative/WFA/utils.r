
must.be.paramset <- function(strategy, paramset)
{
  if(!(paramset %in% names(strategy$paramsets)))
    stop(paste(paramset, ': no such paramset in strategy', strategy$name))
}

create.paramset <- function(strategy, paramset.label)
{
  strategy$paramsets[[paramset.label]] <- list()
  strategy$paramsets[[paramset.label]]$distributions <- list()
  strategy$paramsets[[paramset.label]]$constraints <- list()
  
  strategy
}

expand.distributions <- function(distributions)
{
  param.values <- list()
  
  for(distribution.name in names(distributions))
  {
    variable.name <- names(distributions[[distribution.name]]$variable)
    
    param.values[[distribution.name]] <-
      distributions[[distribution.name]]$variable[[variable.name]]
  }
  expand.grid(param.values)
}

apply.constraints <- function(constraints, distributions, param.combos)
{
  for(constraint in constraints)
  {
    operator <- constraint$operator
    
    distribution.name.1 <- constraint$distributions[[1]]
    distribution.name.2 <- constraint$distributions[[2]]
    
    variable.name.1 <- names(distributions[[distribution.name.1]]$variable)
    variable.name.2 <- names(distributions[[distribution.name.2]]$variable)
    
    result <- do.call(operator, list(param.combos[,distribution.name.1], param.combos[,distribution.name.2]))
    
    param.combos <- param.combos[which(result),]
  }
  param.combos
}

select.samples <- function(nsamples, param.combos)
{
  nsamples <- min(nsamples, nrow(param.combos))
  
  param.combos <- param.combos[sample(nrow(param.combos), size=nsamples),,drop=FALSE]
  
  if(NCOL(param.combos) == 1)
    param.combos <- param.combos[order(param.combos),,drop=FALSE]
  else
    param.combos <- param.combos[with(param.combos,order(param.combos[,1],param.combos[,2])),]
  
  param.combos
}

install.param.combo <- function(strategy, param.combo, paramset.label)
{
  if (is.null(dim(param.combo))) {
    stop("'param.combo' must have a dim attribute")
  }
  
  for(param.label in colnames(param.combo))
  {
    distribution <- strategy$paramsets[[paramset.label]]$distributions[[param.label]]
    
    component.type <- distribution$component.type
    component.label <- distribution$component.label
    variable.name <- names(distribution$variable)
    
    found <- FALSE
    switch(component.type,
           indicator =,
           signal =
{
  # indicator and signal slots in strategy list use plural name for some reason:
  components.type <- paste(component.type,'s',sep='') 
  
  n <- length(strategy[[components.type]])
  
  for(index in 1:n)
  {
    if(strategy[[components.type]][[index]]$label == component.label)
    {
      strategy[[components.type]][[index]]$arguments[[variable.name]] <- param.combo[,param.label]
      
      found <- TRUE
      break
    }
  }
},
order =,
enter =,
exit =,
chain =
{
  n <- length(strategy$rules[[component.type]])
  
  for(index in 1:n)
  {
    if(strategy$rules[[component.type]][[index]]$label == component.label)
    {
      if(variable.name %in% c('timespan'))
        strategy$rules[[component.type]][[index]][[variable.name]] <- as.character(param.combo[,param.label])
      else
        strategy$rules[[component.type]][[index]]$arguments[[variable.name]] <- param.combo[,param.label]
      
      found <- TRUE
      break
    }
  }
}
    )
if(!found) stop(paste(component.label, ': no such ', component.type, ' rule in strategy ', strategy$name, sep=''))
  }
return(strategy)
}

clone.portfolio <- function(portfolio.st, cloned.portfolio.st, strip.history=TRUE)
{
  #must.have.args(match.call(), c('portfolio.st', 'cloned.portfolio.st'))
  
  portfolio <- .getPortfolio(portfolio.st)
  
  if(strip.history==TRUE)
  {
    for(symbol in ls(portfolio$symbols))
    {
      portfolio$symbols[[symbol]]$txn <- portfolio$symbols[[symbol]]$txn[1,]
      
      xts.tables <- grep('(^posPL|txn)',names(portfolio$symbols[[symbol]]), value=TRUE)
      for(xts.table in xts.tables)
        portfolio$symbols[[symbol]][[xts.table]] <- portfolio$symbols[[symbol]][[xts.table]][1,]
    }
    portfolio$summary <- portfolio$summary[1,]
  }
  put.portfolio(as.character(cloned.portfolio.st), portfolio)
  
  return(cloned.portfolio.st)
}

# creates a copy of an orderbook, stripping all orders

clone.orderbook <- function(portfolio.st, cloned.portfolio.st, strip.history=TRUE)
{
  #must.have.args(match.call(), c('portfolio.st', 'cloned.portfolio.st'))
  
  orderbook <- getOrderBook(portfolio.st)
  
  i <- 1  # TODO: find index number by name
  names(orderbook)[i] <- cloned.portfolio.st
  
  if(strip.history == TRUE)
  {
    for(symbol in names(orderbook[[portfolio.st]]))
      orderbook[[portfolio.st]][[symbol]] <- orderbook[[portfolio.st]][[symbol]][1,]
  }
  
  put.orderbook(cloned.portfolio.st, orderbook)
}
