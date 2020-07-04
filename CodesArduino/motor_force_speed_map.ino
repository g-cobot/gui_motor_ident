/*    Universidade Federal de Uberlandia
       Faculdade de Engenharia Mecanica
          Engenharia Mecatrônica        
          Realizado em 02/12/2019
/*          Realizar o ensaio de forca e velocidade do motor brushless        */
          

//----------------------------------
//    BIBLIOTECAS
//----------------------------------

#include <SPI.h>
#include <Wire.h>
#include <Servo.h>
#include <math.h>
#include "HX711.h"
HX711 scale;

//----------------------------------
//    OBJETOS
//----------------------------------

Servo Motor1; 

//----------------------------------
//    VARIAVEIS GLOBAIS
//---------------------------------- 

float t_ks,t_k, t_km1,now,newnow;
float N1,N2,N3,D1,D2,D3;
float deltaT;
float Ta =0.09;//[segundos]
int j=0;
double flagM = 1;
int flagComplete=0;
int count = 0, flagT= 284;
#define markersInMotor 10

//----------------------------------
//   VARIAVEIS DOS MOTORES
//----------------------------------
float U_0=1000;
float U=1000;
float ppm=1000;
float u_k=0;
float u_km1=0;

int i=0;
int counterspeed=0;

float force=0.00;
float f_k=0.00;
float f_km1=0.00;
float f_km2=0.00;
float ff_km1=0.00;
float ff_km2=0.00;

float vel=0.0;
float v_k=0.0;
float v_km1=0.00;
float v_km2=0.00;
float vv_km1=0.00;
float vv_km2=0.00;

// HX711 circuit wiring
#define LOADCELL_DOUT_PIN A1
#define LOADCELL_SCK_PIN A0

#define INPUT_SIZE 30
char input[INPUT_SIZE+1];
int rndSeed=8;
int start=0;
long value;
float startStep1=60,startStep2=172,stopTest=778;
String str=" ";
int rndAmp=0; 
//----------------------------------
//    VOID SETUP
//----------------------------------

void setup() {
  
  Serial.begin(115200); 

//Initialising the HX711 SCALE
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);
  //scale.set_scale(870.45);
  scale.set_scale(870.45);
  scale.tare();  scale.tare();   scale.tare();
  
  //======================
  //  MOTOR
  //======================

  Motor1.attach (7); //attach the motor to pin 7 MOTOR PRETO
  Motor1.writeMicroseconds(1); //DJI MOTOR Initialization

  randomSeed(rndSeed);

  attachInterrupt(digitalPinToInterrupt(2), speedInterrupt, FALLING);
  t_ks=millis();
  newnow=millis();
  delay(250);
  readSpeed();
  delay(250); 
}

//----------------------------------
//    VOID LOOP
//----------------------------------

void loop()
{
   t_k=millis();
   if(Serial.available()>0){
    byte size = Serial.readBytes(input, INPUT_SIZE);
    input[size] = 0;
    char* command = strtok(input, ";");
    char* separator = strchr(command, ' ');
    if (separator != 0)
    {
        // Actually split the string in 2: replace ' ' with 0
        *separator = 0;
        str=String((char*)command);
        // can we see it now?
        //Serial.println(str);
        ++separator;
        value = atol(separator);
        //Serial.println(value);
    }
    //Serial.println(str);
    if(str=="settimeStep1")// space or q
    {
      str=" ";
      startStep1=round(value/Ta);
      //Serial.print("Entrou no settimeStep1 e o startStep1 vale: ");
      //Serial.println(startStep1);
    }
    if(str=="settimeStep2")// space or q
    {
      str=" ";
      float aux=round(value/Ta);
      if(aux>startStep1){
        startStep2=aux;
      }
    }
    
    if(str=="setstopTest")// space or q
    {
     str=" ";
     float aux=round(value/Ta);
      if(aux>startStep2){
        stopTest=aux;
      }
    }
    if(str=="setStop")// space or q
    {
      str=" ";
      //Serial.println("Entrou no setstop");
      start=0;
      newnow=millis();
      ppm=1000;
      saturacao();
      Motor1.writeMicroseconds (ppm);
      u_k=map (ppm, 1000, 2000, 0, 100);
      flagComplete=0.0;
      flagT=0;
      i=1000;
      count=1000;
    }
    if(str=="setStart")// space or q
    {
      str=" ";
      //Serial.println("Entrou no setStart");
      start=1;
      newnow=millis();
      ppm=1000;
      saturacao();
      Motor1.writeMicroseconds (ppm);
      u_k=map (ppm, 1000, 2000, 0, 100);
      flagT=startStep2+120;
      flagComplete=0;
      i=0;
      count=0;
    }
    if(str=="setRestart")// space or q
    {
      str=" ";
      start=1;
      newnow=millis();
      ppm=1000;
      saturacao();
      Motor1.writeMicroseconds (ppm);
      u_k=map (ppm, 1000, 2000, 0, 100);
      flagT=startStep2+120;
      flagComplete=0;
      i=0;
      count=0;
    }
    if(str=="setTsample")// space or q
    {
      str=" ";
      //Serial.println("Entrou no setTsample"); 
      if(value<0.09){
        Ta=0.09;}
      if(value>0.09){
        Ta=0.09;}
    }
    if(str=="setAmp_Degrau")// space or q
    {
      
      str=" ";
      if(value==0.0){
        U_0=1000;
        U=1150;
        rndAmp=0;   
      }
      if(value==1.0){
        U_0=1150;
        U=1200;
        rndAmp=0;   
      }
      if(value==2.0){
        U_0=1150;
        U=1300;
        rndAmp=0;   
      }
      if(value==3.0){
        U_0=1150;
        U=1400;
        rndAmp=0;   
      }
      if(value==4.0){
        U_0=1150;
        U=1500;
        rndAmp=0; 
      }
      if(value==5.0){
        U_0=1150;
        U=1600;
        rndAmp=0;  
      }
      if(value==6.0){
        U_0=1150;
        U=1700;
        rndAmp=0;   
      }
      if(value==7.0){
        U_0=1400;
        U=1500;
        rndAmp=1; 
      }
      if(value==8.0){
        U_0=1400;
        U=1430;
        rndAmp=1; 
      }
    }
    if(str=="setNum_Ensaio")// space or q
    {
      
      str=" ";
      if(value==0.0){
        rndSeed=8;
        randomSeed(rndSeed);  
      }
      if(value==1.0){
        rndSeed=2;
        randomSeed(rndSeed);  
      }
      if(value==2.0){
        rndSeed=4;
        randomSeed(rndSeed);  
      }
      if(value==3.0){
        rndSeed=12;
        randomSeed(rndSeed);  
      }
      if(value==4.0){
        rndSeed=16;
        randomSeed(rndSeed);  
      }
      if(value==5.0){
        rndSeed=200;
        randomSeed(rndSeed);  
      }
      if(value==6.0){
        rndSeed=50;
        randomSeed(rndSeed);  
      }
    }      
  }
   
  if(start==1){ 
    
    if(i==(startStep1)) {
        ppm=U_0;
        u_k=map (ppm, 1000, 2000, 0, 100);
        saturacao();
        Motor1.writeMicroseconds (ppm);
    }
    
    if(i==(startStep2)) {
      ppm=U;
      u_k=map (ppm, 1000, 2000, 0, 100);
      saturacao();
      Motor1.writeMicroseconds (ppm);
    }
    if(i==(stopTest)) {
      flagComplete=1.0;
      count=1000;
      flagT =0;
      flagM =0;
      ppm=1000;
      u_k=map (ppm, 1000, 2000, 0, 100);
      Motor1.writeMicroseconds (ppm);
     }
    if(count == flagT){
     if(rndAmp==1){
        flagM = (random(-100, 100)/100.00);
        ppm = flagM*(U-U_0)+U_0;
//        Serial.println(flagM);
//        Serial.println(ppm); 
     }
     else{
        flagM=1-flagM;
        ppm=U*flagM+(1-flagM)*U_0;
     }
     u_k=map(ppm, 1000, 2000, 0, 100);
     saturacao();
     Motor1.writeMicroseconds (ppm);
     flagT = random(1, 60);
     count = 0;
    }
  }
  readSensor();
  printInfo();
   
  while( (millis()- t_k)/1000 < Ta)
        {
          //Wait for the next amostragem 
        }
  i++;
  count++;  
}


//----------------------------------
//    SUBROTINAS
//----------------------------------
double filter2( double okm1, double okm2,double ik, double ikm1, double ikm2 , int wn ){
    //Filtro butter(2,0.4)
      N1=0.2066;
      N2=0.4131;
      N3=0.2066;
      
      D1=1.0000;
      D2=-0.3695;
      D3=0.1958;
  double ok;
  ok = ( (N1)* ik + (N2) * ikm1 + (N3) * ikm2 - D2 * okm1 - D3 * okm2 )/(D1);
  return  ok ;
}


void saturacao(){
  
  /*Saturaçao da variavel de comando entre 1000us e 2000us*/
  //MOTOR 1 PRETO
  if(ppm < 1000)
  {
    ppm = 1000;
  }
  if(ppm > 1580)
  {
   ppm=1000;
  }
}

void printInfo(){
  readSpeed();
  Serial.print((millis()/1000.000)-(newnow/1000));
  Serial.print("\t ");
  Serial.print(ppm);
  Serial.print("\t ");
  Serial.print(u_k);
  Serial.print("\t ");
  Serial.print(force);
  Serial.print("\t ");
  Serial.print(vel);
  Serial.print("\t ");
  Serial.print(flagComplete);
  Serial.print("\t ");
  Serial.print(Ta);
  Serial.print("\t ");
  Serial.print(flagM); 
  Serial.print("\t ");
  Serial.print(count); 
  Serial.print("\t ");
  Serial.print(startStep1); 
  Serial.print("\t ");
  Serial.print(startStep2); 
  Serial.print("\t "); 
  Serial.print(flagT); 
  Serial.print("\t ");
  Serial.print(stopTest); 
  Serial.print("\t ");
  Serial.print(U); 
  Serial.print("\t ");
  Serial.print(rndSeed);
  Serial.print("\t ");
  Serial.println(start); 
  vel=0;
}

void speedInterrupt(){
  counterspeed=counterspeed+1;
}

void readSensor(){
  f_k= scale.get_units(1);
  force = filter2( ff_km1, ff_km2,f_k, f_km1, f_km2 , 1);
  housekeeping();
}
void readSpeed(){
  detachInterrupt(digitalPinToInterrupt(2));
  now=millis();
  deltaT=(now-t_ks);
  v_k= (counterspeed/markersInMotor)/(deltaT/60000);
  vel=filter2( vv_km1, vv_km2,v_k, v_km1, v_km2 , 1);
  housekeeping2();
  counterspeed=0;
  t_ks=millis();
  attachInterrupt(digitalPinToInterrupt(2), speedInterrupt, FALLING);
}

void housekeeping(){
  f_km2=f_km1;
  f_km1=f_k;
  ff_km2=ff_km1;
  ff_km1=force;
}

void housekeeping2(){
  v_km2=v_km1;
  v_km1=v_k;
  vv_km2=vv_km1;
  vv_km1=vel;
}
