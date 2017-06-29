library(maptools)
library(dplyr)
library(data.table)
library(reshape2)
library(ggplot2)
library(plyr)
library(rgdal)
library(rgeos)


#setwd("/Users/IArchondo/Desktop/R/Proyectos personales/Shiny/MapsBBVA2")
#cargcomb=function(datax,setter,zah,varnom){
graphing=function(datax,setter,selCCAA,varsel,slidermed){
#cargcomb=function(datax){
  map=readShapeSpatial('prov_map.shp')
  map@data$CodProv=as.integer(map@data$CodProv)
  map@data=merge(map@data,datax,by.x='CodProv',by.y='CodProv',sort=F) #combina el mapa con los datos
  map@data$id=rownames(map@data)
  map.points=fortify(map,region='id')
  map.df=join(map.points,map@data,by='id')
  map.df$Cd_CCAAint=as.integer(map.df$Cd_CCAA)
  #return(map.df)
#}
  
  
  #graphing=function(map.df,setter,selCCAA,varsel,slidermed){ 
    if(varsel=="-"){return (NULL)}
    else {
      dicc=grep(varsel,colnames(map.df))
      if (setter==0){
        mapa=ggplot(map.df)+
          aes_string("long","lat",group="group",fill=varsel)+ #reemplazar Pob por el nombre de la variable de data con la que se quiera colorear
          geom_polygon()+
          geom_path(color='white')+
          coord_equal()
        # +
        #   scale_fill_gradient2(low='#89D1F3',high='#006EC1'
        #                        ,midpoint = slidermed*max(map.df[dicc])
        #   )+
        #   theme(legend.position='bottom',axis.title.x=element_blank(),axis.title.y=element_blank(),axis.ticks=element_blank(),axis.text=element_blank(),panel.grid.minor=element_blank(),panel.grid.major=element_blank())
        return(list(mapa,map.df))
      }
      else {
        map.dfx<<-subset(map.df,map.df$Cd_CCAAint==selCCAA)
        mapa=ggplot(map.dfx)+
          aes_string("long","lat",group="group",fill=varsel)+ #reemplazar Pob por el nombre de la variable de data con la que se quiera colorear
          geom_polygon()+
          geom_path(color='white')+
          coord_equal()
        # +
        #   scale_fill_gradient2(low='#89D1F3',high='#006EC1'
        #                        ,midpoint = slidermed*max(map.dfx[dicc])
        #   )+
        #   theme(legend.position='bottom',axis.title.x=element_blank(),axis.title.y=element_blank(),axis.ticks=element_blank(),axis.text=element_blank(),panel.grid.minor=element_blank(),panel.grid.major=element_blank())
        return(list(mapa,map.dfx))
      }
    }
    
}

