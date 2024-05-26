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
                                  
                                 
                                  virtualSelectInput(
                                    inputId = "in_totalSpendingOverTime",
                                    label = "Select groups :",
                                    choices = list(`Needs` = list(ui_inputs$Needs),
                                                   `Discretionary` = list(ui_inputs$Discretionary),
                                                   `Investment` = list(ui_inputs$Investment),
                                                   `Loan` = list(ui_inputs$Loan),
                                                   `Misc.` = list(ui_inputs$Misc.)),
                                    selected = ui_inputs$Needs,
                                    multiple = TRUE,
                                    search = TRUE,
                                    optionsCount = 5
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
