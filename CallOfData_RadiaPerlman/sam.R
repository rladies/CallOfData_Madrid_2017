library(data.table)
df<-fread("Call_of_Data.txt", sep="|", header=TRUE)
qplot(data=df, x=IMPORTE, geom='histogram')+ scale_x_log10()

library(dplyr)
grupo <- df%>%group_by(NOMBRE_OFICINA, FECHA)%>%summarise(extraccion= sum(IMPORTE), count=n())
grupo1 <- df%>%group_by(NOMBRE_OFICINA, month)%>%summarise(extraccion= sum(IMPORTE))

num_cajeros <- length(unique(df$NOMBRE_OFICINA))

g1<-ggplot(data=df, aes(x=NOMBRE_OFICINA, y=IMPORTE))+ geom_boxplot()+theme(axis.text.x = element_text(angle = 45, hjust = 1))

##outliers en alcobnedas
outliers <-df%>%filter(NOMBRE_OFICINA=="ALCOBENDAS-LIBERTAD" & IMPORTE>1200)

#fecha: mes
df$month<-format(as.POSIXct(df$FECHA),"%Y-%m")
df$mes<-format(as.POSIXct(df$FECHA),"%m")

##plot por cajero y mes y gasto
ggplot(data=filter(df, NOMBRE_OFICINA=="MADRID-MANUEL BECERRA"), aes(x=month, y=IMPORTE))+geom_boxplot()
ggplot(data=filter(df, NOMBRE_OFICINA=="MADRID-PASEO DE EXTREMADURA"), aes(x=month, y=IMPORTE))+geom_boxplot()

#quitar mes enero 2015
#df<-df%>%filter(FECHA>'2015-01-31')

library(timeSeries)
library(timeDate)
timeseries <- ts(dplyr::filter(grupo, NOMBRE_OFICINA=="ALCALA DE HENARES-VIA COMPLUTENSE")$extraccion, start=c(2015, 1),end=c(2016, 12), frequency = 365)


#estadisticas por cajero
by(df$IMPORTE , df$NOMBRE_OFICINA, summary)
