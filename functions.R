# df <- training
#  year_min <- min(df$Year)
#  year_max <- max(df$Year)
#  category <- df$Category
#  time_of_day <- c("DayTime", "NightTime", "AllDay")

#' Aggregate dataset by year and timeofday
#' 
#' @param df dataframe
#' @param year_min integer
#' @param year_max integer
#' @param time_of_day factor
#' @param category character vector
#' @return dataframe
#'
aggregate_by_year_and_timeofday <- function(df, year_min, year_max, category, time_of_day) {
    
    
    # Create T1 (Total Counts by year)
    t1 <- df %>% filter(Year >= year_min, Year <= year_max, Category %in% category) %>%
            # Group and aggregate
            group_by(Year) %>% summarise(Count = sum(Category))
    t1$TimeCategory <- "AllDay"
    t1 <- t1[,c(1,3,2)]
   
        
    # Create T2 
    t2 <- df %>% filter(Year >= year_min, Year <= year_max, Category %in% category, TimeCategory %in% time_of_day) %>%
            # Group and aggregate
            group_by(Year, TimeCategory) %>% summarise(Count = sum(Category)) 
    
    # Return final df
    rbind(t1,t2)
}

#' Plot of Counts of crime by Year
#' @param df dataframe created by aggregate_by_year_and_timeofday()

plot_by_year_and_timeofday <- function(df){
    ggplot(df, aes(x=Year, y=Count, color=TimeCategory)) +
        geom_point(color="blue") + geom_line() +
        scale_x_continuous(breaks=min(df$Year):max(df$Year)) +
        #ylim(0,160000) +
        labs(x="Year", y="Counts of crime", title="Number of counts of crime by Year") +
        theme_bw() +
        theme(title = element_text(face="bold"))
}
    
   