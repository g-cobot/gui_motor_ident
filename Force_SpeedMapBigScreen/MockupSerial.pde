// If you want to debug the plotter without using a real serial port

int mockupValue = 0;
int mockupDirection = 10;
int count=0;
float uk=0,ukm1=0;
float sk=0,skm1=0,skm2=0;
float fk=0,fkm1=0,fkm2=0;

float scoef0=1.383,scoef1=1.069,scoef2=-0.2178;
float fcoef0=2.446,fcoef1=1.726,fcoef2=-0.7802;

String mockupSerialFunction(boolean start) {

  if(start==true){
    if(count==60){
     mockupValue=1145;
     uk = map(mockupValue, 1000, 2000, 0, 100);
    }
    if(count==172){
     mockupValue=1200;
     uk = map(mockupValue, 1000, 2000, 0, 100);
    }
    if(count==278){
     mockupValue=1145;
     uk = map(mockupValue, 1000, 2000, 0, 100);
    }
    if(count==748){
     mockupValue=1000;
     uk = map(mockupValue, 1000, 2000, 0, 100);
    }
  }
  
  if(start==false){
    uk=0;
    count=0;
  }
  
  forcefunction();
  speedfunction();
  
  String r = "";
  for (int i = 0; i<6; i++) {
    switch (i) {
    case 0:
      r += count+" ";
      break;
    case 1:
      r += mockupValue+" ";
      break;
    case 2:
      r += uk+" ";
      break;
    case 3:
      r += fk+" "; 
      break;
    case 4:
      r += sk +" ";
      break;
    case 5:
       r += 0+" ";
      break;
    }
    if (i < 7)
      r += '\r';
  }
  housekeeping();
  delay(90);
  count=count+1;
  return r;
}

void housekeeping(){
  skm2=skm1;
  skm1=sk;
  
  fkm2=fkm1;
  fkm1=fk;
  
  ukm1=uk; 
}

void speedfunction(){
  sk=scoef0*ukm1+scoef1*skm1+scoef2*skm2;
}

void forcefunction(){
  fk=fcoef0*ukm1+fcoef1*fkm1+fcoef2*fkm2;
}
