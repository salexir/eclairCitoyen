server <- function(input, output){

  
  ## Category Spending Things --------------------------------------------------
  ## Merchant Analysis Things --------------------------------------------------
  ## Time Series Analysis Things -----------------------------------------------
  
  ### Total Spending Over Time -------------------------------------------------
  
  totalSpendingOverTime <- 
    reactive({
      
      fin_data %>%
        filter(model_outputs_validated %in% input$in_totalSpendingOverTime) %>%
        group_by(model_outputs_validated, Date) %>%
        summarise(Total_Spends = sum(Split_Amount))
      
      
    })
  
  output$out_totalSpendingOverTime <-
    renderPlot(
      totalSpendingOverTime() %>%
        ggplot(aes(x = Date, y = Total_Spends, colour = model_outputs_validated,
                   group = model_outputs_validated)) + 
        geom_point() + geom_line() + scale_x_date(breaks = "6 months") + theme_lab() + scale_y_continuous(labels = scales::dollar) + 
        ggtitle("Spending Over Time, by Category") + ylab("Nominal CAD ($)") + xlab("YYYY-MM") + theme(legend.title = element_blank())
      
    )
  
  output$out_totalSpendingOverTime_info <- renderDT({
    brushedPoints(totalSpendingOverTime(), input$plot_brush)
  })
  
  
  
  ## Spending Patterns Things --------------------------------------------------
  ## Full Data Table  ----------------------------------------------------------
  
  output$out_fullDataTable <- renderDT(fin_data %>% select(input$in_fullDataTable), filter = "top")
                                       

  
  
  
}