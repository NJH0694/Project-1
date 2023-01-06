# Defect Analysis with Machine Learning

This project is to conduct comprehensive data analysis on product defects.
Reports generated from company software are converted into tidy data and further conduct descriptive data analysis.

This project consists total 8 files:

#01 Conversion.R

Call file 02 and 03 to convert raw data to csv files.

#02 Read.R

Read xml raw files from '/Raw Data/' and stores important data

#03 Tidy.R

Subsetting dataframe and write into '/Tidy Data/' folder

#04 Combine.R

Read all csv files from '/Tidy Data' and combine into a single database file.

#05 Preparation.R

Read database file again and transform data based on defect type

#06 Visualize.R

Plot graphs using ggplot to visualize relationship between defects and variables

#07 DescriptiveAnalysis.R

Identify correlationship between variables by using descriptive analysis such as t.test and ANOVA

#08 RegressionModeling.R

Create regression models
