ReadReviews <- function(path){
  text <- read_file(path)
  regexp <- "<tr>([\\s\\S]*?)</tr>"
  
  Encoding(text) <- "UTF-8"
  text <- iconv(text, "UTF-8", "UTF-8",sub='')
  
  text.part <- gsub(regexp,"NA",text,perl = T) %>% gsub("\t\nNA\n\t","\tNA\t",.)
  fileConn<-textConnection(text.part)
  data.text <- read.table(fileConn,header = T,stringsAsFactors = F)
  close(fileConn)
  
  Html.part <- unlist(str_extract_all(text,regexp))
  Html.part <- unique(unlist(strsplit(Html.part,"<\\!-- BOUNDARY -->")))
  
  good.html <- grepl('<div style="padding-top: 10px; clear: both; width: 100%;">',Html.part)
  # finish implementing HTML read part
  Html.part <- Html.part[good.html]
  
  if(length(Html.part)!=0){
    dat.html <- lapply(Html.part, DecipreHtml)
    data.html <- data.table(Reduce(rbind, dat.html))
  }
  
  # fileConn<-file("outputHTML.txt")
  # writeLines(Html.part, fileConn)
  # close(fileConn)
  return(rbind(data.text,data.html))
}

DecipreHtml <- function(html.item){
  # html.item <- Html.part[2]
  date_other_format <-str_extract(html.item,"<nobr>([\\s\\S]*?)</nobr>") %>% 
    gsub("<nobr>|</nobr>","",.)
  
  date <- date_other_format %>% gsub(",","",.) %>% 
  as.Date(date,format = "%B %d %Y") %>% gsub("-","",.) %>% 
    as.integer
  
  product_id <- as.character(NA)
  
  user_rating <- str_extract(html.item,"swSprite s_star_\\d") %>% 
    gsub("\\D","",.) %>% as.integer
  
  user_id <- str_extract(html.item,"profile/[A-Z0-9]+/ref") %>% 
    gsub("profile/|/ref","",.) 
  
  title <- str_extract(html.item,"<b>([\\s\\S]*?)</b>") %>% gsub("<b>|</b>","",.)
  
  start.re <- '</div>\\n\\n'
  end.re <- '<div style=\"padding-top: 10px; clear: both; width: 100%;\">'
  regex <- paste0(start.re,"([\\s\\S]*?)",end.re)
  review <- str_extract(html.item,regex) %>% 
    gsub(paste(start.re,end.re,"\\n","<br /><br />",sep="|"),"",.) %>% gsub("\\s{2,}"," ",.,perl = T)
  
  id_review <- as.integer(NA) 
  html.te <- data.table(id_review, date,product_id,user_rating,date_other_format,user_id,title,review)
  
  return(html.te)
  
}