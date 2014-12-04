# using tm was incredibly slow and couldn't handle a big chunk of data.. 3% was a stretch
# so I've moved that below and am trying out the stylo and slam package with 10% of the txt data

setwd("/Users/frankCorrigan/Desktop/en_US/")

# read news file
newsfile <- "en_US.news.txt"
# lineCount <- length(readLines(newsfile))
lineCount <- 1010242
con <- file(newsfile, "r")
news <- readLines(con, lineCount*0.01)
close(con)

# read blogs file
blogsfile <- "en_US.blogs.txt"
# lineCount <- length(readLines(blogsfile))
lineCount <- 899288
con <- file(blogsfile, "r")
blogs <- readLines(con, lineCount*0.01)
close(con)

# read twitter file
twitterfile <- "en_US.twitter.txt"
# lineCount <- length(readLines(twitterfile))
lineCount <- 2360148
con <- file(twitterfile, "r")
tweets <- readLines(con, lineCount*0.01)
close(con)

setwd("/Users/frankCorrigan/Datasciencecoursera/Text_Prediction_App/")

# combine all lines into 1 character vector
allLines <- c(news, blogs, tweets)

# turn everything to lower case and remove punctuaion and numbers
allLines <- gsub("[[:digit:]]", "", allLines)
allLines <- gsub("([[:punct:]])", "", tolower(allLines))

# use remove white space
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
allLines <- trim(allLines)

# helper function to split a string by space and convert to character from list
splitUnlist <- function(text){
      return (unlist(strsplit(text, " ")))
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

# create and clean up five gram DF
fiveDF <- as.data.frame(fiveGT, stringsAsFactors = FALSE)
fiveDF <- subset(fiveDF, fiveDF$Freq > 1)
fiveDF$fiveGrams <- trim(fiveDF$fiveGrams)
fiveDF$holder <- lapply(fiveDF$fiveGrams, splitUnlist)
for (i in 1:length(fiveDF$holder)){
      c <- fiveDF$holder[[i]]
      fiveDF$holder[[i]] <- c[c != ""]
}
fiveDF$count <- lapply(fiveDF$holder, length)
fiveDF <- subset(fiveDF, fiveDF$count == 5)
for (i in 1:length(fiveDF$holder)) {
      fiveDF$holder[[i]] <- paste(fiveDF$holder[[i]], collapse = " ")
}
# keeping holder for now but ditching the count
# TODO: some 5+ word phrases still exist... need to kill
fiveDF$count <- NULL

# create and clean up four gram DF
fourDF <- as.data.frame(fourGT, stringsAsFactors = FALSE)
fourDF <- subset(fourDF, fourDF$Freq > 1)
fourDF$fourGrams <- trim(fourDF$fourGrams)
fourDF$holder <- lapply(fourDF$fourGrams, splitUnlist)
for (i in 1:length(fourDF$holder)){
      c <- fourDF$holder[[i]]
      fourDF$holder[[i]] <- c[c != ""]
}
fourDF$count <- lapply(fourDF$holder, length)
fourDF <- subset(fourDF, fourDF$count == 4)
for (i in 1:length(fourDF$holder)) {
      fourDF$holder[[i]] <- paste(fourDF$holder[[i]], collapse = " ")
}
# keeping holder for now but ditching the count
# TODO: some 5+ word phrases still exist... need to kill
fourDF$count <- NULL

# create and clean three gram DF
threeDF <- as.data.frame(threeGT, stringsAsFactors = FALSE)
threeDF <- subset(threeDF, threeDF$Freq > 5)
threeDF$threeGrams <- trim(threeDF$threeGrams)
threeDF$holder <- lapply(threeDF$threeGrams, splitUnlist)
for (i in 1:length(threeDF$holder)){
      c <- threeDF$holder[[i]]
      threeDF$holder[[i]] <- c[c != ""]
}
threeDF$count <- lapply(threeDF$holder, length)
threeDF <- subset(threeDF, threeDF$count == 3)
for (i in 1:length(threeDF$holder)) {
      threeDF$holder[[i]] <- paste(threeDF$holder[[i]], collapse = " ")
}
# keeping holder for now but ditching the count
# TODO: some 5+ word phrases still exist... need to kill
threeDF$count <- NULL

# create and clean two gram DF
twoDF <- as.data.frame(twoGT, stringsAsFactors = FALSE)
twoDF <- subset(twoDF, twoDF$Freq > 10)
twoDF$twoGrams <- trim(twoDF$twoGrams)
twoDF$holder <- lapply(twoDF$twoGrams, splitUnlist)
for (i in 1:length(twoDF$holder)){
      c <- twoDF$holder[[i]]
      twoDF$holder[[i]] <- c[c != ""]
}
twoDF$count <- lapply(twoDF$holder, length)
twoDF <- subset(twoDF, twoDF$count == 2)
for (i in 1:length(twoDF$holder)) {
      twoDF$holder[[i]] <- paste(twoDF$holder[[i]], collapse = " ")
}
# keeping holder for now but ditching the count
# TODO: some 5+ word phrases still exist... need to kill
twoDF$count <- NULL

# build the finder function
input <- "this is a" # test

search the 5 data frame for grep("this is a", value = TRUE)
take the first result in that subset and return the 5th word in that result

find2 <- function(text) {
      result <- splitUnlist(grep(paste0("^", text), twoDF$twoGrams, value=TRUE)[1])[2] 
      return (result)
}

find3 <- function(text) {
      result <- splitUnlist(grep(paste0("^", text), threeDF$threeGrams, value=TRUE)[1])[3]
      return (result)
}

find4 <- function(text) {
      result <- splitUnlist(grep(paste0("^", text), fourDF$fourGrams, value=TRUE)[1])[4]
      return (result)
}

find5 <- function(text) {
      result <- splitUnlist(grep(paste0("^", text), fiveDF$fiveGrams, value=TRUE)[1])[5]
      return (result)
}

# 'day' works... predicts 'when'
get2 <- function(text) {
      phrase <- splitUnlist(grep(text, fourDF$phrase, value=TRUE)[1])
      pos <- grep(text, phrase)
      if (pos == 5) {
            phrase <- splitUnlist(grep(text, fourDF$phrase, value=TRUE)[2])
            pos <- grep(text, phrase)
      }
      if (pos == 5) {
            phrase <- splitUnlist(grep(text, fourDF$phrase, value=TRUE)[3])
            pos <- grep(text, phrase)
      }
      word <- phrase[pos+1]
      return (word)
}

# five / four
# baby: NA, baby: i
# go: to, NA
# great: deal, day

get3 <- function(text) {
      phrase <- splitUnlist(grep(paste0("^", text), threeDF$phrase, value=TRUE)[4])
      pos <- grep(splitUnlist(text)[2], phrase)
      word <- phrase[pos+1]
      return (word)
}

input <- "cant wait to"
phrase <- splitUnlist(grep(input, fiveDF$fiveGrams, value=TRUE)[1])
pos <- grep(splitUnlist(input)[3], phrase)
word <- phrase[pos+1]

input <- "amazing cant wait to"
phrase <- splitUnlist(grep(paste0("^", input), fiveDF$fiveGrams, value=TRUE)[1])
pos <- grep(splitUnlist(phrase)[4], phrase)
word <- phrase[pos+1]

f <- function(text) {
      nWords <- length(splitUnlist(text))
      if (nWords >= 5) {
            start <- length(unlist(strsplit(text, " "))) - 3
            end <- length(unlist(strsplit(text, " ")))
            text <- toString(unlist(strsplit(text, " "))[start:end])
            text <- gsub(",", "", text)
            outcome <- find5(text)
      }
      if (nWords == 4) {
            outcome <- find5(text)
      }
      if (nWords == 3) {
            outcome <- find4(text)
      }
      if (nWords == 2) {
            outcome <- find3(text)
      }
      if (nWords == 1) {
            outcome <- find2(text)
      }
      return (outcome)
}

write.table(fiveSum, file="fiveGrams")
# fiveGrams <- read.table("fiveGrams", skip = 1)
write.table(fourSum, file="fourGrams")
# fourGrams <- read.table("fourGrams", skip = 1)
write.table(threeSum, file="threeGrams")
# threeGrams <- read.table("threeGrams", skip = 1)
write.table(twoSum, file="twoGrams")
# twoGrams <- read.table("twoGrams", skip = 1)

