library(shinydashboard)
library(RSQLite)
library(dplyr)
library(DT)
library(ggplot2)
library(tidyr)
library(shinyWidgets)
library(DataEditR)
library(rhandsontable)
library(rlang)


# 1.0 Load Data ----------------------------------------------------------------

## IF DEVELOPING UNCOMMENT
#setwd('./eclairCitoyen/')

# Connecting to data source
path <- '~/git-repos/aux-bourses-citoyens//integraFin/output/fin-database.sqlite'

con <- dbConnect(SQLite(), path)
fin_data <- dbGetQuery(con, 'SELECT * FROM financial_data')

# Read up core maps
source(file = 'helpers.R')

category_map <- yaml::read_yaml(file = 'category-map.yaml')
category_map <- list_to_df(category_map[[1]], keys_to_grab = "category", id_col = "model_output")

ec_map <- yaml::read_yaml(file = 'ecMap.yaml')
ec_map <- list_to_df(ec_map[[1]], keys_to_grab = c("db_col", "r_type", "sort_order","core_reporting_column"), id_col = "app_colnames")

# Now apply transforms from core maps to fin_data
factor_cols <- ec_map$db_col[ec_map$r_type == "factor"]
fin_data[, factor_cols] <- lapply(fin_data[, factor_cols, drop = FALSE], as.factor)

date_cols <- ec_map$db_col[ec_map$r_type == "date"]
fin_data[, date_cols] <- lapply(fin_data[, date_cols, drop = FALSE], as.Date)

# Remap fin_data names to something stable for EC:
## Resort
fin_data <-  fin_data[ec_map$db_col]
colnames(fin_data) <- ec_map$app_colnames


fin_data <- fin_data %>% split_dates_into_components(date_col = date) # TODO:This should belong in NC

# 2.0 Misc Manipulations -------------------------------------------------------

ui_inputs <- split(category_map$model_output, category_map$category)

category_inputs <- names(ui_inputs)

category_inputs <- category_inputs[category_inputs != "Non-Spend"]

core_fin_data_columns <- c("yyyy", "yyyymm", ec_map$app_colnames[ec_map$core_reporting_column == 1])

fin_data <- fin_data %>% left_join(category_map, by = c("model_output_validated"="model_output"))

# 3.0 Budget Framing -----------------------------------------------------------

budget_table <- 
  data.frame(model_outputs = category_map$model_output,
             year = 2024,
             budgeted_amount = NA_real_,
             frequency = NA_integer_,
             Notes = NA_character_)

# 4.0 "Theme-ing" --------------------------------------------------------------

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



