library(shiny)
library(ggplot2)
library(dplyr)
library(lubridate)
library(shinyWidgets)

shinyServer(function(input, output){
  #import the unit from another file, established based on Q Exactive Plus
  msparam_unit <- read.csv("msparam_unit.csv", encoding = "UTF-8")
  `%notin%` <- Negate(`%in%`)
  
  f3 <- reactive({
    req(input$file2)
    f3 <-  gsub("\\\\","/",input$file2[,4])
    return(f3)
  })
  
  # combine all input files together into one dataframe
  msparam <- reactive({
    msparam = do.call(rbind, lapply(f3(), function(x) read.delim(x, sep = "\t", stringsAsFactors = FALSE, encoding = "latin1")))
    msparam <- msparam %>% subset(select = -c(X, Time..sec.,Up.Time..days.)) 
    return(msparam)})
  
  # cleaning the data frame
  log_output <- reactive({
    # rows that contain the header are removed
    msparam_cleaned <- msparam()[!msparam()$Date=="Date",]
    msparam_cleaned <- msparam_cleaned %>% 
      separate(Date, into = c("Date", "Time"), sep = " ", remove = F) %>% 
      select(Date, Time, Vacuum.1..HV...mbar.:Quad.Detector.Temperature...C.)
    
    # correct column format for date and numbers
    msparam_cleaned$Date <- ymd(msparam_cleaned$Date)
    msparam_cleaned$Time <- hms(msparam_cleaned$Time)
    msparam_cleaned <- msparam_cleaned %>% mutate_if(is.character,as.numeric)
    msparam_dateOnly <- msparam_cleaned %>% subset(select = - Time)
    
    # Extract first and last day
    day1 <- min(msparam_cleaned$Date)
    day_last <- max(ymd(msparam_cleaned$Date))
    
    log_gathered_mean <- msparam_dateOnly %>% 
      group_by(Date) %>% 
      summarise_if(is.numeric, mean, na.rm = TRUE) %>% 
      ungroup() %>%
      gather(key = "Parameter", value = "Mean_Values", -Date)
    
    log_gathered_sd <- msparam_dateOnly %>% 
      group_by(Date) %>% 
      summarise_if(is.numeric, sd, na.rm = TRUE) %>% 
      ungroup() %>%
      gather(key = "Parameter", value = "Sd_Values", -Date)
    
    log_summarized <- left_join(log_gathered_sd, log_gathered_mean, by = c("Date", "Parameter"))
    return(list(log_summarized = log_summarized, 
                day1 = day1, 
                day_last = day_last))})
  
  # renderUI to get the first and last date for default date range, also allows for
  # picking which dates to exclude
  output$date_ui <- renderUI({
    log_output <- log_output()
    day1 <- log_output$day1
    day_last <- log_output$day_last
    
    tagList(
      dateRangeInput("daterange1", "Date range (default is the first and last day in the dataset):",
                     start = as.Date(day1), end = as.Date(day_last),
                     # start = Sys.Date()-100, end = Sys.Date(),
                     format = "yyyy-mm-dd"),
      airDatepickerInput(
        inputId = "multiple",
        label = "Select multiple dates to exclude (system maintenence days)",
        placeholder = "Exclude results from up to 20 dates",
        multiple = 20, clearButton = TRUE, value = NULL, minDate = as.Date(day1), 
        maxDate = as.Date(day_last))
      
    )
  })
  

  # create a download link
  output$downloadData <- downloadHandler(
    filename = function() {
      paste('MS_instrument_parameter-', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
      write.csv(log_output(), con, row.names = F)
    }
  )
  
  # create a subset data frame for generate plot
  log_subset <- reactive({
    req(input$daterange1)
    log_output <- log_output()
    log_summarized <- log_output$log_summarized
    
    log_summarized %>% filter(Parameter == msparam_unit[msparam_unit$SimpleName == input$param,1],
                              Date >= as.Date(input$daterange1[1]),
                              Date <= as.Date(input$daterange1[2]),
                              Date %notin% input$multiple
                              # Date != as.Date(input$excl_date1, tz = NULL)
    )
    
  })
  
  # Generate a plot
  param_change <- reactive({
    
    caption_text = {
      if(length(input$multiple) == 0){paste("Daily Average +/- SD")}
      else if(length(input$multiple) != 0){paste("Daily Average +/- SD", ", Date excluded:", toString(input$multiple))}}
    
    param_change <- ggplot(data = log_subset(), aes(x=Date, y=Mean_Values)) + 
      geom_point() + 
      geom_errorbar(aes(ymax = Mean_Values + Sd_Values, ymin = Mean_Values - Sd_Values)) +
      scale_x_date(date_labels = "%b-%d-%Y", date_breaks = "1 week") +
      # scale_x_datetime(date_labels = "%y%b%d", date_breaks = "1 week") +
      ggtitle(msparam_unit$Unit[msparam_unit$SimpleName ==input$param]) +
      labs(y = msparam_unit$Unit[msparam_unit$SimpleName ==input$param], 
           caption = caption_text) +
      theme(axis.text.x=element_text(angle = -45, hjust = 0)) 
    return(param_change)
    
  })
  
  output$param_change <- renderPlot(param_change())
  
  # allows for downloading the plot
  output$plotdownload_ui <- renderUI({
    req(param_change())
    downloadButton("downloadPlot", "Download PNG file")})
  
  output$downloadPlot <- downloadHandler(
    filename = function() {
      paste('MS_instrument_parameter-', input$param, '.png', sep='')
    },
    content = function(con) {
      ggsave(con, plot = param_change(), device = "png", width = 10, height = 6)
    }
  )
  
})