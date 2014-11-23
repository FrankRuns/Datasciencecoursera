library(shiny)

shinyServer(function(input, output){

	PROD <- read.csv("warehouse.csv", header=TRUE)

	output$accountInput <- reactive({
	  switch(input$account,
	         "Calvin Klein" = 'Calvin Klein',
	         "JCrew GOH" = "JCrew GOH",
	         "Rad Booty Apparel" = "Rad Booty Apparel")
	})  
  
  accountInput <- reactive({
		switch(input$account,
			"Calvin Klein" = 'Calvin Klein',
			"JCrew GOH" = "JCrew GOH",
			"Rad Booty Apparel" = "Rad Booty Apparel")
	})

	output$summary <- renderDataTable({
		account <- accountInput()
		dataset <- subset(PROD, PROD$Account == account)
		dataset$DateActivity <- as.Date(dataset$DateActivity, format="%m/%d/%Y")
		SUB1 <- subset(dataset, format.Date(DateActivity, "%m") == '12')  
		SUB2 <- data.frame(SUB1$Task, round(SUB1$Quantity), round(SUB1$ManHours))
		names(SUB2) <- c("Task", "Quantity", "ManHours")
		FINAL <- merge(aggregate(Quantity ~ Task, SUB2, FUN=sum), aggregate(ManHours ~ Task, SUB2, FUN=sum))
		FINAL$UPH <- round(FINAL$Quantity / FINAL$ManHours)
		FINAL
	})
})
