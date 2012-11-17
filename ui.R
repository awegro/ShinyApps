library(shiny)

Running = read.delim("~/ShinyApps/ChaseCorporateMF2012", header = TRUE, sep = "\t")
y = unique(Running$Company)
y = y[sort.list(y)]
#heightsetting  = 60+as.integer(12*nrow(subset(subset(x,Company == paste(input$company)),Gender != paste(input$variable,''))))

# Define UI for Chase Corporate Challenge
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Chase Corporate Challenge Run 2012"),
  
  sidebarPanel(
    selectInput("company", "Company:",
                y),
    
    selectInput("variable", "Gender:",
                list("All" = "Null",
                     "Male" = "F", 
                     "Female" = "M" 
                     )),
    
    checkboxInput("histogramPlot", "Show Histogram", FALSE)
  ),
  
  mainPanel(
    plotOutput("Runners")
  )
))
