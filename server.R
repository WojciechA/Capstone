
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(tm)
library(ngram)
library(dplyr)



tm_frq3<-readRDS(file = "./data/frequency_3.Rda")
tm_frq2<-readRDS(file = "./data/frequency_2.Rda")
most_popular_in_corp<-readRDS(file = "./data/the_most_popular.Rda")


my_prediction <- function(Inputed_text) {
  corp_docs_in <- Corpus(VectorSource(Inputed_text))
  # convert to lowercase
  corp_docs_in  <- tm_map(corp_docs_in , content_transformer(tolower))
  # remove punctuation
  corp_docs_in  <- tm_map(corp_docs_in , removePunctuation)
  # remove numbers
  corp_docs_in  <- tm_map(corp_docs_in , removeNumbers)
  # strip whitespace
  corp_docs_in  <- tm_map(corp_docs_in , stripWhitespace)
  str_in <- concatenate(lapply(corp_docs_in,"[",1))
  Output<-unlist(strsplit(str_in, " "))
  Out_len<-length(Output)
  type_of_alorytm<-99
  predicted_word_1<-"NA, NA, NA"
  
  if (Out_len>1 & predicted_word_1=="NA, NA, NA"){
    
    predicted_word_1 <- toString(filter(tm_frq3,lm2==toString(Output[Out_len-1]),lm1==toString(Output[Out_len]))[1:3,3])
    type_of_alorytm<-2
  }
  
  if (predicted_word_1=="NA, NA, NA"){
    predicted_word_1 <- toString(filter(tm_frq2,lm1==toString(Output[Out_len]))[1:3,2])
    type_of_alorytm<-1
  }
  
  if (predicted_word_1=="NA, NA, NA"){
    predicted_word_1<-toString(most_popular_in_corp)
    type_of_alorytm<-0
  }
  
  predicted_word<-predicted_word_1
  return(predicted_word)
}

function(input, output) {
  
  output$value <- renderPrint({ my_prediction(input$text) })
  
}

