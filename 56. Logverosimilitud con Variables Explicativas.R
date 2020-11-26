#55. Tensi�n vs. Ciclos
#Pruebas de vida acelerada
#Ejemplo: Telar (Picciotto 1970)
#VD: Resistencia del hilo en ciclos
#VI: Tensi�n en cent�metros
#"Picciotto1970"
#Condiciones normales de operaci�n: 20 cm
rm(list=ls())
Datos=read.table(file.choose(),header=T)
head(Datos)
Tensi�n=Datos[,"Length"]
Ciclos=Datos[,"Cycles"]

NivelesTensi�n=unique(Tensi�n);NivelesTensi�n
summary(Ciclos)

hist(Ciclos)
plot(Tensi�n,Ciclos,pch=19,yaxp=c(0,400,20),las=2)
FiltroT30=Tensi�n==30
FiltroT60=Tensi�n==60
FiltroT90=Tensi�n==90
points(Tensi�n[FiltroT30],Ciclos[FiltroT30],pch=19,col="firebrick")
points(Tensi�n[FiltroT60],Ciclos[FiltroT60],pch=19,col="navy")
points(Tensi�n[FiltroT90],Ciclos[FiltroT90],pch=19,col="orange")
lines(lowess(Tensi�n,Ciclos),lwd=3,col="chartreuse3")
#lowess un suavizador para una nube de puntos

hist(Ciclos[FiltroT30],main="Tensi�n de 30 cm")
hist(Ciclos[FiltroT60],main="Tensi�n de 60 cm")
hist(Ciclos[FiltroT90],main="Tensi�n de 90 cm")


Colores=c("firebrick","navy","orange")
Contador=1
for(N in NivelesTensi�n)
{
  hist(Ciclos[Tensi�n==N],main=paste("Tensi�n de",N,"cm"),xaxp=c(0,400,40),freq=F,
       xlab="Ciclos",col=Colores[Contador])
  Sys.sleep(3)
  Contador=Contador+1
}

#56. Logverosimilitud con Variables Explicativas
#Concentrado
hist(Ciclos,main="Niveles de tensi�n en",xaxp=c(0,400,40),
     xlab="Ciclos",col="black",breaks=seq(0,400,10),density=10,angle=0)
Colores=c("firebrick","navy","orange")
Contador=1
for(N in NivelesTensi�n)
{
  hist(Ciclos[Tensi�n==N],xaxp=c(0,400,40),col=Colores[Contador],
       breaks=seq(0,400,10),density=10,angle=45*Contador,add=T)
  Sys.sleep(3)
  Contador=Contador+1
}

#Propuestas de ajuste para todos los niveles
#Propuestas basadas en distribuciones individuales, pero para todos
hist(Ciclos,main="Niveles de tensi�n en",xaxp=c(0,400,40),freq=F,
     xlab="Ciclos",breaks=seq(0,400,10))
#Weibull
t=seq(0,400,1)
DWeibll=dweibull(t,shape=2,scale=170)
lines(t,DWeibll,lwd=2,col="navy")
#El ajuste debe abarcar todos los datos, no tanto que se ajuste al comportamiento 

#LogVerosmilitud con variable explicativa
LogVerosimilitud=function(Muestra,Densidad,Par�metros,Explicativa)
{
  LV=sum(log(Densidad(Muestra,Par�metros,Explicativa)))
  return(LV)
}

#Escala: LINEAL | Forma: CONSTANTE
DensidadWeibullVM1=function(t,theta,explicativa)
{
  B0Escala=theta[1]
  B1Escala=theta[2]
  B0Forma=theta[3]
  Escala=B0Escala+B1Escala*explicativa
  Forma=B0Forma
  d=dweibull(t,shape=Forma,scale=Escala)
  return(d)
}

LogVerosimilitud(Muestra=Ciclos,Densidad=DensidadWeibullVM1,
 Par�metros=c(B0Escala=170,B1Escala=0,B0Forma=2),Explicativa=Tensi�n)
#Se le da valor 0 para primero intentar ambos par�metros constantes

#Se iterar el optim para no encerrase en un local �ptimo
OptWeibullM1=optim(par=c(B0Escala=170,B1Escala=0,B0Forma=2),fn=LogVerosimilitud,
  Muestra=Ciclos,Densidad=DensidadWeibullVM1,Explicativa=Tensi�n,control=list(fnscale=-1))
OptWeibullM1