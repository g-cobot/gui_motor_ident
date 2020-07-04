/*    Universidade Federal de Uberlandia
       Faculdade de Engenharia Mecanica
          Engenharia Mecatrônica        
          Realizado em 02/12/2019
/*          Testar PWM ppm limite inferior e maximo          */
/*          Atencao fazer teste sem as hélices               */
          

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

float t_ks,t_k, t_km1, t_decorrido,now;
float N1,N2,N3,D1,D2,D3;
float vel,deltaT;
float Ta =0.09;//[segundos]
int j=0;
#define markersInMotor 10
//----------------------------------
//   VARIAVEIS DOS MOTORES
//----------------------------------
int command;
int pwm=1000;
int flag=0;
int counterspeed=0;
float force=0.00;
float f_k=0.00;
float f_km1=0.00;
float f_km2=0.00;
float ff_km1=0.00;
float ff_km2=0.00;
float v_k=0.00;
float v_km1=0.00;
float v_km2=0.00;
float vv_km1=0.00;
float vv_km2=0.00;

// HX711 circuit wiring
#define LOADCELL_DOUT_PIN A1
#define LOADCELL_SCK_PIN A0

//----------------------------------
//    VOID SETUP
//----------------------------------

void setup() {
  
  Serial.begin(115200); 

//Initialising the HX711 SCALE
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);

  scale.set_scale(870.45);
  scale.tare();  scale.tare();   scale.tare();
  
  //======================
  //  MOTOR
  //======================

  Motor1.attach (7); //attach the motor to pin 7 MOTOR PRETO
  Motor1.writeMicroseconds(1); //DJI MOTOR Initialization


  attachInterrupt(digitalPinToInterrupt(2), speedInterrupt, FALLING);
  t_ks=millis();
  delay(1000); /*Dê um tempo de espera(delay = 1 segundos) para conectar os propulsores e iniciar todo o sistema*/ 
    
  
 
}

//----------------------------------
//    VOID LOOP
//----------------------------------

void loop()
{
   t_k=millis();
 if(Serial.available()>0)
  {
   command=Serial.read();
//  //MOTOR 
  if(command==102)//letra f
    {
      pwm=pwm+100;
      saturacao();
      Motor1.writeMicroseconds (pwm); 
      
    }
   if(command==103)//letra g
    {
      pwm=pwm-100;
      saturacao();
      Motor1.writeMicroseconds (pwm); 
    }
  if(command==101)//letra e
    {
      pwm=pwm+46;
      saturacao();
      Motor1.writeMicroseconds (pwm); 
    }
  if(command==116)//letra t
    {
      pwm=pwm+1;
      saturacao();
      Motor1.writeMicroseconds (pwm); 
    }
   if(command==114)//letra r
    {
      pwm=pwm-46;
      saturacao();
      Motor1.writeMicroseconds (pwm); 
    }
    if(command==121)//letra y
    {
      pwm=pwm-1;
      saturacao();
      Motor1.writeMicroseconds (pwm); 
    }
    if(command==32||command==113)// space or q
    {
      Motor1.writeMicroseconds (1); //full reverse. The ESC will automatically brake the motor.
      pwm=1000;
    }   
   }
     
      readSensor();
      printInfo();

   while( (millis()- t_k)/1000 < Ta)
        {
          //Wait for the next amostragem 
        }
      
}


//----------------------------------
//    SUBROTINAS
//----------------------------------
double filter2( double okm1, double okm2,double ik, double ikm1, double ikm2 , int wn ){
  switch (wn) {
    case 1:
    //Filtro butter(2,0.4)
      N1=0.2066;
      N2=0.4131;
      N3=0.2066;
      
      D1=1.0000;
      D2=-0.3695;
      D3=0.1958;

      break;
    case 2:
      //Filtro butter(2,0.5)
      N1=0.2929;
      N2=0.5858;
      N3=0.2929;
      
      D1=1.0000;
      D2=0.0000;
      D3=0.1716;

  
      break;
    case 3:
      //Filtro butter(2,0.6)
      N1=0.3913;
      N2=0.7827;
      N3=0.3913;
      
      D1=1.0000;
      D2=0.3695;
      D3=0.1958;

      break;
    case 4:
      //Filtro butter(2,0.7)
      N1=0.5050;
      N2=1.0100;
      N3=0.5050;
      
      D1=1.0000;
      D2=0.7478;
      D3=0.2722;
  
      break;
    case 5:
      //Filtro butter(2,0.8)
      N1=0.6389;
      N2=1.2779;
      N3=0.6389;
      
      D1=1.0000;
      D2=1.1430;
      D3=0.4128;
      break;
    default:
      break;
  }
  double ok;
  ok = ( (N1)* ik + (N2) * ikm1 + (N3) * ikm2 - D2 * okm1 - D3 * okm2 )/(D1);
  return  ok ;
}


void saturacao(){
  
  /*Saturaçao da variavel de comando entre 1000us e 2000us*/
  //MOTOR 1 PRETO
  if(pwm < 1000)
  {
    pwm = 1000;
  }
  if(pwm > 2000)
  {
   pwm=2000;
  }
}

void printInfo(){
  readSpeed();
  Serial.print(millis()/1000.000);
  Serial.print("\t ");
  Serial.print(pwm);
  Serial.print("\t ");
  Serial.print(map (pwm, 1000, 2000, 0, 100));
  Serial.print("\t ");
  Serial.print(force);
  Serial.print("\t ");
  Serial.print(vel);
  Serial.print("\t ");
  Serial.print(deltaT); 
  Serial.print("\t ");
  Serial.println(flag);
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
  //v_kr= ((counterspeed/markersInMotor)*2*PI)/(deltaT/1000);
  vel=filter2( vv_km1, vv_km2,v_k, v_km1, v_km2 , 1);
  housekeeping2();
  Serial.println(counterspeed); 
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
