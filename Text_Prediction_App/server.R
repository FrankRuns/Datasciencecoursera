library(shiny)

shinyServer(function(input, output) {
      
      # read gram files
      fiveGrams <- read.table("fiveGrams", skip = 1)
      names(fiveGrams) <- c("words", "count")
      fourGrams <- read.table("fourGrams", skip = 1)
      names(fourGrams) <- c("words", "count")
      threeGrams <- read.table("threeGrams", skip = 1)
      names(threeGrams) <- c("words", "count")
      woGrams <- read.table("twoGrams", skip = 1)
      names(twoGrams) <- c("words", "count")
      
      # save the user input
      output$userText <- renderText({
            input$text
      })
      
      # get the next words and output the bar plot
      output$wordPlot <- renderPlot({
            findit(gsub("[[:punct:]]", "", tolower(input$text)))
      })
      
      #output$fullPhrase <- renderText({
      #      paste(input$text, finder(gsub("[[:punct:]]", "", tolower(input$text))))
      #})
})