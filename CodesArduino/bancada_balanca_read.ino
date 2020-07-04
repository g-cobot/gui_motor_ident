/*       Universidade Federal de Uberlandia
          Faculdade de Engenharia Mecanica
              Engenharia Mecatrônica        
              Realizado em 02/12/2019
/*          Testar e arrumar a balanca                               */
/*          Atencao fazer teste com hélices                          */
          

//----------------------------------
//    BIBLIOTECAS
//----------------------------------

#include <SPI.h>
#include <Wire.h>
#include <math.h>
#include "HX711.h"
HX711 scale;

//----------------------------------
//    VARIAVEIS GLOBAIS
//---------------------------------- 

float t_k, t_km1, t_decorrido;
float N1,N2,N3,D1,D2,D3;
float Ta =0.010;//[segundos]
//----------------------------------
//   VARIAVEIS DOS MOTORES
//----------------------------------

float force=0.00;
float f_k=0.00;
float f_km1=0.00;
float f_km2=0.00;
float ff_km1=0.00;
float ff_km2=0.00;

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

  Serial.println("Before setting up the scale:");
  Serial.print("read: \t\t");
  Serial.println(scale.read());      // print a raw reading from the ADC

  Serial.print("read average: \t\t");
  Serial.println(scale.read_average(20));   // print the average of 20 readings from the ADC

  Serial.print("get value: \t\t");
  Serial.println(scale.get_value(5));   // print the average of 5 readings from the ADC minus the tare weight (not set yet)

  Serial.print("get units: \t\t");
  Serial.println(scale.get_units(5), 1);  // print the average of 5 readings from the ADC minus tare weight (not set) divided
  scale.set_scale(870.45);
  //scale.set_scale(872.84);
  //scale.set_scale(864.84);
  scale.tare();
//  How to calibrate your load cell
//Call set_scale() with no parameter.
//Call tare() with no parameter.
//Place a known weight on the scale and call get_units(10).
//Divide the result in step 3 to your known weight. You should get about the parameter you need to pass to set_scale().
//Adjust the parameter in step 4 until you get an accurate reading.

  //scale.set_scale(876.1252);    // this value is obtained by calibrating the scale with known weights;
  //scale.tare();               // reset the scale to 0

//  Serial.println("After setting up the scale:");
//
//  Serial.print("read: \t\t");
//  Serial.println(scale.read());                 // print a raw reading from the ADC
//
//  Serial.print("read average: \t\t");
//  Serial.println(scale.read_average(20));       // print the average of 20 readings from the ADC
//
//  Serial.print("read average: \t\t");
//  Serial.println(scale.read_average(20));       // print the average of 20 readings from the ADC
//
//  Serial.print("get value: \t\t");
//  Serial.println(scale.get_value(5));    // print the average of 5 readings from the ADC minus the tare weight, set with tare()
//
//  Serial.print("get units: \t\t");
//  Serial.println(scale.get_units(5), 1);        // print the average of 5 readings from the ADC minus tare weight, divided
//            // by the SCALE parameter set with set_scale
//  
//  Serial.print("get units: \t\t");
//  Serial.println(scale.get_units(5), 1);        // print the average of 5 readings from the ADC minus tare weight, divided
//    
//  Serial.println("Readings:");
  
  delay(500); /*Dê um tempo de espera(delay = 5 segundos) para conectar os propulsores e iniciar todo o sistema*/ 
  
}

//----------------------------------
//    VOID LOOP
//----------------------------------

void loop()
{
      readSensor();
      printInfo();
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

void printInfo(){
  Serial.print(millis()/1000.000);
  Serial.print("\t ");
  Serial.println(force);
  
}
void readSensor(){
  f_k= scale.get_units(1);
  force = filter2( ff_km1, ff_km2,f_k, f_km1, f_km2 , 1);
  housekeeping();
}

void housekeeping(){
  f_km2=f_km1;
  f_km1=f_k;
  ff_km2=ff_km1;
  ff_km1=force;
}
