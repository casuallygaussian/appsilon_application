library(data.table)
library(tidyverse)


#by data inspection it was found out that sometimes measurements done in a rapid succession (2/3 seconds) 
#usually are erratic and produce unreasonable traveled distances
#therefore these observations are attributed to measurement error and excluded


clean_df <- function(df, shipname_replacement_vec  =  c(". PRINCE OF WAVES" =  "PRINCE OF WAVES")) {
  
  df <- df %>% rename_all(tolower)
  df$shipname <- str_replace_all(df$shipname, shipname_replacement_vec)
  return(df)
  
}


filter_ship_names <- function(df, sel_ship_type) {
  
  filtered_ship_names <- df %>% 
    filter(ship_type == sel_ship_type) %>% 
    pull(shipname) %>% 
    unique() %>%
    sort()
  names(filtered_ship_names) <- filtered_ship_names
  
  return(filtered_ship_names)
  
}


filter_longuest_distance <- function(df) {
  
  df %>%
    arrange(datetime) %>%
    mutate(lon_l1 = lag(lon), lat_l1 = lag(lat), datetime_l1 = lag(datetime)) %>%
    filter(row_number() > 1) %>% #this obs has no lags
    rowwise() %>%
    mutate(distance =  distm(c(lon, lat), c(lon_l1, lat_l1)),
           time = as.numeric(datetime - datetime_l1,  units="secs"),
           speed = 60 * 60 * (distance / time) / 1000 
           ) %>%
    ungroup() %>%
    filter(time > as.numeric(5)) %>%
    filter(distance == max(distance, na.rm = TRUE)) %>%
    tail(1)  #selecting the most recent if there are several
  
}




