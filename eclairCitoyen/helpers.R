# 1.0 Functions ----------------------------------------------------------------

list_to_df <- function(x, keys_to_grab, id_col) {
  # Validate inputs
  stopifnot(is.list(x), is.character(keys_to_grab))
  
  # Initialize data frame with ID column
  df <- data.frame(
    tmpkey = names(x),
    row.names = NULL,
    stringsAsFactors = FALSE
  )
  
  # Loop over keys to grab, add each as a column
  for (key in keys_to_grab) {
    df[[key]] <- sapply(x, function(i) i[[key]])
  }
  
  # Rename ID column
  colnames(df)[1] <- id_col
  
  df
}

split_dates_into_components <- function(df, date_col){
  
  df %>% 
    mutate(
    yyyymm = substr({{date_col}}, 1, 7),
    yyyy = substr({{date_col}}, 1, 4)
  )
  
}
