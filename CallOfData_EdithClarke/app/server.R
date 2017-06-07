shiny::shinyServer( function(input, output, session) {
  
  
  # Scatterplot
  
  cojot_sub <- reactive({
    
    plotset <- global
    
    plotset[, variable := plotset[[input$scattp_var]]]
    
    if (input$normalizar) {
      plotset[, AODnorm := agregadoAOD / poblacion]
    } else {
      plotset[, AODnorm := agregadoAOD]
    }
    
    plotset
  })
  
  output$scatterplot <- renderPlot({
    ggplot(cojot_sub(), aes(x=AODnorm, y=variable, color=Income_Group)) + geom_point(size=3) +
      labs(x="Ayuda Oficial al Desarollo", 
           y=names(var_names)[var_names == input$scattp_var], 
           color=NULL) +
      scale_color_manual(values = colores_income)
  })
  
  # Scatterplot
  
  cojot_sub_perc <- reactive({
    
    plotset <- global_perc
    
    plotset[, variable := plotset[[input$scattp_var_perc]]]
    
    if (input$normalizar_perc) {
      plotset[, AODnorm := agregadoAOD / poblacion]
    } else {
      plotset[, AODnorm := agregadoAOD]
    }
    
    plotset
  })
  
  output$scatterplot_perc <- renderPlot({
    ggplot(cojot_sub_perc(), aes(x=AODnorm, y=variable, color=Income_Group)) + geom_point(size=3) +
      labs(x="Ayuda Oficial al Desarollo", 
           y=names(var_names)[var_names == input$scattp_var_perc], 
           color=NULL) +
      scale_color_manual(values = colores_income)
  })
  
  ## Cuadrante mágico de Oxfam
  output$cuadrante <- renderPlot({
    cuadrantplot <- global[, .(oda_global = mean(oda.per.capita), 
                               oda_sp = mean(agregadoAOD / poblacion)), 
                           by=Pais]
    ggplot(cuadrantplot, aes(x=oda_sp, y=oda_global, label=Pais)) + 
      geom_point(color="#5858FA", size=8) + geom_text(hjust=0, vjust=0.8) +
      geom_hline(yintercept=mean(cuadrantplot$oda_global)) +
      geom_vline(xintercept=mean(cuadrantplot$oda_sp)) +
      labs(x="AOD per cápita España", y="AOD per cápita Global")
  })
  
  # ggplot(global, aes(x=agregadoAOD / poblacion, y=oda.per.capita, label=Pais)) + 
  #   geom_point(color="#5858FA", size=3) + geom_text(hjust=0, vjust=0.8, size=3) +
  #   geom_hline(yintercept=mean(cuadrantplot$oda_global)) +
  #   geom_vline(xintercept=mean(cuadrantplot$oda_sp)) +
  #   facet_wrap(~Anyo_desembolso)+
  #   labs(x="AOD per cápita España", y="AOD per cápita Global")
  # 
  
})
