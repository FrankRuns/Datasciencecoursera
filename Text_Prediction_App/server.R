library(shiny)

# read gram files
# sample of twoGrams looks like this...
# "words", "count"
# "and the", 40,203
# "and was", 40,155

# TODO: explore package "fread"
library(data.table)

fiveGrams <- fread("fiveGrams")
setnames(fiveGrams, 1:3, c("rowNum", "words", "count"))
setkey(fiveGrams, words)
setorder(fiveGrams, -count)

fourGrams <- fread("fourGrams")
setnames(fourGrams, 1:3, c("rowNum", "words", "count"))
setkey(fourGrams, words)
setorder(fourGrams, -count)

threeGrams <- fread("threeGrams")
setnames(threeGrams, 1:3, c("rowNum", "words", "count"))
setkey(threeGrams, words)
setorder(threeGrams, -count)

twoGrams <- fread("twoGrams")
setnames(twoGrams, 1:3, c("rowNum", "words", "count"))
setkey(twoGrams, words)
setorder(twoGrams, -count)

# helper function to split a string by space and convert to character from list
splitUnlist <- function(text){
      return (unlist(strsplit(text, " ")))
}

# function to find 5th word in a 5gram
dt5 <- function(t) {
      if (length(grep(paste0("^", t, " "), fiveGrams$words)) > 0) {
            # TODO: how about take top 10 and remove NA values?
            sub <- fiveGrams[grep(paste0("^", t, " "), fiveGrams$words), ]
            for (i in 1:length(sub$words)) {
                  sub$words[i] <- splitUnlist(sub$words[i])[5]
            }
            # take only the top 10 results if there are more than 10 results
            if (length(sub$words > 7)) {
                  sub <- head(sub, n=7)
            }
            barplot(sub$count, names.arg=c(sub$words), ylab="Frequency", col = "steelblue") 
      } else {
            return (dt4(paste(splitUnlist(t)[2:4], collapse=" ")))
      }
}

# function to find 4th word in a 4gram

dt4 <- function(t) {
      if (length(grep(paste0("^", t, " "), fourGrams$words)) > 0) {
            # TODO: how about take top 10 and remove NA values?
            sub <- fourGrams[grep(paste0("^", t, " "), fourGrams$words), ]
            for (i in 1:length(sub$words)) {
                  sub$words[i] <- splitUnlist(sub$words[i])[4]
            }
            # take only the top 10 results if there are more than 10 results
            if (length(sub$words > 7)) {
                  sub <- head(sub, n=7)
            }
            barplot(sub$count, names.arg=c(sub$words), ylab="Frequency", col = "steelblue") 
      } else {
            return (dt3(paste(splitUnlist(t)[2:3], collapse=" ")))
      }
}

# function to find 3rd word in a 3gram
dt3 <- function(t) {
      if (length(grep(paste0("^", t, " "), threeGrams$words)) > 0) {
            # TODO: how about take top 10 and remove NA values?
            sub <- threeGrams[grep(paste0("^", t, " "), threeGrams$words), ]
            for (i in 1:length(sub$words)) {
                  sub$words[i] <- splitUnlist(sub$words[i])[3]
            }
            # take only the top 10 results if there are more than 10 results
            if (length(sub$words > 7)) {
                  sub <- head(sub, n=7)
            }
            barplot(sub$count, names.arg=c(sub$words), ylab="Frequency", col = "steelblue") 
      } else {
            return (dt2(paste(splitUnlist(t)[4], collapse=" ")))
      }
}

# function to find 2nd word in a 2gram
dt2 <- function(t) {
      if (length(grep(paste0("^", t, " "), twoGrams$words)) > 0) {
            # TODO: how about take top 10 and remove NA values?
            sub <- twoGrams[grep(paste0("^", t, " "), twoGrams$words), ]
            for (i in 1:length(sub$words)) {
                  sub$words[i] <- splitUnlist(sub$words[i])[2]
            }
            # take only the top 10 results if there are more than 10 results
            if (length(sub$words > 7)) {
                  sub <- head(sub, n=7)
            }
            barplot(sub$count, names.arg=c(sub$words), ylab="Frequency", col = "steelblue") 
      } else {
            return ("sorry")
      }
}

# function to aggregate and call f functions above depending upon user input word length
findit <- function(text) {
      nWords <- length(splitUnlist(text))
      if (nWords > 4) {
            text <- paste(tail(splitUnlist(text), n=4), collapse=" ")
            dt5(text) 
      }
      if (nWords == 4) {
            dt5(text)
      }
      if (nWords == 3) {
            dt4(text)
      }
      if (nWords == 2) {
            dt3(text)
      }
      if (nWords == 1) {
            dt2(text)
      }
}

shinyServer(function(input, output) {
      
      output$userText <- renderText({
            input$text
      })
      
      output$wordGraph <- renderPlot({
            findit(gsub("[[:punct:]]", "", tolower(input$text)))
      })
      
})