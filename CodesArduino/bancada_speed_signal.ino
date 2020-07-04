/*    Universidade Federal de Uberlandia
       Faculdade de Engenharia Mecanica
          Engenharia Mecatrônica        
          Realizado em 02/12/2019
/*          Testar  o leitor de velocidade         */
/*          Atencao fazer teste sem as hélices                          */
          

//----------------------------------
//    BIBLIOTECAS
//----------------------------------

#include <SPI.h>
#include <Wire.h>
#include <math.h>

//----------------------------------
//    VARIAVEIS GLOBAIS
//---------------------------------- 

float t_k, t_km1, t_decorrido,now;
float N1,N2,N3,D1,D2,D3;
float Ta =0.010;//[segundos]
int j=0;
//----------------------------------
//   VARIAVEIS DOS MOTORES
//----------------------------------

int data=0;
int flagspeed=0;
float f_k=0.00;
float f_km1=0.00;
float f_km2=0.00;
float ff_km1=0.00;
float ff_km2=0.00;

//----------------------------------
//    VOID SETUP
//----------------------------------

void setup() {
  
  Serial.begin(115200); 
  
  pinMode(2,INPUT);
  attachInterrupt(digitalPinToInterrupt(2), speedInterrupt, FALLING);
  delay(500); /*Dê um tempo de espera(delay = 5 segundos) para conectar os propulsores e iniciar todo o sistema*/ 
 
}

//----------------------------------
//    VOID LOOP
//----------------------------------

void loop()
{
      t_k=millis();
      data=digitalRead(2);
      printInfo();
       
}


//----------------------------------
//    SUBROTINAS
//----------------------------------
void speedInterrupt(){
  flagspeed=flagspeed+1;
  }

void printInfo(){
  Serial.print(flagspeed);
  Serial.print("\t ");
  Serial.println(data);
}
