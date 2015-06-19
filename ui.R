# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

# Fix tag("div", list(...)) : could not find function "showOut… 
library(rCharts)

shinyUI(
    navbarPage("San Francisco Crimes Explorer",
               tabPanel("Plot",
                        sidebarPanel(
                            sliderInput("range", 
                                        "Range:", 
                                        min = 2003, 
                                        max = 2015, 
                                        value = c(2003, 2015),
                                        format="####"),
                            uiOutput("CategoryControls"),
                            actionButton(inputId = "clear_all", label = "Clear selection", icon = icon("check-square")),
                            actionButton(inputId = "select_all", label = "Select all", icon = icon("check-square-o"))
                        ),
                        
                        mainPanel(
                            tabsetPanel(
                                                    
                                # Time series data
                                tabPanel(p(icon("line-chart"), "By year"),
                                         column(4,
                                                uiOutput("time_of_dayControls")
                                         ),
                                         column(12,
                                         plotOutput("countsOfCrimeByYear")
                                         )
                                )
                                )
                            )
                        
                        ),
               tabPanel("About",
                        mainPanel(
                            includeMarkdown("include.md")
                        )
               )
                        
               )               
    
)
