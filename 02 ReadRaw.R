#Read raw data file name and create tidied file name
file_raw <- paste0('Raw Data/',raw_list[i])
file_tidy <- paste0('Tidy Data/', str_replace(raw_list[i],'xls','csv'))

#Read xls and convert to tibble (might takes few second)
file_read <- as_tibble(read_xls(path=file_raw, range="A3:AZ70"))
file_read
#Store kiln variable before subsetting
v_1 <- file_read[3,13] %>%
  str_sub(7)

#Store batch number and date
v_2 <- file_read[3,1] %>%
  str_sub(20) %>%
  str_split(pattern = "/", n=2)

#Combine variables and prepare for data wrangling
v_3 <- c(unlist(v_2),v_1)
v_4 <- as_tibble_row(v_3,.name_repair="minimal")

title <- c('batch','date','kiln')
colnames(v_4) <- title

v_4
