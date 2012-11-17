library(shiny)
library(stringr)
library(ggplot2)

Running = read.delim("~/ShinyApps/ChaseCorporateMF2012", header = TRUE, sep = "\t")

Hours <- as.integer(((str_extract(str_extract(as.character(Running$Time),"^[0-9]:"),"[0-9]"))))
Hours[is.na(Hours)] <- 0
Minutes <- as.integer(str_extract(str_extract(as.character(Running$Time),"[0-9][0-9]:"),"[0-9][0-9]"))
Seconds <- as.integer(str_extract(str_extract(as.character(Running$Time),":[0-9]*"),"[0-9][0-9]"))
TotalTime <- Hours*3600+Minutes*60+Seconds

Running <- cbind(Running,TotalTime)

x <- Running[with(Running,order(TotalTime)), ]
qplot(TotalTime/60,Name, data = x, color = Gender)

x <- transform(x,Name=reorder(Name, TotalTime) ) 

shinyServer(function(input, output) {
  
  # Compute the forumla text in a reactive function 
  formulaText <- reactive(function() {
    paste(input$variable," ",sep='')
  })
  
  # Return the formula text for printing as a caption
  output$caption <- reactiveText(function() {
    formulaText()
  })
  
  # Generate a plot of the requested variable using the selected company name
  output$Runners <- reactivePlot(function() {
#     if (checkboxInput$histogramPlot == FALSE) {
# #                                 #   p <- qplot(TotalTime/60,data = subset(subset(x,Company == paste(input$company)),Gender != paste(input$variable,'')),binwidth=1, fill=Gender)+ylab("Runner Count")+xlab("Minutes") + scale_y_continuous(breaks=seq(0, 10, 1))
# #                                     p <- qplot(TotalTime/60,Name, data = subset(subset(x,Company == paste(input$company)),Gender != paste(input$variable,'')), color = Gender)+xlab("Minutes")+ylab("Runner")+ ggtitle("Histogram")
# #                                    print(p)}
#       print("YES")}
#   else {
    if (input$company == "ALL") {
      p <- qplot(TotalTime/60,Name, data = subset(x,Gender != paste(input$variable,'')), color = Gender)+xlab("Minutes")+ylab("Runner")+ ggtitle(paste(input$company))
      print(length(data))
      print(p)
    } else {
      p <- qplot(TotalTime/60,Name, data = subset(subset(x,Company == paste(input$company)),Gender != paste(input$variable,'')), color = Gender)+xlab("Minutes")+ylab("Runner")+ ggtitle(paste(input$company))
      print(p)
     }
  }, height = 60+as.integer(12*nrow(subset(subset(x,Company == paste(input$company)),Gender != paste(input$variable,'')))))
  
})
