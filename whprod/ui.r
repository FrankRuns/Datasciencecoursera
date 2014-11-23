library(shiny)

shinyUI(pageWithSidebar(

      headerPanel("Warehouse Productivity Tracker"),

      sidebarPanel(
            selectInput("account", 'Choose an Account', choices = c('Calvin Klein', 'JCrew GOH', 'Rad Booty Apparel')),
            submitButton("update view"),
            br(),
            helpText("Select the account in your warehouse to view labor productivity table for the month of December 2013 and click 'update view'. Units per Hour (UPH) is calculated as Quantity of units processed divided by the required ManHours to process them. For example, in this current Calvin Klein view the average rate to Label Cartons was 83 cartons per hour. Look at the UPH for 'Receive GOH' between Calvin Klein and Rad Booty Apparel and we being to see why this tool might be so powerful."),
            br(),
            em("*Note: This is a prototype app to acheive funding for a fuller, more functional interactive application."),
            br(),
            br(),
            em("*Note: You can view the code for this application on github at this link: https://github.com/FrankRuns/whprod")
      ), 

      mainPanel(
            verbatimTextOutput("accountInput"),
            h4("Productivity Summary for December 2013"),
            dataTableOutput("summary")
      )
))

