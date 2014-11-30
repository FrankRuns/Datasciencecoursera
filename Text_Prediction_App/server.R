library(shiny)

shinyServer(function(input, output) {
      
      fiveGrams <- read.table("fiveGrams", skip = 1)
      fourGrams <- read.table("fourGrams", skip = 1)
      threeGrams <- read.table("threeGrams", skip = 1)
      twoGrams <- read.table("twoGrams", skip = 1)
      
      output$userText <- renderText({
            input$text
      })
      
      output$prediction <- renderText({
            finder(gsub("[[:punct:]]", "", tolower(input$text)))
      })
      
      output$fullPhrase <- renderText({
            paste(input$text, finder(gsub("[[:punct:]]", "", tolower(input$text))))
      })
})