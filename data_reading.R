library(data.table)
library(magrittr)
library(readr)
library(stringr)
source("functions1.R")


files <- list.files('input/datasets/') %>% paste0('input/datasets/',.)

lst <- lapply(files, function(x)cbind(ReadReviews(x),product=x))
data.unclean <- rbindlist(lst)

data.unique <- data.unclean[!duplicated(data.unclean[,.(date,user_id,user_rating,title,review,product)]),
                            .(id_review,date,user_id,user_rating,title,review,product)]

# 6923 unique rows
save(file="workdir/unclean_data.Rdata",unique)

