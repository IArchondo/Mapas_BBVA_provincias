#ui.R

ccaa=c("-","Andalucía","Aragón","Asturias","Baleares","Canarias","Cantabria","Castilla y León",
       "Castilla La Mancha","Cataluña","Comunitat Valenciana","Extremadura","Galicia","Madrid",
       "Murcia","Navarra","País Vasco","La Rioja")
codccaa=c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)
names(codccaa)=ccaa


#01	Andalucía
#02	Aragón
#03	Asturias, Principado de
#04	Balears, Illes
#05	Canarias
#06	Cantabria
#07	Castilla y León
#08	Castilla - La Mancha
#09	Cataluña
#10	Comunitat Valenciana
#11	Extremadura
#12	Galicia
#13	Madrid, Comunidad de
#14	Murcia, Región de
#15	Navarra, Comunidad Foral de
#16	País Vasco
#17	Rioja, La
#18	Ceuta
#19	Melilla


shinyUI(fluidPage(
  titlePanel("Mapeador BBVA 3000"),
  sidebarLayout(
    sidebarPanel(
      helpText("Esta aplicación dibuja el mapa de España dependiendo de los datos introducidos"),
      selectInput("varsel",label=h3("Selecciona la variable"),choices=c("-"),selected="-"),
      h3("Región"),
      radioButtons("setter",h4("Elige la región"),choices=c("Toda España"=0,"CCAA"=1),selected=0),
      selectInput("selCCAA",h4("Elige CCAA"),choices=codccaa,selected="-")
    ),
    mainPanel(
      tabsetPanel(id="tabs1",
                  tabPanel("Mapa",
                           fluidRow(column(12,br())),
                           fluidRow(column(4,strong("Variable",style="color:#006EC1")),
                                    column(4,strong("Región",style="color:#006EC1"))),
                           fluidRow(column(4,h4(textOutput("textvar"),style="color:#009EE5")),
                                    column(4,h4(textOutput("textreg"),style="color:#009EE5")),
                                    column(4,actionButton("export","Exportar",width="200px",icon("print"),style="color: #fff; background-color: #337ab7; 
                                        border-color: #2e6da4"))),
                  plotOutput("plot",height="400px"),
                  fluidRow(column(12,br())),
                  fluidRow(column(6,h4("Colores",style="color:#006EC1")),
                           column(6,h4("Punto medio",style="color:#006EC1"))),
                  fluidRow(column(3,radioButtons("sel_col","",choices=c("BBVA"=0,"Personalizado"=1),selected=0)),
                           column(2,textInput("entmin","Min",value=""),textInput("entmax","Max",value="")),
                           column(1,br()),
                           column(6,sliderInput("slidermed",NULL,min=0,max=1,value=0.5),
                           checkboxInput("automed",label="Incluir",value=FALSE)))),
                  tabPanel("Agregar datos",
                           fluidRow(column(12,h3("Cargar más datos"))),
                           fluidRow(column(12,helpText("El csv tiene que contener una columna 
                                                       llamada CodProv con los códigos de provincia"))),
                           fluidRow(column(4,fileInput("ruta",h4("Cargar un .csv"))),
                                    column(6,br(),br(),
                                           actionButton("merge","Importar",icon("magic"),width="150px",
                                                        style="color: #fff; background-color: #337ab7; 
                                                        border-color: #2e6da4"))),
                           div(style = 'overflow-x: scroll', tableOutput("csvdata"))),
                  tabPanel("Tabla total",
                           div(style = 'overflow-x: scroll', tableOutput("datatot"))),
                  tabPanel("Variables/Cortar variables",
                           fluidRow(column(12,h3("Cortar variables"))),
                           fluidRow(column(12,helpText("Introducir el nombre de la nueva variable y los 
                                                       puntos de corte separados por comas (ej: 3,5,8)"))),
                           fluidRow(column(4,
                                           selectInput("varselcut",label="Selecciona la variable a cortar",
                                                       choices=c("-"),selected="-"))),
                           fluidRow(column(4,textInput("nomcor","Nombre de la nueva variable",value=""),
                                           textInput("pun_cortes","Puntos de corte",value="")),
                                    column(6,br(),br(),br(),br(),br(),
                                           actionButton("cortbutt","   Cortar",width='150px',icon("scissors"),
                                                        style="color: #fff; background-color: #337ab7; 
                                                        border-color: #2e6da4"))),
                           fluidRow(column(12,br())),
                           tableOutput("tabvar"))
                  
      )
    )
    
    
  )
))