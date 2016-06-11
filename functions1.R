ReadReviews <- function(path){
  text <- read_file(path)
  regexp <- "<tr>([\\s\\S]*?)</tr>"
  
  Encoding(text) <- "UTF-8"
  text <- iconv(text, "UTF-8", "UTF-8",sub='')
  
  text.part <- gsub(regexp,"NA",text,perl = T) %>% gsub("\t\nNA\n\t","\tNA\t",.)
  fileConn<-textConnection(text.part)
  data.text <- read.table(fileConn,header = T)
  close(fileConn)
  
  Html.part <- unlist(str_extract_all(text,regexp))
  Html.part <- unique(unlist(strsplit(Html.part,"<\\!-- BOUNDARY -->")))
  
  usableText=str_replace_all(text,"[^[:graph:]]", "Bulsshint") 
  
  dataata <- strsplit(text,"")
  # fileConn<-file("outputHTML.txt")
  # writeLines(text, fileConn)
  # close(fileConn)
  return(data.text)
}