/*    Universidade Federal de Uberlandia
       Faculdade de Engenharia Mecanica
          Engenharia Mecatrônica        
          Realizado em 02/12/2019
/*          Simular o teste e testar serial comunication          */
          

float t_ks,t_k, t_km1, t_decorrido,now,newnow;
float N1,N2,N3,D1,D2,D3;
float deltaT;
float Ta =0.09;//[segundos]
int j=0;
double flagM = 1;
int flagComplete=0;
int i=0;
int count = 0, flagT= 284;

int ppm=1000;
float U=1200;
int u_k=0;
int u_km1=0;

float f_k=0.00;
float f_km1=0.00;
float f_km2=0.00;

float v_k=0.0;
float v_km1=0.00;
float v_km2=0.00;

float scoef0=1.383,scoef1=1.069,scoef2=-0.2178;
float fcoef0=2.446,fcoef1=1.726,fcoef2=-0.7802;
#define INPUT_SIZE 30
char input[INPUT_SIZE+1];
int rndSeed=8;
boolean start=false;
long value;
float startStep1=60,startStep2=172,stopTest=778;
String str=" ";
void setup() {
  Serial.begin(115200); 
  randomSeed(rndSeed);
  t_ks=millis();
  newnow=millis();
  delay(250);
}

void loop() {
  t_k=millis();
  if(Serial.available()>0)
  {
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
      start=false;
      newnow=millis();
      ppm=1000;
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
      start=true;
      newnow=millis();
      ppm=1000;
      u_k=map (ppm, 1000, 2000, 0, 100);
      flagT=startStep2+120;
      flagComplete=0.0;
      i=0;
      count=0;
    }
    if(str=="setRestart")// space or q
    {
      str=" ";
      start=true;
      newnow=millis();
      ppm=1000;
      u_k=map (ppm, 1000, 2000, 0, 100);
      flagT=startStep2+120;
      flagComplete=0.0;
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
        U=1145;  
      }
      if(value==1.0){
        U=1200;  
      }
      if(value==2.0){
        U=1300;  
      }
      if(value==3.0){
        U=1400;  
      }
      if(value==4.0){
        U=1500;  
      }
      if(value==5.0){
        U=1600;  
      }
      if(value==6.0){
        U=1700;  
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


  if(start==true){ 
    //Comecar com u+14.5
     if(i==(startStep1)) {
      ppm=1146;
      u_k=map (ppm, 1000, 2000, 0, 100);
     }
    if(i==(startStep2)) {
      ppm=U;
      u_k=map (ppm, 1000, 2000, 0, 100);
     }
    //Finalisa em t=70segundos com u+14.5
    if(i==(stopTest)) {
      flagComplete=1.0;
      count=1000;
      flagT =0;
      flagM =0;
      ppm=1000;
      u_k=map (ppm, 1000, 2000, 0, 100);
     }
    // Variando duraçao do degrau
   if(count == flagT){
    
     flagM = 1-flagM;
     ppm=U*flagM+(1-flagM)*1000;
     u_k=map(ppm, 1000, 2000, 0, 100);
     
     flagT = random(1, 60);
     count = 0;
  }
 }
 readSensor();
 readSpeed();
 printInfo();
 while( (millis()- t_k)/1000 < Ta)
        {
          //Wait for the next amostragem 
        }
 i++;
 count++;  
}
void printInfo(){
  Serial.print((millis()/1000.000)-(newnow/1000));
  Serial.print("\t ");
  Serial.print(ppm);
  Serial.print("\t ");
  Serial.print(u_k);
  Serial.print("\t ");
  Serial.print(f_k);
  Serial.print("\t ");
  Serial.print(v_k);
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
}
void readSensor(){
  f_k=fcoef0*u_km1+fcoef1*f_km1+fcoef2*f_km2;
  housekeeping();
}
void readSpeed(){
  v_k=scoef0*u_km1+scoef1*v_km1+scoef2*v_km2;
  housekeeping2();
}

void housekeeping(){
  f_km2=f_km1;
  f_km1=f_k;
}
void housekeeping2(){
  v_km2=v_km1;
  v_km1=v_k;
  u_km1=u_k;
}
