shinydashboard::dashboardPage(
  
  shinydashboard::dashboardHeader(
    title = "Grupo Edith Clarke"
  ),
  
  shinydashboard::dashboardSidebar(
    # Menu
    shinydashboard::sidebarMenu(
      menuItem("Global",
               tabName = "global",
               selected = TRUE,
               icon= icon("globe")),
      menuItem("Global perc",
               tabName = "globalperc",
               icon= icon("globe")),
      menuItem("Cuadrante",
               tabName = "cuadrante",
               icon= icon("plus-square-o"))
    ),
    
    # Sep
    br(),
    tags$hr(style = "border-color: #605ca8"),
    br(),
    
    # Logos
    title= tags$a(
      href = "http://callofdata.info",
      tags$img(
        src="img/callofdata.jpg",
        height = "110px",
        style = "margin-left: 5px"
      )
    ),
    br(),
    br(),
    title= tags$a(
      href = "http://www.realidadayuda.org/",
      tags$img(
        src="img/intermon.jpg",
        height = "110px",
        style = "margin-left: 55px"
      )
    )
  ),
  
  shinydashboard::dashboardBody(
    shinydashboard::tabItems (
      
      #Global
      shinydashboard::tabItem(
        tabName="global",
        fluidPage(
          fluidRow(
            fluidRow(
              tags$h4("Ayuda Oficial al Desarrollo VS. Métricas del país"),
              shiny::column(
                shiny::plotOutput("scatterplot", height="600"),
                width=9
              ),
              shiny::column(
                fluidRow(
                  checkboxInput("normalizar", "Normalizar por población", FALSE),
                  tags$hr(style = "border-color: #605ca8"),
                  radioButtons("scattp_var", "", 
                               choices=var_names)
                ), width=3
              )
            )
          )
        )
      ),
      
      #Global perc
      shinydashboard::tabItem(
        tabName="globalperc",
        fluidPage(
          fluidRow(
            fluidRow(
              tags$h4("Ayuda Oficial al Desarrollo VS. Métricas del país (porcentual)"),
              shiny::column(
                shiny::plotOutput("scatterplot_perc", height="600"),
                width=9
              ),
              shiny::column(
                fluidRow(
                  checkboxInput("normalizar_perc", "Normalizar por población", FALSE),
                  tags$hr(style = "border-color: #605ca8"),
                  radioButtons("scattp_var_perc", "", 
                               choices=var_names)
                ), width=3
              )
            )
          )
        )
      ),
      
      # Cuadrante
      shinydashboard::tabItem(
        tabName="cuadrante",
        fluidPage(
          fluidRow(
            tags$h4("Cuadrante comparativo"),
            shiny::plotOutput("cuadrante", height="600")
          )
        )
      ),
      
      
      # Por País
      shinydashboard::tabItem(
        tabName="pais",
        fluidPage(
          fluidRow(
            # shiny::column(dateRangeInput("daterange", label="Periodo",
            #                              start="2016-05-01", min="2016-05-01",
            #                              end="2016-05-31", max="2016-05-31",
            #                              weekstart=1, language="sp"), 
            #               width=4, offset=0.5),
            shiny::column(selectInput("pais_selec", label="País",
                                      choices=c("Marruecos", "Pera"), multiple=FALSE),
                          width=4, offset=0.5)
          ),
          # fluidRow( shiny::plotOutput("evol", height=250) ),
          # br(),
          # fluidRow( shiny::plotOutput("evolvals2", height=250) ),
          width=6
        )
      )
    )
  ),
  title = "CALL OF DATA" ,
  skin = "purple"
)
