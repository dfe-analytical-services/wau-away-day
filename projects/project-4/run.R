# This file should be used to run all of the code required to populate the Outputs folder 

# Example below that renders example markdown in Outputs folder 

rm(list = ls())

rmarkdown::render('report.Rmd', output_file='report.html', output_dir='Outputs')
