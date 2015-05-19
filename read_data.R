require(data.table)

### READ DATA
train <- fread('Data/train.csv', stringsAsFactors=F)
test <- fread('Data/test.csv', stringsAsFactors=F)
train[, id:=id-.N]
test[, target:=NA]
train <- rbind(train, test)
rm(test)
train[!is.na(target), target:=gsub('Class_', '', target)]
train[, target:=as.integer(target)-1L]
cols_f <- c(paste0('f_0', 1:9), paste0('f_', 10:93))
cols_c <- 0:8
setnames(train, c('id', cols_f, 'target'))
setkey(train, id)

### FEATURES: AVG, ZEROS
train[, avg:=rowMeans(.SD), .SDcols=cols_f]
train[, nz:=rowMeans(.SD==0), .SDcols=cols_f]
train[, nz:=tan(nz)]

save(train, cols_f, cols_c, file='train.RData')

test_ids <- train[id>0][['id']]
save(test_ids, file='test_ids.RData')
