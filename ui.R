
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

fluidPage(
  h1("The next word predict app"),
  # Copy the line below to make a text input box
  textInput("text", label = h3("Type text to predict the next word:"), value = ""),
  
  hr(),
  h3("suggested words:"),
  fluidRow(column(3, verbatimTextOutput("value"))),
  submitButton('Predict')
  
)