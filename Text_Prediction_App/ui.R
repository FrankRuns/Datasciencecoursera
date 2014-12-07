library(shiny)

shinyUI(fluidPage(
      
      titlePanel("Experiments in Predicting the Next Word"),
      
      sidebarLayout(
            sidebarPanel(
                  textInput("text", "Enter phrase here:", "cool to be the"),
                  submitButton("Predict Next Word", icon = NULL)
            ),
            
            mainPanel(
                  h4("You wrote..."),
                  textOutput("userText"),
                  h4("The next word prediction is..."),
                  textOutput("prediction"),
                  h4("And the full predicted phrase..."),
                  textOutput("fullPhrase")
            )
      )
))