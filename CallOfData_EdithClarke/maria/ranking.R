
ranking_new <- volcado[, .(AOD = sum(AOD_Bruta)), by=.(Pais, Anyo_desembolso)][order(AOD, decreasing=TRUE)]

TOPN <- 10
ranking_new[, top := 1:.N <= TOPN, by=Anyo_desembolso]
length(unique(ranking_new[top==TRUE]$Pais))

rankingtotal <- ranking_new[, .(AOD = sum(AOD, na.rm=T)), by=Pais][order(AOD)]
ranking_new[, Pais := factor(Pais, levels=rankingtotal$Pais)]

ggplot(ranking_new[top == TRUE], aes(x=Pais, y=AOD)) + 
  geom_bar(stat="identity") + coord_flip() + facet_wrap(~Anyo_desembolso, nrow=1)

ranking_median <- ranking_new[, .(AODmedian = median(AOD, na.rm=T)), by=Pais][
  order(AODmedian, decreasing = T)]
ranking_new[, Pais := factor(Pais, levels=rev(ranking_median$Pais))]
ggplot(ranking_new[Pais %in% head(ranking_median, 25)$Pais], aes(x=Pais, y=AOD)) + 
  geom_bar(stat="identity") + coord_flip() + facet_wrap(~Anyo_desembolso, nrow=1)

ranking <- ranking_median
save(ranking, file="data/ranking.RData")



