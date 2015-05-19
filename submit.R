load('test_ids.RData')
load('preds_xgboost.RData')
load('preds_h2o.RData')

options("scipen"=100, "digits"=10) 

preds_submit <- preds_xgb*.4 + preds_h2o*.6
preds_submit <- cbind(test_ids, preds_submit)
colnames(preds_submit) = c('id', paste0('Class_',1:9))

z <- gzfile("preds_submit.gz")
write.csv(preds_submit, z, quote=FALSE,row.names=FALSE)
