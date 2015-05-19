library(data.table)
library(h2o)
localH2O <- h2o.init(nthreads=-1)
load('train.RData')

nrounds <- 30
### TRANSFORM
js <- which(!(names(train) %in% c('id', 'target', 'nz')))
for(j in js){
  set(train, j=j, value=sqrt(train[[j]]+3/8))
}

### PARAMS
train.hex <- as.h2o(localH2O,train[id<=0, c(cols_f, 'avg', 'nz', 'target'), with=F])
test.hex <- as.h2o(localH2O,train[id>0, c(cols_f, 'avg', 'nz'), with=F])
predictors <- 1:(ncol(train.hex)-1)
response <- ncol(train.hex)

### MODEL
preds_h2o <- matrix(0.0, train[id>0,.N], 9)
for(i in 1:nrounds){
  sink(paste0('log_h2o_', i, '.txt'))
  print(i)
  model <- h2o.deeplearning(x=predictors,
                            y=response,
                            data=train.hex,
                            classification=T,
                            activation="RectifierWithDropout",
                            hidden=c(1024,512,256),
                            hidden_dropout_ratio=c(0.5,0.5,0.5),
                            input_dropout_ratio=0.05,
                            epochs=100,
                            l1=1e-5,
                            l2=1e-5,
                            rho=0.99,
                            epsilon=1e-8,
                            train_samples_per_iteration=2000,
                            max_w2=10
  )
  pred <- as.matrix(h2o.predict(model,test.hex))[, 2:10]
  preds_h2o <- preds_h2o + pred
  sink()
  rm(pred, model); gc()
}
h2o.shutdown(localH2O,F)
preds_h2o <- preds_h2o/nrounds

save(preds_h2o, file='preds_h2o.RData')
