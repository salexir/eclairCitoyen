ui <- dashboardPage(
  
  
  dashboardHeader(title = "eclairCitoyen"),
  
  dashboardSidebar(
    
    sidebarMenu(
      
      # SideBar Options ----
      
      menuItem(" | Category Spending", tabName = "categorySpending", icon = icon("chart-column")),
      
      menuItem(" | Merchant Analysis", tabName = "merchantAnalysis", icon = icon("store")),
      
      menuItem(" | Time-series Analysis", tabName = "tsAnalysis", icon = icon("hourglass-half")),
      
      
      menuItem(" | Spending Patterns", tabName = "spendingPatterns", icon = icon("basket-shopping")),
      
      
      menuItem(" | Budget Making", tabName = "budgetMaking", icon = icon("feather")),
      
      
      menuItem(" | Full Data Table", tabName = "fullDataTable", icon = icon("table-cells"))
      
      # Heatmap by month spends could be cool!
      
      
    )
    
    
  ),
  
  dashboardBody(
      

    
    
    tabItems(
      # Tab Item: Category Spending ----
      tabItem(tabName = "categorySpending", 
              fluidRow(
                tabBox(width = 12,
                    title = "Overall Spending Trends",
                    id = "totalSpendingOverTime_rolledUp_box",
                    tabPanel("Graph",
                             plotOutput(outputId = "out_totalSpendingOverTime_rolledUp", brush = "plot_brush"),
                             dropdown(
                               tags$h3("Controls"),
                               
                               virtualSelectInput(
                                 inputId = "in_totalSpendingOverTime_rolledUp",
                                 label = "Select groups: ",
                                 choices = category_inputs,
                                 selected = category_inputs,
                                 multiple = TRUE,
                                 search = TRUE
                               ),
                               circle = TRUE, status = "danger",
                               icon = icon("gear"),size = "xs",
                               
                               tooltip = tooltipOptions(title = "Click to see inputs !")
                               
                             ),
                             
                             ),
                    tabPanel("More Info", DTOutput("out_totalSpendingOverTime_rolledUp_info")))
                    
                ,tabBox(width = 12, 
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
                ),
                box(width = 12,
                    title = "Category Spends by Month",
                    id = "spendingOverTime_monthly",
                    
                    dropdownButton(
                      
                      tags$h3("Select year:"),
                      
                      awesomeRadio(
                        inputId = "in_totalSpendingOverTime_table",
                        label = "Radio buttons", 
                        choices = sort(unique(fin_data$yyyy)),
                        selected = rev(sort(unique(fin_data$yyyy)))[1]
                      )
                      
                      
                      
                      
                      ,
                      
                      circle = TRUE, status = "danger",
                      icon = icon("gear"),size = "xs",
                      
                      tooltip = tooltipOptions(title = "Click to see inputs !")
                    ),
                    tabPanel("Table", DTOutput("out_totalSpendingOverTime_table")
                    )
                ),
                
                box(width = 12, 
                    title = "Comparative Spends, by Month, YoY",
                    id = "comparativeSpends_monthly_yoy",
                    
                    tabPanel("Test", plotOutput(outputId = "out_comparativeSpends_monthly_yoy"),
                             dropdown(
                               
                               tags$h3("Controls"),
                               
                               
                               virtualSelectInput(
                                 inputId = "in_comparativeSpends_monthly_yoy",
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
                             ))
                    
                    )
                
                
              )),
      # Tab Item: Time Series Analysis ----
      tabItem(tabName = "tsAnalysis",
              fluidRow(
      
                  
               DTOutput("budget_final")
               
                
              )
              
              
      ),
      
      # Tab Item: Spending Patterns Analysis ----
      tabItem(tabName = "spendingPatterns",
              fluidRow(
      
                box(width = 12,
                    title = "Number of transactions made by Month",
                    id = "number_of_transactions_monthly",
                    
                    dropdownButton(
                      
                      tags$h3("Select year:"),
                      
                      awesomeRadio(
                        inputId = "in_number_of_transactions",
                        label = "Radio buttons", 
                        choices = sort(unique(fin_data$yyyy)),
                        selected = rev(sort(unique(fin_data$yyyy)))[1]
                      )
                      
                      
                      
                      
                      ,
                      
                      circle = TRUE, status = "danger",
                      icon = icon("gear"),size = "xs",
                      
                      tooltip = tooltipOptions(title = "Click to see inputs !")
                    ),
                    tabPanel("Table", DTOutput("out_number_of_transactions")
                    )
                )    

                
              )
              
              
      ),
      
      
      
      # Tab Item: Budget Making ----
      tabItem(tabName = "budgetMaking",
              fluidRow(
                
                box(width = 12,
                    title = "Historical Averages", id = "historicalAverages",
                    tabPanel(title = "Data", DTOutput(outputId = "out_historical_averages"))
                    ),
                
                tabBox(width = 12,
                    title = "Make budget", id = "budget_section",
                    tabPanel(title = "Fill in values", 
                             dataEditUI("budget_edit")),
                    tabPanel("Finalised budget", id = "fin_budget",
                             DTOutput("out_view_budget_final"),
                             dataOutputUI("save_budget")))
          
                
                
                
                
                
              )
              
              
      ),
      # Tab Item: Full Data Table ----
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
