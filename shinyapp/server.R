#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  suggestion1 <- reactive(input$suggestion1$label)
  suggestion2 <- reactive(input$suggestion2$label)
  suggestion3 <- reactive(input$suggestion3$label)

  eventReactive(input$suggestion1, suggestion1)
  eventReactive(input$suggestion2, suggestion2)
  eventReactive(input$suggestion3, suggestion3)

  output$text <- renderText({
    paste(input$text, suggestion1)
  })

  output$suggestion1 <- renderUI({
    actionButton("suggestion1", label = "hey")
  })
  output$suggestion2 <- renderUI({
    actionButton("suggestion2", label = "how")
  })
  output$suggestion3 <- renderUI({
    actionButton("suggestion3", label = "ru")
  })

})
