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
                                dropdown(
                                  
                                  tags$h3("Controls"),
                                  
                                  
                                  
                                  pickerInput(
                                    inputId = "in_totalSpendingOverTime",
                                    label = "Select Line Items:", 
                                    choices = list(`Hierarchy 1` = sort(unique(fin_data$model_outputs_validated))[1:15],
                                                   `Hierarchy 2` = sort(unique(fin_data$model_outputs_validated))[16:32]),
                                    selected = sort(unique(fin_data$model_outputs_validated)),
                                    options = list(
                                      `actions-box` = TRUE,
                                      `size` = 8), 
                                    multiple = TRUE,
                                  )
                                  
                                  
                                  ,
                                  
                                  circle = TRUE, status = "danger",
                                  icon = icon("gear"),size = "xs",
                                  
                                  tooltip = tooltipOptions(title = "Click to see inputs !")
                                ),
                                ),
                       tabPanel("More Info", DTOutput("out_totalSpendingOverTime_info"))
                         )
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
