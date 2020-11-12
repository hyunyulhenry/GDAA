# Read Package
source('read_pak.R', local = TRUE)

# Download Price Data
symbols = c("SPY","IEV","EWJ","EEM","TLT","IEF","IYR","RWX","GLD","DBC")

withProgress(message = 'Download Data', value = 0, {
  n = length(symbols)
  for (i in 1:n) {
    
    getSymbols(symbols[i], src='yahoo')
    incProgress(1/n, detail = paste0(symbols[i]) )
  }
})


# getSymbols(symbols, src='yahoo')

# Bind Price Data
prices = do.call(merge, lapply(symbols, function(x) Ad(get(x))))
rets = na.omit(Return.calculate(prices))
names(prices) = symbols
names(rets) = unlist(strsplit(names(rets), ".Adjusted"))
  
# Min Vol Function
wt_minvol = function(covmat) {
  
  n1 = n2 = 5
  lb = rep(0.1, 5)
  ub = rep(0.3, 5)
  
  Amat_mv = cbind(rep(1, n1), diag(n1), -diag(n1))
  bvec_mv = c(1, lb, -ub)
  w_mv = solve.QP(covmat,c(rep(0,n1)),Amat_mv,bvec_mv,1)$solution
  
  return(w_mv)
}

# Get Weight
lookback = 12 # Momentum Period - Former 12 Months
fee = 0.002
wts = list()
ep = endpoints(rets, on = "months") # Rebalancing Frequency

for(i in (lookback+1) : (length(ep)) ) {
  
  # Calculate Momentum using 3~12 Months
  ret_z = lapply(3:12, function(x) {
    scale(rank(Return.cumulative( rets[c(ep[i-x] : ep[i]) , ] )))
  })
  
  K = (rank(- apply(do.call(cbind, ret_z), 1, sum), ties.method = "first") <= 5 )
  covs = cov(rets[c(ep[i-12] : ep[i]) , K]) # Covariance Matrix
  
  temp = wt_minvol(covs)
  
  wt = rep(0, ncol(rets))
  wt[K] = temp
  names(wt) = colnames(rets)
  wt = xts(t(wt), order.by = index(rets[ep[i]]))
  
  wts[[i]] = wt
  
}

wts = do.call(rbind, wts)

# Data list

db = list()
db[['ret']] = rets
db[['wts']] = wts
db[['gross']] = Return.portfolio(rets, wts, verbose = TRUE)
db[['turover']] =  xts(rowSums(abs(db[['gross']]$BOP.Weight - stats::lag(db[['gross']]$EOP.Weight)), na.rm = TRUE),
                       order.by = index(db[['gross']]$BOP.Weight))

db[['net']] = db[['gross']]$returns - (db[['turover']]  * fee)
db[['price']] = prices
colnames(db[['net']]) = 'Returns'

saveRDS(db, 'db.Rds')
data = readRDS('db.Rds')