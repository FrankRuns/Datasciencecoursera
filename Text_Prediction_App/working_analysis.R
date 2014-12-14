# using tm was incredibly slow and couldn't handle a big chunk of data.. 3% was a stretch
# so I've moved that below and am trying out the stylo and slam package with 10% of the txt data

setwd("/Users/frankCorrigan/Desktop/en_US/")

# read news file
newsfile <- "en_US.news.txt"
# lineCount <- length(readLines(newsfile))
lineCount <- 1010242
con <- file(newsfile, "r")
news <- readLines(con, lineCount*0.2)
close(con)

# read blogs file
blogsfile <- "en_US.blogs.txt"
# lineCount <- length(readLines(blogsfile))
lineCount <- 899288
con <- file(blogsfile, "r")
blogs <- readLines(con, lineCount*0.2)
close(con)

# read twitter file
twitterfile <- "en_US.twitter.txt"
# lineCount <- length(readLines(twitterfile))
lineCount <- 2360148
con <- file(twitterfile, "r")
tweets <- readLines(con, lineCount*0.2)
close(con)

setwd("/Users/frankCorrigan/Datasciencecoursera/Text_Prediction_App/")

# combine all lines into 1 character vector
allLines <- c(news, blogs, tweets)

# turn everything to lower case and remove punctuaion and numbers
allLines <- gsub("[[:digit:]]", "", allLines)
allLines <- gsub("([[:punct:]])", "", tolower(allLines))

# helper function to split a string by space and convert to character from list
splitUnlist <- function(text){
      return (unlist(strsplit(text, " ")))
}

# use remove white space
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
allLines <- trim(allLines)

for (i in 1:length(allLines)) {
      su <- splitUnlist(allLines[i])
      su <- su[su != ""]
      allLines[i] <- paste(su, collapse = " ")
}

# make ngrams, use table for counting, and convert to data.table
library(stylo)

# nGrams <- make.ngrams(allWords, 5)
allWords <- unlist(strsplit(allLines, " "))

fiveGrams <- make.ngrams(allWords, 5)
fourGrams <- make.ngrams(allWords, 4)
threeGrams <- make.ngrams(allWords, 3)
twoGrams <- make.ngrams(allWords, 2)

fiveGT <- table(fiveGrams)
fourGT <- table(fourGrams)
threeGT <- table(threeGrams)
twoGT <- table(twoGrams)

# FIVE FIVE FIVE FIVE FIVE FIVE FIVE FIVE FIVE

fiveDF <- as.data.frame(fiveGT, stringsAsFactors=FALSE)
names(fiveDF) <- c("words", "count")
fiveDF <- subset(fiveDF, fiveDF$count > 1)
fiveDF <- fiveDF[order(-fiveDF$count),]

# FOUR FOUR FOUR FOUR FOUR FOUR FOUR FOUR FOUR FOUR

fourDF <- as.data.frame(fourGT, stringsAsFactors=FALSE)
names(fourDF) <- c("words", "count")
fourDF <- subset(fourDF, fourDF$count > 1)
fourDF <- fourDF[order(-fourDF$count),]

# THREE THREE THREE THREE THREE THREE THREE

threeDF <- as.data.frame(threeGT, stringsAsFactors=FALSE)
names(threeDF) <- c("words", "count")
threeDF <- subset(threeDF, threeDF$count > 1)
threeDF <- threeDF[order(-threeDF$count),]

# TWO TWO TWO TWO TWO TWO TWO TWO TWO TWO TWO

twoDF <- as.data.frame(twoGT, stringsAsFactors=FALSE)
names(twoDF) <- c("words", "count")
twoDF <- subset(twoDF, twoDF$count > 1)
twoDF <- twoDF[-c(grep("^a ", twoDF$words)),]
twoDF <- twoDF[order(-twoDF$count),]

write.table(fiveDF, file="fiveGrams")
write.table(fourDF, file="fourGrams")
write.table(threeDF, file="threeGrams")
write.table(twoDF, file="twoGrams")

