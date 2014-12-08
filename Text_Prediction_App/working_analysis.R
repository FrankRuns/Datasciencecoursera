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

f5 <- function(text) {
      if (length(grep(paste0("^", text, " "), fiveDF$words)) > 0) {
            tdf <- data.frame(phr = fiveDF[grep(paste0("^", text, " "), fiveDF$words), 1], 
                              cnt = fiveDF[grep(paste0("^", text, " "), fiveDF$words), 2], 
                              stringsAsFactors=FALSE)
            for (i in 1:length(tdf$phr)) {
                  tdf$phr[i] <- splitUnlist(tdf$phr[i])[5]
            }
            if (length(tdf$phr > 10)) {
                  tdf <- head(tdf, n=10)
            }
            barplot(tdf$cnt, names.arg=c(tdf$phr), ylab="Frequency")
            # return (tdf)
      } else {
            return (f4(paste(splitUnlist(text)[2:4], collapse=" ")))
      }
}

# FOUR FOUR FOUR FOUR FOUR FOUR FOUR FOUR FOUR FOUR

fourDF <- as.data.frame(fourGT, stringsAsFactors=FALSE)
names(fourDF) <- c("words", "count")
fourDF <- subset(fourDF, fourDF$count > 1)
fourDF <- fourDF[order(-fourDF$count),]

f4 <- function(text) {
      if (length(grep(paste0("^", text, " "), fourDF$words)) > 0) {
            tdf <- data.frame(phr = fourDF[grep(paste0("^", text, " "), fourDF$words), 1], 
                              cnt = fourDF[grep(paste0("^", text, " "), fourDF$words), 2], 
                              stringsAsFactors=FALSE)
            for (i in 1:length(tdf$phr)) {
                  tdf$phr[i] <- splitUnlist(tdf$phr[i])[4]
            }
            if (length(tdf$phr > 10)) {
                  tdf <- head(tdf, n=10)
            }
            barplot(tdf$cnt, names.arg=c(tdf$phr), ylab="Frequency")
            # return (tdf)
      } else {
            return (f3(paste(splitUnlist(text)[2:3], collapse=" ")))
      }
}

# THREE THREE THREE THREE THREE THREE THREE

threeDF <- as.data.frame(threeGT, stringsAsFactors=FALSE)
names(threeDF) <- c("words", "count")
threeDF <- subset(threeDF, threeDF$count > 1)
threeDF <- threeDF[order(-threeDF$count),]

f3 <- function(text) {
      if (length(grep(paste0("^", text, " "), threeDF$words)) > 0) {
            tdf <- data.frame(phr = threeDF[grep(paste0("^", text, " "), threeDF$words), 1], 
                              cnt = threeDF[grep(paste0("^", text, " "), threeDF$words), 2], 
                              stringsAsFactors=FALSE)
            for (i in 1:length(tdf$phr)) {
                  tdf$phr[i] <- splitUnlist(tdf$phr[i])[3]
            }
            if (length(tdf$phr > 10)) {
                  tdf <- head(tdf, n=10)
            }
            barplot(tdf$cnt, names.arg=c(tdf$phr), ylab="Frequency")
            # return (tdf)
      } else {
            return (f2(paste(splitUnlist(text)[2], collapse=" ")))
      }
}

# TWO TWO TWO TWO TWO TWO TWO TWO TWO TWO TWO

twoDF <- as.data.frame(twoGT, stringsAsFactors=FALSE)
names(twoDF) <- c("words", "count")
twoDF <- subset(twoDF, twoDF$count > 1)
twoDF <- twoDF[-c(grep("^a ", twoDF$words)),]
twoDF <- twoDF[order(-twoDF$count),]

f2 <- function(text) {
      if (length(grep(paste0("^", text, " "), twoDF$words)) > 0) {
            tdf <- data.frame(phr = twoDF[grep(paste0("^", text, " "), twoDF$words), 1], 
                              cnt = twoDF[grep(paste0("^", text, " "), twoDF$words), 2], 
                              stringsAsFactors=FALSE)
            for (i in 1:length(tdf$phr)) {
                  tdf$phr[i] <- splitUnlist(tdf$phr[i])[2]
            }
            if (length(tdf$phr > 10)) {
                  tdf <- head(tdf, n=10)
            }
            barplot(tdf$cnt, names.arg=c(tdf$phr), ylab="Frequency")
            # return (tdf)
      } else {
            return ("sorry labor negotiating... be back soon")
      }
}

findit <- function(text) {
      nWords <- length(splitUnlist(text))
      if (nWords > 4) {
            text <- paste(tail(splitUnlist(text), n=4), collapse=" ")
            nextWords <- f5(text) 
      }
      if (nWords == 4) {
            nextWords <- f5(text)
      }
      if (nWords == 3) {
            nextWords <- f4(text)
      }
      if (nWords == 2) {
            nextWords <- f3(text)
      }
      if (nWords == 1) {
            nextWords <- f2(text)
      }
      # return (nextWords)
}

write.table(fiveDF, file="fiveGrams")
# fiveGrams <- read.table("fiveGrams", skip = 1)
write.table(fourDF, file="fourGrams")
# fourGrams <- read.table("fourGrams", skip = 1)
write.table(threeDF, file="threeGrams")
# threeGrams <- read.table("threeGrams", skip = 1)
write.table(twoDF, file="twoGrams")
# twoGrams <- read.table("twoGrams", skip = 1)