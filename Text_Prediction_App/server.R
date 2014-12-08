library(shiny)

shinyServer(function(input, output) {
      
      fiveGrams <- read.table("fiveGrams", skip = 1)
      names(fiveGrams) <- c("words", "count")
      fourGrams <- read.table("fourGrams", skip = 1)
      names(fourGrams) <- c("words", "count")
      threeGrams <- read.table("threeGrams", skip = 1)
      names(threeGrams) <- c("words", "count")
      twoGrams <- read.table("twoGrams", skip = 1)
      names(twoGrams) <- c("words", "count")
      
      output$userText <- renderText({
            input$text
      })
      
      output$prediction <- renderText({
            finder(gsub("[[:punct:]]", "", tolower(input$text)))
      })
      
      #output$fullPhrase <- renderText({
      #      paste(input$text, finder(gsub("[[:punct:]]", "", tolower(input$text))))
      #})
})