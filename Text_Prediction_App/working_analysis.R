setwd("/Users/frankCorrigan/Desktop/en_US/")

# read news file
newsfile <- "en_US.news.txt"
lineCount <- length(readLines(newsfile))
con <- file(newsfile, "r")
news <- readLines(con, lineCount*0.01)
close(con)

# read blogs file
blogsfile <- "en_US.blogs.txt"
lineCount <- length(readLines(blogsfile))
con <- file(blogsfile, "r")
blogs <- readLines(con, lineCount*0.01)
close(con)

# read twitter file
twitterfile <- "en_US.twitter.txt"
lineCount <- length(readLines(twitterfile))
con <- file(twitterfile, "r")
tweets <- readLines(con, lineCount*0.01)
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
fourGramizer <- function(x) NGramTokenizer(x, Weka_control(min=4, max=4))
threeGramizer <- function(x) NGramTokenizer(x, Weka_control(min=3, max=3))
twoGramizer <- function(x) NGramTokenizer(x, Weka_control(min=2, max=2))

# create term document matrices
tdmFour <- TermDocumentMatrix(korpus, control=list(tokenize=fourGramizer))
tdmThree <- TermDocumentMatrix(korpus, control=list(tokenize=threeGramizer))
tdmTwo <- TermDocumentMatrix(korpus, control=list(tokenize=twoGramizer))

# calc and save row sums with slam's row_sums
library(slam)
fourSum <- as.data.frame(sort(row_sums(tdmFour), decreasing=TRUE))
threeSum <- as.data.frame(sort(row_sums(tdmThree), decreasing=TRUE))
twoSum <- as.data.frame(sort(row_sums(tdmTwo), decreasing=TRUE))

getFourth <- function(typeThreeWords){
      phrase <- grep(paste0("^", typeThreeWords), rownames(fourSum), value = TRUE)[1]
      return (phrase)
}

getThird <- function(typeTwoWords){
      phrase <- grep(paste0("^", typeTwoWords), rownames(threeSum), value = TRUE)[1]
      return (phrase)    
}

getTwo <- function(typeOneWord){
      phrase <- grep(paste0("^", typeOneWord), rownames(twoSum), value = TRUE)[1]
      return (phrase)     
}