library(data.table)
library(magrittr)
library(readr)
library(stringr)
source("functions1.R")


files <- list.files('input/datasets/') %>% paste0('input/datasets/',.)

lst <- lapply(files, function(x)cbind(ReadReviews(x),product=x))
data.unclean <- rbindlist(lst)

save(file="workdir/unclean_data.Rdata",data.unclean)
