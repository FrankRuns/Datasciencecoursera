library(shiny)

shinyUI(navbarPage("NextWord",
        
      tabPanel("About",
               
               fluidPage(
                     
                     fluidRow(
                           column(12, id="row1", 
                                  h1("for Text Prediction")
                           )
                     ),
                     
                     fluidRow(
                           column(6,
                                  p("NextWords utilizes a corpus of text from tweets, blog posts, and news articles in order to accept a user string of words and predict the next most likely word in that phrase along with 6 other probable words according to how frequently that phrase occurs in the corpus. The original corpus, of which this text prediction app utilizes 20% of the English set, can be downloaded", a(href="https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip", "here.")),
                                  p("The process for this task is rather simple. The challenge is finding a balance between speed (how long the app takes to display the output) and efficiency (how often the next word is correctly predicted). In order to increase speed, we’ve used only 20% of the text which yields an acceptable correct prediction rate for the purposes of this project."),
                                  p("The entire app was/is processed in", a(href="http://en.wikipedia.org/wiki/R_%28programming_language%29", "R"), "along with", a(href="https://www.shinyapps.io/", "Shiny"), "from RStudio. Initially, the tm package was used extensively to explore the dataset, clean the text, and build the algorithm. Eventually in order to improve data prep time, tm was phased out in favor of basic gsub and regex expressions for cleaning the data, the stylo package for building", a(href="http://en.wikipedia.org/wiki/N-gram", "n-grams"), "and data.table for looking up and sorting the polished n-grams."),
                                  p("What’s next? NextWords is a solid foundation for creating a truly commercial-viable text prediction tool. Future improvements can include improving speed & accuracy as well as adding functionality such as part of speech & language recognition, the option to remove swear words, predicting punctuation & emoticons, or responding to full questions rather than just predicting next words (like Siri). The project in its current form lives on github at this", a(href="https://github.com/FrankRuns/Datasciencecoursera/tree/master/Text_Prediction_App", "link.")),
                                  p("created and built by FC", style="color:gray")
                           )      
                     )
               )
      ),
      tabPanel("Main",
               
               fluidPage(
                     # header row            
                     fluidRow(
                           column(12, id="row1", 
                                  h1("for Text Prediction")
                           )
                     ),
                     # row for explanatory paragraph
                     fluidRow(
                           column(6, id="row1-1",
                                  p(width = 2, "Input a phrase in the text box below and click 'Predict Next Words'. A barplot will be generated showing the most likely next word in your phrase as well as up to 6 other probable words. For best results, use proper spelling and", em("patience."))
                           )
                     ),
                     # text input row
                     fluidRow(    
                           column(12, id="row2",
                                  textInput("text", "",value="in the middle of the"),
                                  submitButton("Predict Next Words"),
                                  p()
                           )
                     ),
                     # text output row
                     fluidRow(    
                           column(12, id="row3",
                                  strong("Your text input is: "),      
                                  textOutput("userText")
                           )
                     ),
                     # bar graph row
                     fluidRow(    
                           column(6, id="row4",
                                  plotOutput("wordGraph")
                           )
                     )
               )
      )
))