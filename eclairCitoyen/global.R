library(shinydashboard)
library(RSQLite)
library(dplyr)
library(DT)
library(ggplot2)
library(tidyr)
library(shinyWidgets)
library(DataEditR)
library(rhandsontable)


# 1.0 Load Data ----------------------------------------------------------------

# Connecting to data source
path <- '~/git-repos/aux-bourses-citoyens//integraFin/output/fin-database.sqlite'

con <- dbConnect(SQLite(), path)
fin_data <- dbGetQuery(con, 'SELECT * FROM financial_data')

fin_data <- fin_data %>% mutate(yyyymm = substr(Date, 1, 7),
                                yyyy = substr(Date, 1, 4),
                                Date = as.Date(Date, format = "%Y-%m-%d"))

factor_columns <- c("Transaction_Type", "Account_Type", "Account_Type2","model_outputs_validated", 
                    "yyyymm", "yyyy")

fin_data[, factor_columns] <- lapply(fin_data[, factor_columns], as.factor)

fin_data$Date <- as.Date(fin_data$Date)




# 2.0 Misc Manipulations -------------------------------------------------------


category_map <- 
  
  structure(list(model_output = c("Bank", "Beer", "Bills-Gas", 
"Bills-Hydro", "Bills-Internet", "Bills-Phone", "Bills-Water", 
"Coffee", "DiningOut", "Education", "Entertainment", "Gifts", 
"Groceries", "Health", "Income", "Insurance", "Investment-NonReg", 
"Investment-RRSP", "Investment-TFSA", "JointFunding", "Loan-Student", 
"Matty-The-Catty", "Misc.", "Move", "News", "Rent", "TaxReturn", 
"Tech", "tech-scaffold", "Transportation", "Travel"), category = structure(c(4L, 
1L, 5L, 5L, 5L, 5L, 5L, 1L, 1L, 5L, 1L, 1L, 5L, 5L, 6L, 5L, 2L, 
2L, 2L, 6L, 3L, 5L, 4L, 4L, 1L, 5L, 6L, 4L, 6L, 5L, 1L), levels = c("Discretionary", 
"Investment", "Loan", "Misc.", "Needs", "Non-Spend"), class = "factor")), row.names = c(NA, 
-31L), class = "data.frame")


core_fin_data_columns <- c("yyyy","yyyymm","Date", "Transaction_Type", "Account_Type", "Merchant", "Amount", 
                           "Note", "Signed_Split_Amount", "model_outputs_validated", "category")

ui_inputs <- split(category_map$model_output, category_map$category)

fin_data <- fin_data %>% left_join(category_map, by = c("model_outputs_validated"="model_output"))


theme_lab <- function () { 
  theme_grey(base_size = 14, base_family = "sans") %+replace% 
    theme(
      # plot margin
      plot.margin = unit(rep(0.5, 4), "cm"),
      # plot background and border
      plot.background = element_blank(),
      panel.background = element_blank(),
      panel.border = element_blank(),
      # grid lines
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_line(size = 0.5, color = "#cbcbcb"), 
      panel.grid.minor = element_blank(),
      # axis ticks and lines
      axis.ticks = element_blank(),
      axis.line = element_blank(),
      # title, subtitle and caption
      plot.title = element_text(size = 20, face = "bold", colour = "#757575", hjust = 0),
      plot.subtitle = element_text(size = 16, colour = "#757575", hjust = 0, margin = margin(9, 0, 9, 0)),
      plot.caption = element_text(size = 10, color = "grey50", hjust = 1, margin = margin(t = 15)),
      # axes titles
      axis.title = element_text(colour = "#757575", hjust = 1),
      axis.text.x = element_text(margin = margin(b = 7)),
      axis.text.y = element_text( margin = margin(l = 7)),
      # legend
      legend.position = "bottom",
      legend.background = element_blank(),
      legend.key = element_blank(),
      legend.title = element_text(size = 12, colour = "#757575"),
      legend.text.align = 0,
      legend.text = element_text(size = 14, colour = "#757575"),
      # facetting
      strip.background = element_rect(fill = "transparent", colour = NA),
      strip.text = element_text(size = 12, face = "bold", colour = "#757575", hjust = 0)
    )
}
