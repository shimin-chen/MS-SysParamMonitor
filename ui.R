library(shiny)
library(readr)
library(tidyverse)
library(shinyWidgets)

unit <- read_csv("msparam_unit.csv") 
unit <- unit[unit$ColName !="Date",]

shinyUI(fluidPage(
  
  titlePanel("MS Parameters"),
  
  sidebarPanel(

    fileInput("file2", "Choose Log Files (InstrumentTemperature Log Files)",
              multiple = TRUE,
              accept = ".log"),
    
    selectInput("param","Parameters",
                choices = sort(unique(unit$SimpleName)), 
                selected = "TURBO2_TEMP_BEARING"),
    uiOutput("date_ui")
  ),
  mainPanel(
    tabsetPanel(

      tabPanel("Visualization",
               plotOutput("param_change"),
               uiOutput("plotdownload_ui"))
               ,
      tabPanel("Data",
               downloadLink('downloadData', 'Download CSV File')
      )

    )
  )))




