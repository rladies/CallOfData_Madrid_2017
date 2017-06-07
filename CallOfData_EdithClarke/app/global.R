library(shiny)
library(shinydashboard)
library(shinyBS)
library(data.table)
library(ggplot2)

shiny::addResourcePath("img", "img/")

load("../data/maxiTabla.top20.perc.RData")
global_perc <- global

load("../data/maxiTabla.top20.RData")

var_names <- c("Importaciones" = "import", 
               "Exportaciones" = "export", 
               "Inmigración" = "inmig", 
               "Producto Interior Bruto" = "gdp")

colores_income <- c("Ingreso alto" = "#01DF01", 
                    "Ingreso mediano alto" = "#FFDF0C", 
                    "Paises de ingreso mediano bajo" = "orange",
                    "Paises de ingreso bajo" = "red")

global_perc[, Income_Group := factor(Income_Group, levels=names(colores_income))] 
global[, Income_Group := factor(Income_Group, levels=names(colores_income))] 

