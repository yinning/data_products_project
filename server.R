library(shiny)

# Plotting 
library(ggplot2)
library(rCharts)
library(ggvis)

# Data processing libraries
library(reshape2)
library(dplyr)

# Required by includeMarkdown
library(markdown)

#Required for dates manipulation
library(lubridate)

# Load helper functions
source("functions.R", local = TRUE)


# Load data
df <- read.csv('./data/training.csv',
               colClasses=c(rep("character", 3), rep("factor", 3), rep("character", 3)))

# Process data
df$Dates <- as.POSIXct(strptime(df$Dates, format = "%Y-%m-%d %H:%M:%S"))
df$Date <- as.Date(df$Dates)
df$Time <- format(df[,"Dates"], "%H:%M:%S")
df$TimeCategory <- ifelse(hour(df$Dates) >= 7 & hour(df$Dates) < 19, "DayTime", "NightTime")
df$Year <- year(df$Date)
df$DayOfWeek <- factor(df$DayOfWeek, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))


# Create variables for usage
Category <- sort(unique(df$Category))
time_of_day <- c("DayTime", "NightTime")

#Process data again
df$Category <- as.factor(df$Category)

# Shiny server 
shinyServer(function(input, output, session) {
    
    # Define and initialize reactive values
    values <- reactiveValues()
    values$Category <- Category
    
    # Create Category type checkbox
    output$CategoryControls <- renderUI({
        checkboxGroupInput('Category', 'Crime Category', Category, selected=values$Category)
    })
    
    # Create Time of the day category type checkbox
    output$time_of_dayControls <- renderUI({
        checkboxGroupInput('time_of_day', 'Time of the Day when crime happened', time_of_day, selected=values$time_of_day)
    })
    
    # Add observers on clear and select all buttons
    observe({
        if(input$clear_all == 0) return()
        values$Category <- c()
    })
    
    observe({
        if(input$select_all == 0) return()
        values$Category <- Category
    })
    
    # Prepare datasets
    
    # Prepare dataset for Counts of crime by Year plot
    df_agg <- reactive({
        aggregate_by_year_and_timeofday(df, input$range[1], input$range[2], input$Category, input$time_of_day)
    })
   
     
    # Render Plots
    
    # Counts of crime by Year and Time of day
    output$countsOfCrimeByYear <- renderPlot({
        print(plot_by_year_and_timeofday(df = df_agg()))
    })
    
        
    

})

