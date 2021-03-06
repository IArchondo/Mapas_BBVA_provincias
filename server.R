#server.R

source("helper.R")

if (!require("pacman")) install.packages("pacman")
pacman::p_load("maptools","dplyr","data.table","reshape2","ggplot2","plyr","rgdal","rgeos",
               "shinyjs","scales","DT")

library(maptools)
library(dplyr)
library(data.table)
library(reshape2)
library(ggplot2)
library(plyr)
library(rgdal)
library(rgeos)
library(shinyjs)
library(scales)
library(DT)


dataini<-read.csv("Prov2.csv",sep=";")

#----------------------------------------------------------------------
#----------------------------------------------------------------------
##            OPERATIVO             ##


shinyServer(function(input, output,session) {
  
  #ponemos la data en el output  
  output$datatot=renderTable({
    dataini
  })
  
  #ponemos las estadisticas de las variables en el output
  output$tabvar=renderTable({
    data.frame(unclass(summary(dataini[3:ncol(dataini)])),check.names = F,stringsAsFactors = F)
  })
  
  #cargamos los datos
  datacsv=reactive({
    file1=input$ruta
    if (is.null(file1)){return()}
    read.csv(file=file1$datapath,sep=";")
  })
  
  #ponemos los datos en el output
  output$csvdata=renderTable({
    Sys.setlocale('LC_ALL','C') 
    if(is.null(datacsv())){return()}
    datacsv()
  })
  
  
  #actualizamos la lista de variables con los datos cargados
  observe({
    updateSelectInput(session,"varsel",choices=c("-",colnames(dataini)[3:length(colnames(dataini))]))
  })
  
  observe({
    updateSelectInput(session,"varselcut",choices=c("-",colnames(dataini)[3:length(colnames(dataini))]))
  })
  
  
  observe({
    if (input$setter==0){updateSelectInput(session,"selCCAA",selected="-")}
  })
  
  #Texto de error
  output$textvar=renderText({
    if (input$varsel=="-"){"Selecciona una variable"}
    else {input$varsel}
    
  })
  
  #label de region
  output$textreg=renderText({
    ccaa=c("-","Andalucía","Aragón","Asturias","Baleares","Canarias","Cantabria","Castilla y León",
           "Castilla La Mancha","Cataluña","Comunitat Valenciana","Extremadura","Galicia","Madrid",
           "Murcia","Navarra","País Vasco","La Rioja")
    num=input$selCCAA
    banner=ccaa[as.integer(num)+1]
    #iconv(banner, "UTF-8", "latin1")
    if (input$setter==0){"España"} else
      if (input$selCCAA==""&input$setter==1){"Selecciona una CCAA"}
    else {banner}
  })
  
  
  
  #----------------------------------------------------------------------
  ##            BOTONES             ##
  
  #BOTON combinamos los datos importados con los de la tabla principal
  observeEvent(input$merge,{
    if(is.null(input$ruta)){}
    else{
      datainiprev<<-merge(dataini,datacsv(),by="CodProv",all.x=TRUE)
      datainiprev=datainiprev[, -grep(".y", colnames(datainiprev))]
      nom=colnames(datainiprev)
      nom=gsub(".x","",nom)
      colnames(datainiprev)=nom
      
      dataini<<-datainiprev
      output$datatot=renderTable({
        dataini
      })
      updateSelectInput(session,"varsel",choices=c("-",colnames(dataini)[3:length(colnames(dataini))]))
      updateSelectInput(session,"varselcut",choices=c("-",colnames(dataini)[3:length(colnames(dataini))]))
      output$tabvar=renderTable({
        data.frame(unclass(summary(dataini[3:ncol(dataini)])),check.names = F,stringsAsFactors = F)
      })
      updateTabsetPanel(session, "tabs1 ",selected = "Tabla total")
    }
  })
  
  #BOTON cortar
  observeEvent(input$cortbutt,{
    if (input$varselcut=="-"){}
    else{
      datcor=cortador(dataini,input$pun_cortes,input$varselcut)
      datacut=dataini
      datacut[,input$nomcor]=datcor
      dataini<<-datacut
      
      output$datatot=renderTable({
        dataini
      })
      updateSelectInput(session,"varsel",choices=c("-",colnames(dataini)[3:length(colnames(dataini))]))
      updateSelectInput(session,"varselcut",choices=c("-",colnames(dataini)[3:length(colnames(dataini))]))
      output$tabvar=renderTable({
        data.frame(unclass(summary(dataini[3:ncol(dataini)])),check.names = F,stringsAsFactors = F)
      })
      updateTabsetPanel(session, "tabs1 ",selected = "Tabla total")
    }
  })
  
  
  # BOTON exportador
  observeEvent(input$export,{
   print(graf.fin)
  }
  )
  
  #---------------------------------------------------------------------
  ##            ESTETiCA             ##
  
  #temaBBVA
  temaBBVA=theme(legend.position='bottom',axis.title.x=element_blank(),
                 axis.title.y=element_blank(),axis.ticks=element_blank(),axis.text=element_blank(),
                 panel.grid.minor=element_blank(),panel.grid.major=element_blank())
  
  #---------------------------------------------------------------------
  #---------------------------------------------------------------------
  ##            DIBUJA EL GRAFICO             ##
  output$plot=renderPlot({
  
    mapa=graphing(dataini,input$setter,input$selCCAA,input$varsel,input$slidermed)
    
    dicc=grep(input$varsel,colnames(mapa[[2]]))
    
    if (is.null(mapa[[1]])){}
    else{
      if (input$sel_col==0){
        plot=modif(ggpl=mapa[[1]],mpdf=mapa[[2]],medcheck=input$automed,slidermed=input$slidermed,
                   acc=dicc)
        graf.fin<<-plot+
          temaBBVA
        graf.fin
      }
      else{
        plot=modif(ggpl=mapa[[1]],mpdf=mapa[[2]],medcheck=input$automed,slidermed=input$slidermed,
                   acc=dicc,colmin=input$entmin,colmax=input$entmax)
        graf.fin<<-plot+
          temaBBVA
        graf.fin
      }
    }
    
        
  })
  
  
})