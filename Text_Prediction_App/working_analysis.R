setwd("/Users/frankCorrigan/Desktop/en_US/")

# read news file
newsfile <- "en_US.news.txt"
lineCount <- length(readLines(newsfile))
con <- file(newsfile, "r")
news <- readLines(con, lineCount*0.001)
close(con)

# read blogs file
blogsfile <- "en_US.blogs.txt"
lineCount <- length(readLines(blogsfile))
con <- file(blogsfile, "r")
blogs <- readLines(con, lineCount*0.001)
close(con)

# read twitter file
twitterfile <- "en_US.twitter.txt"
lineCount <- length(readLines(twitterfile))
con <- file(twitterfile, "r")
tweets <- readLines(con, lineCount*0.001)
close(con)

setwd("/Users/frankCorrigan/Datasciencecoursera/Text_Prediction_App/")

# create 'giant' corpus with tm package
library(tm)
corpus <- Corpus(VectorSource(c(news, blogs, tweets)))

# clean corpus
korpus <- tm_map(corpus, tolower)
korpus <- tm_map(korpus, removePunctuation)
korpus <- tm_map(korpus, removeNumbers)

# set options for tdm creation
options(mc.cores=1)

# declare 4-gram, 3-gram, 2-gram tokenizers using RWeka
require(RWeka)
fiveGramizer <- function(x) NGramTokenizer(x, Weka_control(min=5, max=5))
fourGramizer <- function(x) NGramTokenizer(x, Weka_control(min=4, max=4))
threeGramizer <- function(x) NGramTokenizer(x, Weka_control(min=3, max=3))
twoGramizer <- function(x) NGramTokenizer(x, Weka_control(min=2, max=2))

# create term document matrices
tdmFive <- TermDocumentMatrix(korpus, control=list(tokenize=fiveGramizer))
tdmFour <- TermDocumentMatrix(korpus, control=list(tokenize=fourGramizer))
tdmThree <- TermDocumentMatrix(korpus, control=list(tokenize=threeGramizer))
tdmTwo <- TermDocumentMatrix(korpus, control=list(tokenize=twoGramizer))

# calc and save row sums with slam's row_sums
library(slam)
fiveSum <- as.data.frame(sort(row_sums(tdmFive), decreasing=TRUE))
fourSum <- as.data.frame(sort(row_sums(tdmFour), decreasing=TRUE))
threeSum <- as.data.frame(sort(row_sums(tdmThree), decreasing=TRUE))
twoSum <- as.data.frame(sort(row_sums(tdmTwo), decreasing=TRUE))

finder <- function(text){
      # how many letters in string?
      nWords <- length(unlist(strsplit(text, " ")))
      # if nWords is > 4, take only the last four words
      if (nWords > 4) {
            start <- length(unlist(strsplit(text, " "))) - 3
            end <- length(unlist(strsplit(text, " ")))
            text <- toString(unlist(strsplit(text, " "))[start:end])
            text <- gsub(",", "", text)
            outcome <- getFifth(text)
      }
      # if (nWords = 4) getFifth(text)
      if (nWords == 4) {outcome <- getFifth(text) }
      # if (nWords == 3) getFourth(text)
      if (nWords == 3) {outcome <- getFourth(text) }
      # if (nWords == 2) getThird(text)
      if (nWords == 2) { outcome <- getThird(text) }
      # if there is 1 word run the getSecond function
      if (nWords == 1) { outcome <- getSecond(text) }
      return (outcome)
}

getSecond <- function(text){
      outcome <- grep(paste0("^", text), rownames(twoSum), value=TRUE)[1]
      return (outcome)
}

getThird <- function(text){
      # test is "a lot"
      outcome <- grep(paste0("^", text), rownames(threeSum), value=TRUE)[1]
      # test is "going fast"
      if (is.na(outcome)){
            outcome <- getSecond(unlist(strsplit(text, " "))[2])
      }      
      if (is.na(outcome)){
            outcome <- "i'm failing to predict a next word because your level of intelligence is intimidating me"
      }
      return (outcome)
}

getFourth <- function(text){
      outcome <- grep(paste0("^", text), rownames(fourSum), value=TRUE)[1]
      if (is.na(outcome)){
            outcome <- getThird(paste(unlist(strsplit(text, " "))[2], unlist(strsplit(text, " "))[3], ""))
      }
      if (is.na(outcome)){
            outcome <- getSecond(unlist(strsplit(text, " "))[3])
      }
      if (is.na(outcome)){
            outcome <- "i'm failing to predict a next word because you're good looks are distracting me"
      }
      # test "at the funnest"
      return (outcome)
}

getFifth <- function(text){
      outcome <- grep(paste0("^", text), rownames(fiveSum), value=TRUE)[1]
      if (is.na(outcome)){
            outcome <- getFourth(paste(unlist(strsplit(text, " "))[2], unlist(strsplit(text, " "))[3], unlist(strsplit(text, " "))[4], ""))
      }
      if (is.na(outcome)){
            outcome <- getThird(paste(unlist(strsplit(text, " "))[2], unlist(strsplit(text, " "))[3], ""))
      }
      if (is.na(outcome)){
            outcome <- getSecond(unlist(strsplit(text, " "))[3])
      }
      if (is.na(outcome)){
            outcome <- "i'm failing to predict a next word because you're good looks are distracting me"
      }
      # test "at the funnest"
      return (outcome)
}

write.table(fourSum, file="fourGrams")
# fourGrams <- read.table("fourGrams", skip = 1)
write.table(threeSum, file="threeGrams")
# threeGrams <- read.table("threeGrams", skip = 1)
write.table(twoSum, file="twoGrams")
# twoGrams <- read.table("twoGrams", skip = 1)

