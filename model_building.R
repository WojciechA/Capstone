library(tm)
library(sqldf)
library(ngram)


setwd("C:/COURSERA/Capstone Project")

twitter <- readLines(con="C:/COURSERA/Capstone Project/data/Coursera-SwiftKey/final/en_US/en_US.twitter.txt",skipNul = T, encoding = 'UTF-8')
news <- readLines(con="C:/COURSERA/Capstone Project/data/Coursera-SwiftKey/final/en_US/en_US.news.txt",skipNul = T, encoding = 'UTF-8')
blogs <- readLines(con="C:/COURSERA/Capstone Project/data/Coursera-SwiftKey/final/en_US/en_US.blogs.txt",skipNul = T, encoding = 'UTF-8')
set.seed(123)
All_Docs <- c(sample(blogs,   length(blogs)   * 0.3),
              sample(news,    length(news)    * 0.3),
              sample(twitter, length(twitter) * 0.3))



corp_docs <- Corpus(VectorSource(list(All_Docs)))

# convert to lowercase
corp_docs  <- tm_map(corp_docs , content_transformer(tolower))

# remove punctuation
corp_docs  <- tm_map(corp_docs , removePunctuation)

# remove numbers
corp_docs  <- tm_map(corp_docs , removeNumbers)

# strip whitespace
corp_docs  <- tm_map(corp_docs , stripWhitespace)

#create the toEmpty content transformer
toEmpty <- content_transformer(function(x, pattern) {return (gsub(pattern, "", x, fixed = TRUE))})
corp_docs <- tm_map(corp_docs, toEmpty, "'")
str <- concatenate(lapply(corp_docs,"[",1))


#create  3-grams
ng3 <- ngram (str,n=3)
xxx<-get.phrasetable(ng3)
tmp <- matrix(unlist(strsplit(as.character(xxx$ngrams), ' ')), ncol=3,byrow=TRUE)
tm_frq3 <- cbind(as.data.frame(tmp),xxx$freq)
names(tm_frq3) <- c("lm2", "lm1", "lw","freq")

#create  3-grams - sorted
out_3<-sqldf("  select lm2,lm1,lw, sum(freq) 
                from tm_frq3
                group by lm2,lm1,lw
                order by 4 desc
                  ")
#create  2-grams - sorted
out_2<-sqldf("  select lm1,lw, sum(freq) 
             from tm_frq3
             group by lm1,lw
             order by 3 desc
             ")
#find the most poular word
out_most_popular<-toString(sqldf("  select lw, sum(freq) 
             from tm_frq3
             group by lw
             order by 2 desc
             ")[1:3,1])

out_most_popular


# Save objects
saveRDS(out_3, "frequency_3.Rda")
saveRDS(out_2, "frequency_2.Rda")
saveRDS(out_most_popular, "the_most_popular.Rda")



