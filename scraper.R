# this is the R code (rather dirty I know) I used in order to scrape the data

require(XML) # for readHTMLTable
for(i in 1:70)
{
  url <- paste('http://eciresults.nic.in/ConstituencywiseU05',i,'.htm?ac=',i,sep='')
  tbl <- readHTMLTable(url)
  tbl <- tbl[[9]]
  for(j in 1:ncol(tbl))
    tbl[,j] <- as.character(tbl[,j])
  const <- as.character(tbl[1,1])
  names(tbl) <- as.character(tbl[3,])
  tbl <- tbl[-(1:3),]
  tbl$Number <- i 
  const <- unlist(strsplit(const,'-'))[2]
  tbl$Constituency <- const
  
  if(i>1) res <- rbind(res,tbl) else
    res <- tbl
  print(i)
}


res$Constituency <- substr(res$Constituency,2,100)
res <- res[with(res,order(Number)),]
res$Votes <- as.numeric(as.character(res$Votes))
tl <- aggregate(Votes~Number,res,sum)
names(tl)[2] <- "Total"
res <- merge(res,tl)
res$Voteperc <- res$Votes/res$Total
save(res,file='Delhi15.RData')
