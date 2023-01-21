#This file is designed to be called in "01 Conversion.R"
#Please do not run it individually
#It writes tidied data frame into "Tidy Data/" folder
#Please run this file after "02 Read.R" for trial run

#Start to subsetting main file
#Clear blank columns and rows
file_read2 <- file_read %>%
  select(-1:-2) %>%
  slice(5:60)
file_read2
#Transpose dataset
df <- as_tibble(t(file_read2), .name_repair = 'unique')

#Remove empty columns
df <- df[,-9]
df <- df[,-47]
df <- df[,-50:-54]

#Remove empty rows
df2 <- df %>%
  remove_empty(which="rows")

#Add in batch, date and kiln info to df
df3 <- df2 %>%
  mutate(v_4, .before = 1) %>%
  slice(-1)

#Separate firing zone
df4 <- df3 %>%
  separate(4, c('kiln_car','firing_zone'), "/")
df4
#Tidying data
df4[6] <- df4 %>%
  pull(6) %>%
  str_sub(end = -4)
df4[8] <- str_remove(df4$"...4","\\*")

#Convert all NA to 0
df5 <- as_tibble(df4) %>%
  mutate_all(~replace(.,is.na(.), 0))

#Write into 'Tidy Data' folder
df5 %>%
  write_csv(file=file_tidy, col_names=FALSE, append = FALSE)
