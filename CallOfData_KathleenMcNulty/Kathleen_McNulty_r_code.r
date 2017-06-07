
library(sqldf)# install.packages("ggplot2")
# install.packages("ggplot")
# library(ggplot2)
# library(ggplot)
#tipo de tarjetas por oficina
ofcpRATIOtarjeta<-sqldf("select OFICINA,SUM(IMPORTE) from tmp group by OFICINA")
plot(ofcpRATIOtarjeta$CP_OFICINA,ofcpRATIOtarjeta$`SUM (IMPORTE)`)

ofRATIOtarjeta<-sqldf("select OFICINA, SUM(IMPORTE) from tmp group by OFICINA")
plot(ofRATIOtarjeta$OFICINA,ofRATIOtarjeta$`SUM (IMPORTE)`)


#Tarjetas propias vs ajenas
ofTipoTarjeta<-sqldf("select OFICINA,TIPO_TARJETA, COUNT (TIPO_TARJETA) from tmp group by OFICINA,TIPO_TARJETA")

aa<-sqldf("SELECT OFICINA, COUNT(TIPO_TARJETA) from tmp where TIPO_TARJETA='A'  GROUP BY OFICINA")
pp<-sqldf("SELECT OFICINA, COUNT(TIPO_TARJETA) from tmp where TIPO_TARJETA='P' GROUP BY OFICINA")

hola<-aa$'COUNT(TIPO_TARJETA)'/pp$'COUNT(TIPO_TARJETA)'
ofic<-pp$OFICINA
tipTarjeta<-data.frame(ofic,hola)
plot(ofic,hola)

graphics.off()

#----------------
ggplot(tipTarjeta, aes(x=ofic, y=hola))
######################
aa_cp<-sqldf("SELECT CP_OFICINA, COUNT(TIPO_TARJETA) from tmp where TIPO_TARJETA='A'  GROUP BY CP_OFICINA")
pp_cp<-sqldf("SELECT CP_OFICINA, COUNT(TIPO_TARJETA) from tmp where TIPO_TARJETA='P' GROUP BY CP_OFICINA")

hola_cp<-aa_cp$'COUNT(TIPO_TARJETA)'/pp_cp$'COUNT(TIPO_TARJETA)'
tipTarjeta_cp<-data.frame(pp_cp$CP_OFICINA,hola_cp)
plot(pp_cp$CP_OFICINA,hola_cp)
######################




a<-sqldf("select OFICINA,TIPO_TARJETA, COUNT (TIPO_TARJETA) from tmp where TIPO_TARJETA='A' group by OFICINA,TIPO_TARJETA" )
RatioAP<-sqldf("select OFICINA,TIPO_TARJETA, COUNT (TIPO_TARJETA) from tmp where TIPO_TARJETA='A' group by OFICINA ")