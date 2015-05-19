require(data.table)
require(xgboost)
require(methods)
options(digits=5)
load('train.RData')

### TRANSFORM
js <- which(!(names(train) %in% c('id', 'target', 'nz')))
for (j in js){
  set(train, j=j, value=log1p(train[[j]]))
}

### PARAMS
params_xgboost <- list(objective = 'multi:softprob', eval_metric = 'mlogloss', num_class = 9, nthread = -1, verbose = 1)
cols_train = c(cols_f, 'avg', 'nz')
params_tree <- data.table(
  eta = 0.01
  , gamma = c(.9, 1, 1.1)
  , max.depth = 10
  , min_child_weight = 6
  , subsample = .9
  , colsample_bytree = c(.4, .45, .4)
  , nrounds = c(4643, 4554, 5559)  
)
dtr <- xgb.DMatrix(as.matrix(train[id<=0, cols_train, with=F]), label=train[id<=0][['target']])  
dts <- xgb.DMatrix(as.matrix(train[id>0, cols_train, with=F]))  

### MODEL
preds_xgb <- matrix(0.0, train[id>0,.N], 9)
for (i in 1:nrow(params_tree)){  
  sink(paste0('log_xgboost_', i, '.txt'))
  params <- c(params_xgboost, params_tree[i])  
  bst <- xgb.train(params=params, data=dtr, nrounds=params$nrounds, watchlist=(train=dtr))
  pred <- predict(bst, dts)
  pred <- matrix(pred, length(pred)/9, 9, byrow=T)
  preds_xgb <- preds_xgb+pred
  sink()
  rm(bst, pred); gc()
}
rm(dtr, dts)
preds_xgb <- preds_xgb/nrow(params_tree)

save(preds_xgb, file='preds_xgb.RData')
