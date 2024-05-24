ui <- dashboardPage(
  
  
  dashboardHeader(title = "eclairCitoyen"),
  
  dashboardSidebar(
    
    sidebarMenu(
      
      menuItem(" | Category Spending", tabName = "categorySpending", icon = icon("chart-column")),
      
      menuItem(" | Merchant Analysis", tabName = "merchantAnalysis", icon = icon("store")),
      
      menuItem(" | Time-series Analysis", tabName = "tsAnalysis", icon = icon("hourglass-half")),
      
      
      menuItem(" | Spending Patterns", tabName = "spendingPatterns", icon = icon("basket-shopping")),
      
      
      menuItem(" | Full Data Table", tabName = "fullDataTable", icon = icon("table-cells"))
      
      # Heatmap by month spends could be cool!
      
      
    )
    
    
  ),
  
  dashboardBody(
    

    
    
    tabItems(
      tabItem(tabName = "tsAnalysis",
              fluidRow(
                tabBox(width = 9, 
                       title = "",
                       id = "spendingOverTime_tabbox",
                       tabPanel("Graph", 
                                plotOutput(outputId = "out_totalSpendingOverTime", brush = "plot_brush"),
                                checkboxGroupInput(inputId = "in_totalSpendingOverTime", label = "Select Line Items:",
                                                   choices = sort(unique(fin_data$model_outputs_validated)),
                                                   selected = sort(unique(fin_data$model_outputs_validated)), inline = TRUE)),
                       tabPanel("Controls")),
                box(width =  3,  collapsible = TRUE,
                    DTOutput("out_totalSpendingOverTime_info"))#,
                # box(width =  3,  collapsible = TRUE,
                #     checkboxGroupInput(inputId = "in_totalSpendingOverTime", label = "Select Line Items:",
                #                         choices = sort(unique(fin_data$model_outputs_validated)),
                #                         selected = sort(unique(fin_data$model_outputs_validated))))
              )
              
              
      ),
      tabItem(tabName = "fullDataTable",
              
              fluidRow(
                tabBox(width = 12,
                  title = "Financial Data Table", id = "dataTable_tabbox",
                  tabPanel("Table", DTOutput(outputId = "out_fullDataTable")),
                  tabPanel("Controls", checkboxGroupInput(inputId = "in_fullDataTable", label = "Select Columns:", 
                                                      choices = core_fin_data_columns,
                                                      selected = core_fin_data_columns))
                )

              ))
      
      
    )
  
    
    
    
    )
    
  
  
  
)
