#################################################################################################
#
#
#  Script para crear los archivos de las estaciones y crear el batch
#  para ejecutar en consola
#
# Elaborado por: Walter Bardales (bardaleswa@gmail.com)
# Facultad de Ingenieria, Universidad de San Carlos de Guatemala
#
###################################################################################################


# Establecer directorio de trabajo
setwd("D:/Documents/pronostico_climatico/spi")

# leer la tabla de datos de lluvia
tabla<-read.table("D:/Documents/pronostico_climatico/pp_guatemala.txt", header=T, sep="\t", na.string="-99.9")

# Extraer los nombres de las tablas
nombrescol<-colnames(tabla)

# Generar la serie de años
year<-as.numeric(format(seq(as.Date("1981-01-01"), as.Date("2018-06-01"), by="month"),"%Y"))

# Generar la serie de meses
mes<-as.numeric(format(seq(as.Date("1981-01-01"), as.Date("2018-06-01"), by="month"),"%m"))


# Directorio donde se encuentra el programa spi
directorio_spi<-"D:/Documents/pronostico_climatico/spi/"

# Niveles de spi que desea calcular
fases<-c(1,3,6,9,12,24)

# Algoritmo para ejecutar en modo batch
algoritmo<-(if(length(fases)==1){paste0("echo ", fases[1])} else if(length(fases)==2){paste0("echo ", fases[1], " && echo ", fases[2])} else
  if(length(fases)==3){paste0("echo ", fases[1], " && echo ", fases[2], " && echo ", fases[3])} else if(length(fases)==4){paste0(" && echo ", fases[1], " && echo ", fases[2], " && echo ", fases[3], " && echo ", fases[4])} else
  if(length(fases)==5) {paste0(" && echo ", fases[1], " && echo ", fases[2], " && echo ", fases[3], " && echo ", fases[4], " && echo ", fases[5])} 
  else {paste0(" && echo ", fases[1], " && echo ", fases[2], " && echo ", fases[3], " && echo ", fases[4], " && echo ", fases[5], " && echo ", fases[6])})


# Generar el archivo cor y el bat para ejecutar spi
for (i in 2:ncol(tabla)){
  tabla2<-data.frame(year,mes,round(tabla[,i],0))
  
  # Colocar nombre a la columnas
  colnames(tabla2)<-c("Year", "Mes", nombrescol[i])
  
  # Nombre del archivo de la estacion con datos para spi
  nombre<-paste0("esta_",nombrescol[i],".cor")
  
  # Escribir la tabla con los parametros solicitados por el spi
  write.table(tabla2, nombre, na="-99", col.names = F, row.names = F)

  # Generacion del nombre de salida del archivo del spi
  outputnombre<-paste0("esta_",nombrescol[i],".dat")

  # Crear el archivo el batch del archivo spi para que se ejecute en consola c++  
  file_spi<-paste0(nombrescol[i], ".bat")
  sink(file_spi)
       cat(paste0("cd ",directorio_spi," && (echo ", length(fases), algoritmo, " && echo ", nombre ," && echo ", outputnombre,") | spi_sl_6"))
  sink()  
}


# Listar todos los archivos .bat
files_ejecutar<-list.files(pattern = ".bat")

# Crear el archivo para ejecutar todas las estaciones de spi
sink("1_ejecutar_todas.bat")
cat(paste0("call ", files_ejecutar), sep="\n")
sink()

