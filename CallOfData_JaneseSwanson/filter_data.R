cajamar <- read.csv('./Call_of_Data.txt', header = TRUE, sep = '|')

library(dplyr)

madrid_cps <- c(28001:28055, 28070, 28071, 28080)

cajamar_madrid <- cajamar %>% filter(CP_OFICINA %in% madrid_cps)