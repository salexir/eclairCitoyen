server <- function(input, output){
  
  
  ## Category Spending Things --------------------------------------------------
  
  
  
  totalSpendingOverTime_rolledUp <-
    reactive({
      fin_data %>%
        filter(category %in% input$in_totalSpendingOverTime_rolledUp,
               category != "Non-Spend") %>%
        group_by(yyyymm, category) %>%
        summarise(Total_Spends = (sum(Signed_Split_Amount))*-1) %>%
        ungroup() %>%
        mutate(yyyymm = as.Date(paste0(yyyymm, "-01"))) # Allows for nicer date output in ggplot
      
    })
  
  
  output$out_totalSpendingOverTime_rolledUp <-
    renderPlot(
    
      totalSpendingOverTime_rolledUp() %>% 
        ggplot(aes(x = yyyymm, y = Total_Spends, colour = category, group = category)) + 
        geom_line() + 
        geom_point() + 
        geom_smooth(se = FALSE) + 
        scale_x_date(date_labels = "%b %y", date_breaks = "1 month", 
                     date_minor_breaks = "3 month", 
                     limits = c(as.Date("2021-01-01"), NA)) + 
        theme_lab() + scale_y_continuous(labels = scales::dollar) +   
        ggtitle("Spending by Category, over time") + ylab("Nominal CAD ($)") + 
        xlab("YYYY-MM") + 
        theme(legend.title = element_blank())
    
    )
  
  output$out_totalSpendingOverTime_rolledUp_info <- renderDT({
    brushedPoints(totalSpendingOverTime_rolledUp(), input$plot_brush)
  })
  
  totalSpendingOverTime <- 
    reactive({
      
      fin_data %>%
        filter(model_outputs_validated %in% input$in_totalSpendingOverTime) %>%
        group_by(model_outputs_validated, Date) %>%
        summarise(Total_Spends = (sum(Signed_Split_Amount))*-1)
      
      
    })
  
  output$out_totalSpendingOverTime <-
    renderPlot(
      totalSpendingOverTime() %>%
        ggplot(aes(x = Date, y = Total_Spends, colour = model_outputs_validated,
                   group = model_outputs_validated)) + 
        geom_point() + geom_line() +  
        scale_x_date(date_labels = "%b %y", date_breaks = "3 month", date_minor_breaks = "1 month", limits = c(as.Date("2021-01-01"), NA)) + theme_lab() + scale_y_continuous(labels = scales::dollar) + 
        ggtitle("Spending by Category, over time") + ylab("Nominal CAD ($)") + xlab("YYYY-MM") + 
        theme(legend.title = element_blank(),
              panel.grid.minor.x = element_line(size = 0.15, color = "#f1f1f1", linetype = "longdash"),
              panel.grid.major.x = element_line(size = 0.25, color = "#cbcbcb", linetype = "longdash")
        )
      
    )
  
  output$out_totalSpendingOverTime_info <- renderDT({
    brushedPoints(totalSpendingOverTime(), input$plot_brush)
  })
  
  
  output$out_totalSpendingOverTime_table <- renderDT({
    
    fin_data %>%
      filter(category != "Non-Spend",
             yyyy == input$in_totalSpendingOverTime_table) %>%
      mutate(num_months = n_distinct(yyyymm)) %>%
      group_by(yyyy, yyyymm, num_months, model_outputs_validated) %>%
      summarise(Total = round(sum(Signed_Split_Amount)*-1, digits = 2)) %>%
      mutate(month_viz = format(as.Date(paste0(yyyymm, "-01")), "%b %Y")) %>%
      group_by(yyyy, model_outputs_validated) %>%
      mutate(YTD = round(sum(Total), 2),
             Monthly_Average = round(YTD/num_months, 2)) %>%
      ungroup() %>%
      select(-c(yyyymm, num_months, yyyy)) %>%
      pivot_wider(names_from = month_viz, values_from = Total) %>%
      relocate(c(YTD, Monthly_Average), .after = last_col()) %>%
      arrange(model_outputs_validated)
    
  })
  
  
  comparativeSpends <- 
    reactive({
      
      fin_data %>% 
        filter(model_outputs_validated %in% input$in_comparativeSpends_monthly_yoy) %>%
        mutate(month = factor(format(Date, "%b"), month.abb, ordered = TRUE)) %>% 
        group_by(yyyy, month, model_outputs_validated) %>% 
        summarise(Total_Spends = sum(Split_Amount))
      
    })
  
  
  output$out_comparativeSpends_monthly_yoy <- renderPlot({
    
    comparativeSpends() %>% 
      ggplot(aes(x = month, y = Total_Spends, fill = yyyy, group = yyyy)) + 
      geom_col(position = "dodge") +
      facet_wrap(~model_outputs_validated) + 
      scale_fill_brewer(type = "seq") + 
      theme_lab() + scale_y_continuous(labels = scales::dollar)
    
    
    
  })
  
  ## Merchant Analysis Things --------------------------------------------------
  ## Time Series Analysis Things -----------------------------------------------
  
  ### Total Spending Over Time -------------------------------------------------
  
  data_input1 <- dataInputServer("input1")
  
  output$test_edit <- renderRHandsontable(rhandsontable(iris))
  
  
  
  
  ## Spending Patterns Things --------------------------------------------------
  
  output$out_number_of_transactions <- renderDT({
    
    fin_data %>%
      filter(category != "Non-Spend",
             yyyy %in% input$in_number_of_transactions, 
             Transaction_Type == "Debit") %>% # Refunds (via crediting) don't count as a distinct transaction, hence removed.
      mutate(num_months = n_distinct(yyyymm)) %>%
      group_by(yyyy, yyyymm, num_months, model_outputs_validated) %>%
      summarise(Number_of_transactions =n() ) %>%
      mutate(month_viz = format(as.Date(paste0(yyyymm, "-01")), "%b %Y")) %>%
      group_by(yyyy, model_outputs_validated) %>%
      mutate(YTD = round(sum(Number_of_transactions), 2),
             Monthly_Average = round(YTD/num_months, 2)) %>%
      ungroup() %>%
      select(-c(yyyymm, num_months, yyyy)) %>%
      pivot_wider(names_from = month_viz, values_from = Number_of_transactions) %>%
      relocate(c(YTD, Monthly_Average), .after = last_col()) %>%
      arrange(model_outputs_validated)
    
  })
  
  
  ## Budget Making  ------------------------------------------------------------
  
  historical_averages <- 
    reactive({
      
      fin_data %>% 
        # Filtering out years without 12 month of data:
        group_by(yyyy) %>% 
        mutate(n_months = length(unique(yyyymm))) %>% 
#        filter(n_months == 12) %>%
        group_by(yyyy, model_outputs_validated) %>% 
        summarise(`Num Transactions` = n(), 
                  Total_Spends = sum(Signed_Split_Amount)*-1,
                  Monthly_Average = round(Total_Spends/first(n_months), 2)) %>% 
        select(-Total_Spends) %>%
        pivot_wider(names_from = yyyy, values_from = c(`Num Transactions`, Monthly_Average))
      
      
      
    })
  
  output$out_historical_averages <- renderDT(historical_averages())
  
  ### Data Edit Section ----

  #### Editor
  budget_edit <- dataEditServer("budget_edit", data = budget_table, col_stretch = TRUE)
  
  

  ### Data Output Section ----
  final_budget <- reactive({budget_edit() %>% 
                         mutate(Pred_yearly_spend = budgeted_amount * frequency,
                                Pred_monthly_spend = Pred_yearly_spend/12) %>%
                         relocate(Pred_yearly_spend, .after = last_col())})
  
  output$out_view_budget_final <- renderDT(final_budget())
  
  
  
  dataOutputServer(id = "save_budget", data = final_budget) # Important to not use the function form here.
  
  
  ## Full Data Table  ----------------------------------------------------------
  
  output$out_fullDataTable <- renderDT(fin_data %>% select(input$in_fullDataTable), filter = "top")
  
  
  
  
  
}