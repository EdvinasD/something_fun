rm(list=ls())

library(data.table)
library(magrittr)
library(readr)
library(stringr)
library(foreach)
library(doParallel)

source("functions1.R")


files <- list.files('input/datasets/') %>% paste0('input/datasets/',.)

lst <- lapply(files, function(x)cbind(ReadReviews(x),product=x))
data.unclean <- rbindlist(lst)

data.unique <- data.unclean[!duplicated(data.unclean[,.(date,user_id,user_rating,title,review,product)]),
                            .(id_review,date,user_id,user_rating,title,review,product)]

# 6923 unique rows
save(file="workdir/unclean_data.Rdata",unique)

stop.words <- unlist(read.table("input/stop_words.txt",stringsAsFactors = F))

# from here I will try to create bag of words.
big.data.list <- list()
for(i in 1:nrow(data.unique)){
  review <- data.unique[i,.(review)]
  review <- gsub("\\s{2,}"," ",gsub("[^a-zA-Z]"," ",review),perl=T) %>% 
    gsub("\\s{1,}$|^\\s{1,}","",.,perl = T) %>% tolower %>%  strsplit(" ") %>% unlist
  review <- review[!review %in% stop.words]
  big.data.list[[i]] <- review
}


all.words <- unique(unlist(big.data.list))
big.data.table <- data.table(matrix(0L,nrow=length(big.data.list),ncol=length(all.words)))
colnames(big.data.table) <- all.words

for(i in 1:length(big.data.list)){
  dat <- table(big.data.list[[i]])
  set(big.data.table,i,(names(dat)),split(dat, names(dat)))
}

data.all <- list(key=data.unique,big <- big.data.table)

save(file="workdir/big.table.Rdata",data.all)




