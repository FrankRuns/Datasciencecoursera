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

# FIVE

fiveDF <- as.data.frame(fiveGT, stringsAsFactors=FALSE)
names(fiveDF) <- c("words", "count")
fiveDF <- subset(fiveDF, fiveDF$count > 1)
fiveDF <- fiveDF[order(-fiveDF$count),]

find5 <- function(fourwords) {
      nxt <- splitUnlist(grep(paste0("^", fourwords), fiveDF$words, value=TRUE))[5]
      if (is.null(nxt)) {
            nxt <- "i dont know" 
            # nxt <- find4(paste(splitUnlist(input)[2:4], collapse=" "))
      }
      return (nxt)
}

# FOUR

fourDF <- as.data.frame(fourGT, stringsAsFactors=FALSE)
names(fourDF) <- c("words", "count")
fourDF <- subset(fourDF, fourDF$count > 1)
fourDF <- fourDF[order(-fourDF$count),]

find4 <- function(threewords) {
      nxt <- splitUnlist(grep(paste0("^", threewords), fourDF$words, value=TRUE))[4]
      if (is.null(nxt)) {
            nxt <- "i dont know"
            # nxt <- find3(paste(splitUnlist(input)[3:4], collapse=" "))
      }
      return (nxt)
}

# THREE

threeDF <- as.data.frame(threeGT, stringsAsFactors=FALSE)
names(threeDF) <- c("words", "count")
threeDF <- subset(threeDF, threeDF$count > 1)
threeDF <- threeDF[order(-threeDF$count),]

#find3 <- function(twowords) {
#      nxt <- splitUnlist(grep(paste0("^", twowords), threeDF$words, value=TRUE))[1:3]
#      if (is.null(nxt)) {
#            nxt <- 'i dont know'
#            # nxt <- find2(paste(splitUnlist(input)[4], collapse=" "))
#      }
#      return (nxt)
#}

find3 <- function(twowords) {
      long <- length(grep(paste0("^", twowords), threeDF$words))
      nxt <- grep(paste0("^", twowords), threeDF$words, value=TRUE)[1:long]
      for (i in 1:long) {
            nxt[i] <- splitUnlist(nxt[i])[3]
      }
      # if (is.null(nxt)) {
            # nxt <- 'i dont know'
            # nxt <- find2(paste(splitUnlist(input)[4], collapse=" "))
      # }
      nxt <- nxt[!is.na(nxt)]
      return (nxt)
}

# TWO

twoDF <- as.data.frame(twoGT, stringsAsFactors=FALSE)
names(twoDF) <- c("words", "count")
twoDF <- subset(twoDF, twoDF$count > 1)
twoDF <- twoDF[-c(grep("^a ", twoDF$words)),]
twoDF <- twoDF[order(-twoDF$count),]

find2 <- function(oneword) {
      nxt <- splitUnlist(grep(paste0("^", oneword), twoDF$words, value=TRUE))[2]
      if (is.null(nxt)) {
            nxt <- "i dont know"
      }
      return (nxt)
}

quicktest <- function(input) {
      phive <- find5(input)
      phour <- find4(paste(splitUnlist(input)[2:4], collapse=" "))
      tree <- find3(paste(splitUnlist(input)[3:4], collapse=" "))
      too <- find2(paste(splitUnlist(input)[4], collapse=" "))   
      return (paste(phive, phour, tree, too, sep=","))
}

finder <- function(text) {
      nWords <- length(splitUnlist(text))
      if (nWords > 4) {
            text <- paste(tail(splitUnlist(text), n=4), collapse=" ")
            nxtWord <- find5(text)
            if (nxtWord == 'i dont know') {
                  nxtWord <- find4(paste(splitUnlist(text)[2:4], collapse=" "))
            }
            if (nxtWord == 'i dont know') {
                  nxtWord <- find3(paste(splitUnlist(text)[3:4], collapse=" "))
            }
            if (nxtWord == 'i dont know') {
                  nxtWord <- find2(paste(splitUnlist(text)[4], collapse=" "))
            }
      }
      if (nWords == 4) {
            nxtWord <- find5(text)  
            if (nxtWord == 'i dont know') {
                  nxtWord <- find4(paste(splitUnlist(text)[2:4], collapse=" "))
            }
            if (nxtWord == 'i dont know') {
                  nxtWord <- find3(paste(splitUnlist(text)[3:4], collapse=" "))
            }
            if (nxtWord == 'i dont know') {
                  nxtWord <- find2(paste(splitUnlist(text)[4], collapse=" "))
            }
      }
      if (nWords == 3) {
            nxtWord <- find4(text)
      }
      if (nWords == 2) {
            nxtWord <- find3(text)
      }
      if (nWords == 1) {
            nxtWord <- find2(text)
      }
      return (nxtWord)
}

write.table(fiveDF, file="fiveGrams")
# fiveGrams <- read.table("fiveGrams", skip = 1)
write.table(fourDF, file="fourGrams")
# fourGrams <- read.table("fourGrams", skip = 1)
write.table(threeDF, file="threeGrams")
# threeGrams <- read.table("threeGrams", skip = 1)
write.table(twoDF, file="twoGrams")
# twoGrams <- read.table("twoGrams", skip = 1)








