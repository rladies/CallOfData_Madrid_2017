dataset <- NULL

files <- list.files("call-of-data_2017/data/", pattern="Volcado ", full.names=T)
# col_names <- list()
for (filename in sort(files, decreasing=TRUE)) {
  data <- fread(filename, header=T, colClasses="character", na.strings=c("", "x"))
  
  na_rows <- apply(data, 1, function(x) all(is.na(x)))
  data <- data[!na_rows, .SD, .SDcols=names(data)[!grepl("^V[0-9]+$", names(data))]]
  
  write.csv(data, filename, row.names=FALSE, quote=TRUE)
  # col_names[filename] <- names(data)
  # 
  # print(filename)
  # print(dim(data))
  # print(names(data))
  # dataset <- rbind(dataset, data)
}

# setnames(data, c("cod_proy", "cod_entidad", "entidad", "titulo", "proy", "cod_sector", "sector", 
#                  "pais", "nivel_renta", "imp_gasto", "modo_ayuda", "via_ong", "tipo_coop", "asistencia",
#                  "igualdad", "medio_ambiente", "desarrollo", "desc_indigenas", "desc_narcotrafico"))

data <- fread(files[10])






filename <- "call-of-data_2017/data/Volcados_fusionados_para_Web_2004_2013_Bilateral.csv"
volcado <- fread(filename)

volcado[, Pais := Pais_raw]
volcado[, Pais := tolower(Pais)]
volcado[, Pais := gsub("á", "a", Pais)]
volcado[, Pais := gsub("é", "e", Pais)]
volcado[, Pais := gsub("í", "i", Pais)]
volcado[, Pais := gsub("ó", "o", Pais)]
volcado[, Pais := gsub("ú", "u", Pais)]

ranking <- volcado[, .(AOD = sum(AOD_Bruta)), by=Pais][order(AOD, decreasing=TRUE)]
volcado[, top50 := Pais %in% head(ranking, 50)$Pais]

write.csv(volcado, filename, row.names=FALSE, quote=TRUE)

###

import <- fread("data/original/Espania_import_by_country.csv", header=T, na.strings=c("", ".."))
import <- import[, .SD, .SDcols=names(import)[!grepl("^V[0-9]+$", names(import))]]

import <- melt(import, id.vars=c("CONTINENTE", "CODIGO PAIS", "PAIS"), variable.name="year", value.name="import") 
import[, import := as.numeric(gsub(",", "", import))]
import <- import[CONTINENTE != "OTROS"]

write.csv(import, "data/import.csv", row.names=FALSE, quote=TRUE)

###

export <- fread("data/original/Espania_export_by_country.csv", header=T, na.strings=c("", ".."))

export <- melt(export, id.vars=c("CONTINENTE", "CODIGO PAIS", "PAIS"), variable.name="year", value.name="export") 
export[, export := as.numeric(gsub(",", "", export))]
export <- export[CONTINENTE != "OTROS"]

write.csv(export, "data/export.csv", row.names=FALSE, quote=TRUE)

###

inmigrantes <- fread("data/original/Espania_inmigrantes_por_pais.csv", header=T, na.strings=c("", ".."))
setnames(inmigrantes, "País Origen", "Pais_raw")
inmigrantes <- melt(inmigrantes, id.vars=c("Pais_raw"), variable.name="year", value.name="inmig") 
inmigrantes[, Pais := tolower(Pais_raw)]
inmigrantes[, Pais := gsub("á", "a", Pais)]
inmigrantes[, Pais := gsub("é", "e", Pais)]
inmigrantes[, Pais := gsub("í", "i", Pais)]
inmigrantes[, Pais := gsub("ó", "o", Pais)]
inmigrantes[, Pais := gsub("ú", "u", Pais)]

write.csv(inmigrantes, "data/inmigrantes.csv", row.names=FALSE, quote=T)
