
library(lubridate)
library(stringr)
library(ggmap)
library(plyr)

dd <- read.table("CajaMar/Call_of_Data.txt", header=TRUE
                 , sep="|", stringsAsFactors=FALSE)
cpostal.raw <- read.csv("CajaMar/ES.txt", sep="\t", header=FALSE)
cpostal <- t(sapply(split(cpostal.raw[,c(2, 10, 11)], cpostal.raw$V2)
                    , function(x) c(x$V2[1], colMeans(x[,-1]))))
cpostal <- data.frame(cpostal)
names(cpostal) <- c("CP_CLIENTE", "LAT_CLIENTE", "LON_CLIENTE")
dd.enh <- merge(dd, cpostal, all.x=TRUE)

# clientes y anonimos
anons <- names(table(dd$CLIENTE[which(dd$TIPO_TARJETA=="A")]))
clients <- names(table(dd$CLIENTE[which(dd$TIPO_TARJETA=="P")]))

year <- "2016"
anons <- names(table(dd$CLIENTE[which(dd$TIPO_TARJETA=="A" & str_detect(dd$FECHA, year))]))
clients <- names(table(dd$CLIENTE[which(dd$TIPO_TARJETA=="P" & str_detect(dd$FECHA, year))]))

barplot(c(clientes=length(clients)
          , anons=length(anons))
        , main=year)

# importe por horas
plot(aggregate(dd$IMPORTE, list(dd$HORA), sum)$x, type="s")

# importe por cliente
hist(aggregate(dd$IMPORTE, list(dd$CLIENTE), sum)$x)

# serie temporal
ll <- sapply(split(dd$IMPORTE, dd$FECHA), sum)
plot(ll, type="l")

ll.importe.dow <- cbind(ll, weekdays(ymd(names(ll))))
aggregate(as.numeric(ll.importe.dow[,1]), list(ll.importe.dow[,2]), sum)

# cliente digital
clients.filter <- which(dd$TIPO_TARJETA=="P") #  & str_detect(dd$FECHA, "2015")
anons.filter <- which(dd$TIPO_TARJETA=="A")

filter <- clients.filter
ll <- split(dd$TIPO_OPERACION[filter]
            , dd$CLIENTE[filter])
ll.dig <- lapply(ll, function(x) table(factor(x, levels=c("C", "N"))))
hist(sapply(ll.dig, function(x.tbl) 1 - x.tbl["N"]/sum(x.tbl)))

# maps
mm <- merge(dd[,c("CP_CLIENTE", "FECHA")], cpostal)

# agregado de usos por cajero
ll.dd <- ddply(dd, .(LONGITUD, LATITUD), nrow)
# agregado de usuarios por CP
ll.mm <- ddply(mm, .(LONGITUD, LATITUD), nrow)
# agregado de importe por cajero
ll.ii <- aggregate(dd$IMPORTE, list(dd$LONGITUD, dd$LATITUD), sum)
names(ll.ii) <- c("LONGITUD", "LATITUD", "V1")
# agregado cajeros y clientes
ll <- rbind(data.frame(ll.dd, tipo="cajero")
            , data.frame(ll.mm, tipo="cliente"))

map <- get_map(location = 'Madrid', zoom = 10)
#map <- get_map(location = 'Spain', zoom = 6)
mapPoints <- ggmap(map) +
  geom_point(aes(x = LONGITUD, y = LATITUD, size = sqrt(V1), color=tipo)
             , data = ll, alpha = .4) +
  scale_color_manual(values=c("darkgreen", "blue"))

mapPoints <- ggmap(map) +
  geom_point(aes(x = LONGITUD, y = LATITUD, size = log(V1))
             , data = ll.ii, alpha = .4)

# renta per capita
rentapc.codpostal <- read.csv("cifrascap17codpostal.csv"
                              , stringsAsFactors = FALSE)
ll.pre <- merge(unique(dd.enh[,c("CLIENTE", "CP_CLIENTE", "LAT_CLIENTE", "LON_CLIENTE")])
            , aggregate(dd.enh$IMPORTE, list(dd.enh$CLIENTE), sum)
            , by=1)
ll <- merge(ll.pre, rentapc.codpostal[,c("cod_postal", "Renta")]
            , by.x=2, by.y= 1, all.x=TRUE)
names(ll) <- c("CP_CLIENTE", "CLIENTE", "LATITUD", "LONGITUD", "IMPORTE", "RENTAPC")
ll$RENTAPC <- as.numeric(ll$RENTAPC)

