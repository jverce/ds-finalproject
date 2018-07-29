#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# UI for the text prediction app
shinyUI(fluidPage(

  # Application title
  titlePanel("Text Prediction"),

  # Divide the UI into 2 main sections:
  # - Text input, where the user edits the text (the suggestions are also added here)
  # - Suggestion buttons, which allow the user to pick the next suggested word
  column(12, align = "center",
    # Text input
    wellPanel(
       textAreaInput("text", label = "Text editor", height = '200px')
    ),

    # Suggestion buttons
    fluidRow(
       column(4, uiOutput("suggestion3")),
       column(4, uiOutput("suggestion1")),
       column(4, uiOutput("suggestion2"))
    )
  )
))
