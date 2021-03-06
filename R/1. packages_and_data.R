#---------------------------------------------------------------------
#Load libraries

library(leaflet)
library(geojsonio)
library(rgdal)
library(sp)
library(data.table)
library(RColorBrewer)
library(raster)
library(pander)
library(tidyverse)
library(shinycssloaders)
library(plotly)
library(shiny)
library(DT)
library(ggalt)
library(magrittr)
library(scales)
library(sparkline)
library(extrafont)

#---------------------------------------------------------------------
#Load the data required

# main_ud file
main_ud <- read_csv('data/main0617excl_ud_r_df.csv', col_types = cols(.default = "c"))

# reason_ud file
reason_ud <- read_csv("data/reasons.csv", col_types = cols(.default = "c"))

# characteristics UD
char_ud <- read_csv('data/nat_char (201112 to 201617).csv', col_types = cols(.default = "c"))

# school names data from get schools information full data

school_names_raw <- read_csv('data/get_schools_information.csv', col_types = cols(.default = "c"))

#---------------------------------------------------------------------
#General functions - 

# Change the year variable into xxxx/xx format

formatyr <- function(refyear) {
  
  sub("(.{4})(.*)", "\\1/\\2", refyear)
  
}

# example
# formatyr(201213)
# = 2012/13

has_warning <- function (expr) 
{
  warn = FALSE
  op = options(warn = -1)
  on.exit(options(op))
  withCallingHandlers(expr, warning = function(w) {
    warn <<- TRUE
    invokeRestart("muffleWarning")
  })
  warn
}


change_ed <- function(numA, numB) {
  
  if(numA == 'x' | numB == 'x') {return ('been suppressed')}
  
  if(numA < numB) {return ('increased')}
  
  if(numA > numB) {return ('decreased')}
  
  else {return('stayed the same')}
  
}



numeric_ifelse <- function(x) {
  
  if(has_warning(as.numeric(x))) {
    return(" one or two pupils per 10,000 pupils, however this is not exact due to supression of small numbers.")
  } 
  
  if(!has_warning(as.numeric(x))) {
    return(paste(as.numeric(x)*100, " pupils per 10,000 pupils."))
  } 
  
  else(
    return(""))
  
}


change_ed_x <- function(numA, numB) {
  
  if(has_warning(as.numeric(numA)) | has_warning(as.numeric(numB))) {return('has been supressed')}
  
  if(is.na(numA) | is.na(numB)) {return ('is not available')}
  
  if(as.numeric(numA) < as.numeric(numB)) {return ('increased')}
  
  if(as.numeric(numA) > as.numeric(numB)) {return ('decreased')}
  
  else {return('stayed the same')}
  
}



numeric_supress <- function(x) {
  
  if(has_warning(as.numeric(x))) {
    return(paste("has been supressed"))
  } 
  
  if(!has_warning(as.numeric(x))) {
    return(paste(as.numeric(x)))
  } 
  
  else(
    return(""))
  
}


numeric_round_warning <- function(x) {
  
  if(has_warning(as.numeric(x))) {
    return(x)
  } 
  
  if(!has_warning(as.numeric(x))) {
    return(format(round(as.numeric(x),2), nsmall=2))
  } 
  
  else(
    return(""))
  
}


