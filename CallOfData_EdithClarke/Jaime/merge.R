library(data.table)
gdp <- fread('./data/gdp_country.csv', header = T)
str(gdp)
gdp[,`2016`:=NULL]
gdp_melted <- melt(gdp,id.vars = c("Country Name","Country Code","Indicator Name","Indicator Code"),variable.name = "anyo")

ref.pais <- fread('./data/pais.ref.csv', header = T)
gdp_top_20 <- merge(gdp_melted,ref.pais,by.x = "Country Code", by.y = "codigo.wb")
save(gdp_top_20,file = './data/GDP_top20.RData')

import <- fread('./data/import.csv', header = T)
import[,perc:=(import/sum(import,na.rm = T)),by=year]
import_top_20 <- merge(import,ref.pais,by.x = "CODIGO PAIS", by.y="codigo.ine")
unique(import_top_20$PAIS)
import_top_20 <- import_top_20[PAIS!="Somalia"]

export <- fread('./data/export.csv', header = T)
export[,perc:=(export/sum(export,na.rm = T)),by=year]
export_top_20 <- merge(export,ref.pais,by.x = "CODIGO PAIS", by.y="codigo.ine")
unique(export_top_20$PAIS)
export_top_20 <- export_top_20[PAIS!="Somalia"]

load('./data/volcadoAgregadoBrutaPaisAnyo.RData')

inmigrantes <- fread('./data/inmigrantes_v2.csv', header = T)
inmigrantes[,perc:=(inmig/sum(inmig,na.rm = T)),by=year]

oad.per.capita <- fread('./data/Banco Mundial/oda_per_capita_4_13.RData')
load('./data/Banco Mundial/oda_per_capita_4_13.RData')
oda_per_capita_4_13 <- melt(oda_per_capita_4_13,id.vars = c("pais","cod_pais"),
                            variable.name = "anyo", value.name = "oda.per.capita")
oda_top_20 <- merge(oda_per_capita_4_13,ref.pais,by.x = "cod_pais", by.y = "codigo.wb")

unique(oda_top_20$pais)

global <- merge(fusionadosBrutoByPaisAnyo,export_top_20[,.(pais.volcados,year,export)],
                by.x =c("Pais","Anyo_desembolso"), 
                by.y = c("pais.volcados","year"))
# setnames(global,"import","export")

global <- merge(global,import_top_20[,.(pais.volcados,year,import)],
                by.x =c("Pais","Anyo_desembolso"), 
                by.y = c("pais.volcados","year"))

global <- merge(global,inmigrantes[,.(Pais,year,inmig)],
                by.x = c("Pais","Anyo_desembolso"),
                by.y = c("Pais","year"))
global <- merge(global, gdp_top_20[,.(pais.volcados,anyo,value)],
                by.x = c("Pais","Anyo_desembolso"),
                by.y = c("pais.volcados","anyo"))
setnames(global,"value","gdp")

global <- merge(global,oda_top_20[,.(pais.volcados,anyo,oda.per.capita)],
      by.x = c("Pais","Anyo_desembolso"),
      by.y = c("pais.volcados","anyo"))

poblacion <- fread('./data/poblacion_v2.csv', header = T)
poblacion_top_20 <- merge(poblacion, ref.pais,by.x = "Country Code", by.y = "codigo.wb")

global <- merge(global,poblacion_top_20[,.(pais.volcados,anyo,poblacion,Income_Group)],
      by.x = c("Pais","Anyo_desembolso"),
      by.y = c("pais.volcados","anyo"))

unique(global$Pais)
unique(poblacion_top_20$pais.volcados)
unique(oda_top_20$pais.volcados)
unique(gdp_top_20$pais.volcados)
unique(import_top_20$pais.volcados)
unique(export_top_20$pais.volcados)
unique(inmigrantes_top_20$pais.volcados)

save(global,file = './data/maxiTabla.top20.RData')

fusionadosBrutoByPaisAnyo[,perc.agre:=agregadoAOD/sum(agregadoAOD,na.rm = T),by=Anyo_desembolso]


global <- merge(fusionadosBrutoByPaisAnyo[,.(Pais,Anyo_desembolso,perc.agre)],
                export_top_20[,.(pais.volcados,year,perc)],
                by.x =c("Pais","Anyo_desembolso"), 
                by.y = c("pais.volcados","year"))
setnames(global,"perc","export")
setnames(global,"perc.agre","agregadoAOD")

global <- merge(global,import_top_20[,.(pais.volcados,year,perc)],
                by.x =c("Pais","Anyo_desembolso"), 
                by.y = c("pais.volcados","year"))
setnames(global,"perc","import")

global <- merge(global,inmigrantes[,.(Pais,year,perc)],
                by.x = c("Pais","Anyo_desembolso"),
                by.y = c("Pais","year"))
setnames(global,"perc","inmig")

global <- merge(global, gdp_top_20[,.(pais.volcados,anyo,value)],
                by.x = c("Pais","Anyo_desembolso"),
                by.y = c("pais.volcados","anyo"))
setnames(global,"value","gdp")

global <- merge(global,oda_top_20[,.(pais.volcados,anyo,oda.per.capita)],
                by.x = c("Pais","Anyo_desembolso"),
                by.y = c("pais.volcados","anyo"))

poblacion <- fread('./data/poblacion_v2.csv', header = T)
poblacion_top_20 <- merge(poblacion, ref.pais,by.x = "Country Code", by.y = "codigo.wb")

global <- merge(global,poblacion_top_20[,.(pais.volcados,anyo,poblacion,Income_Group)],
                by.x = c("Pais","Anyo_desembolso"),
                by.y = c("pais.volcados","anyo"))
global

save(global,file = "./data/maxiTabla.top20.perc.RData")
