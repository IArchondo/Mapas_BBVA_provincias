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
  map=readShapeSpatial('prov_map.shp')
  map@data$CodProv=as.integer(map@data$CodProv)
  map@data=merge(map@data,datax,by.x='CodProv',by.y='CodProv',sort=F) #combina el mapa con los datos
  map@data$id=rownames(map@data)
  map.points=fortify(map,region='id')
  map.df=join(map.points,map@data,by='id')
  map.df$Cd_CCAAint=as.integer(map.df$Cd_CCAA)
  
    if(varsel=="-"){return (NULL)}
    else {
      dicc=grep(varsel,colnames(map.df))
      if (setter==0){
        mapa=ggplot(map.df)+
          aes_string("long","lat",group="group",fill=varsel)+
          geom_polygon()+
          geom_path(color='white')+
          coord_equal()
        return(list(mapa,map.df))
      }
      else {
        map.dfx<-subset(map.df,map.df$Cd_CCAAint==selCCAA)
        mapa=ggplot(map.dfx)+
          aes_string("long","lat",group="group",fill=varsel)+
          geom_polygon()+
          geom_path(color='white')+
          coord_equal()
        return(list(mapa,map.dfx))
      }
    }
}

#modificador

modif=function(ggpl,mpdf,colmin='#89D1F3',colmax='#006EC1',medcheck,slidermed,acc){
  if (medcheck==FALSE){
    plot=ggpl+
      scale_fill_gradient2(low=colmin,high=colmax)
    return(plot)
  }
  else{
    plot=ggpl+
      scale_fill_gradient2(low=colmin,high=colmax,midpoint=slidermed*max(mpdf[acc]))
    return(plot)
  }
  
}


