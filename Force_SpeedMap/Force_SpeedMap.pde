
// import libraries
import java.awt.Frame;
import java.awt.BorderLayout;
import java.util.*;
import controlP5.*; // http://www.sojamo.de/libraries/controlP5/
import processing.serial.*;

/* SETTINGS BEGIN */

// Serial port to connect to
String serialPortName = "COM7";

// If you want to debug the plotter without using a real serial port set this to true
boolean mockupSerial = false;
boolean start=false;
boolean conection=true; 
/* SETTINGS END */



Serial serialPort; // Serial port object

// interface stuff
ControlP5 cp5;
Textarea myTextarea;
//ControlFrame cf;

// Settings for the plotter are saved in this file
JSONObject testConfigJSON;

int xPos=650;
int yPos=90;

int height=90;
int width=600;

// plots

Graph speed = new Graph(xPos, yPos, width, height, color (20, 20, 200));
Graph force= new Graph(xPos, yPos+2*110, width, height, color (20, 20, 200));
Graph input = new Graph(xPos, yPos+4*110, width, height, color (20, 20, 200));

Textlabel myTextlabelA;
Textlabel myTextlabelB;
Textlabel myTextlabelC;
Textlabel myTextlabelD;
Textlabel myTextlabelE;
Textlabel myTextlabelF;
Textlabel myTextlabelG;
Textlabel myTextlabelH;
Textlabel myTextlabelI;
Textlabel myTextlabelJ;
Textlabel myTextlabelK;
Textlabel myTextlabelL;
Textlabel myTextlabelM;
Textlabel myTextlabelN;

float[][] lineGraphValues = new float[6][100];
float[] lineGraphSampleNumbers = new float[100];
color[] graphColors = new color[6];


String mod_mot="MODMOTOR";
String sent_rot="M00";
String amp_step="A01";
String num_test="N01";

String filename= mod_mot+"_"+sent_rot+"_"+amp_step+"_"+num_test+".txt";


// helper for saving the executing path
String topSketchPath = "";

  void settings() {
    fullScreen(2);
    //size(1400, 800);
}
PrintWriter output; 

void setup() {
  testConfigJSON = loadJSONObject(topSketchPath+"/test_config.json");
  
  surface.setTitle("GUI INPUTXSPEEDXFORCE MAP");
 // size(1165, 800);
 
  input.xLabel=" Time [s] ";
  input.yLabel="Input Amplitude [%]";
  input.Title=" Input x Time [s] ";  
  
  speed.xLabel=" Time [s] ";
  speed.yLabel=" Velocidade Amplitude [rad/s]";
  speed.Title=" Velocidade [rad/s] x Time [s] ";  
  
  force.xLabel=" Time [s] ";
  force.yLabel=" Force [mN]";
  force.Title="Force x Time ";  
  

  // set line graph colors
  graphColors[0] = color(131, 255, 20);
  graphColors[1] = color(232, 158, 12);
  graphColors[2] = color(255, 0, 0);
  graphColors[3] = color(62, 12, 232);
  graphColors[4] = color(13, 255, 243);
  graphColors[5] = color(200, 46, 232);

  // settings save file
  topSketchPath = sketchPath();

  // gui
  cp5 = new ControlP5(this);
 //// extra control panel frame
 // cf = new ControlFrame(this, 500, 650, "Robot Tuner");
  
  // build x axis values for the line graph
  for (int i=0; i<lineGraphValues.length; i++) {
    for (int k=0; k<lineGraphValues[0].length; k++) {
      lineGraphValues[i][k] = 0;
      if (i==0)
        lineGraphSampleNumbers[k] = k;
    }
  }
  
  // start serial communication
  if (!mockupSerial) {
    serialPort = new Serial(this, serialPortName, 115200);
  }
  else
    serialPort = null;

  // build the gui
  int x = 170;
  int y = 60;
  //cp5.addToggle("ZeroTime").setPosition(x=13, y=330).setValue(0).setMode(ControlP5.SWITCH).setColorActive(graphColors[0]);
  //PImage[] laa_imgs = {loadImage("images/laagreen.png"),loadImage("images/laablue.png"),loadImage("images/laared.png")};
  
  cp5.addButton("laa")
     .setPosition(125,30)
     .setImage(loadImage("images/laagray.png"))
     .updateSize()
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
     
  myTextlabelA = cp5.addTextlabel("label1")
                    .setText("Configurações do teste:")
                    .setPosition(240,240)
                    .setColorValue(255)
                    .setFont(createFont("Arial",15))
                    ;
                    
  myTextlabelB = cp5.addTextlabel("label2")
                    .setText("[sec]")
                    .setPosition(289,270)
                    .setColorValue(255)
                    .setFont(createFont("Arial",12))
                    ;
  myTextlabelC = cp5.addTextlabel("label3")
                    .setText("[sec]")
                    .setPosition(289,310)
                    .setColorValue(255)
                    .setFont(createFont("Arial",12))
                    ;
  myTextlabelD = cp5.addTextlabel("label4")
                    .setText("[sec]")
                    .setPosition(380,310)
                    .setColorValue(255)
                    .setFont(createFont("Arial",12))
                    ;
  myTextlabelE = cp5.addTextlabel("label5")
                    .setText("[sec]")
                    .setPosition(380,270)
                    .setColorValue(250)
                    .setFont(createFont("Arial",12))
                    ;
  
  myTextlabelF = cp5.addTextlabel("label6")
                    .setText("Configurações retidas pelo Arduino:")
                    .setPosition(240,350)
                    .setColorValue(255)
                    .setFont(createFont("Arial",15))
                    ;
  
   
    myTextlabelH = cp5.addTextlabel("label8")
                    .setText("TSAMPLE")
                    .setPosition(250,400)
                    .setColorValue(255)
                    ;
    myTextlabelK = cp5.addTextlabel("Tsam")
                    .setText("NAN"+" [sec]")
                    .setPosition(250,380)
                    .setColorValue(255)
                    ;
    myTextlabelI = cp5.addTextlabel("label9")
                    .setText("TIMESTEP1")
                    .setPosition(250,440)
                    .setColorValue(255)
                    ;
    myTextlabelM = cp5.addTextlabel("Step1")
                    .setText("NAN"+" [sec]")
                    .setPosition(250,420)
                    .setColorValue(255)
                    ;
    myTextlabelJ = cp5.addTextlabel("label10")
                    .setText("TIMESTEP2")
                    .setPosition(320,440)
                    .setColorValue(255)
                    ;
    myTextlabelN = cp5.addTextlabel("Step2")
                    .setText("NAN"+" [sec]")
                    .setPosition(320,420)
                    .setColorValue(255)
                    ;
   myTextlabelG = cp5.addTextlabel("label7")
                    .setText("STOPTEST")
                    .setPosition(320,400)
                    .setColorValue(255)
                    ;
   
    myTextlabelL = cp5.addTextlabel("stopT")
                    .setText("NAN"+" [sec]")
                    .setPosition(320,380)
                    .setColorValue(255)
                    .setColorBackground(color(255))
                    .setColorForeground(color(255)) 
                    ;
   
   myTextlabelG = cp5.addTextlabel("label11")
                    .setText("STEPAMP")
                    .setPosition(400,400)
                    .setColorValue(255)
                    ;
   
    myTextlabelL = cp5.addTextlabel("stepAmp")
                    .setText("NAN"+" [%]")
                    .setPosition(400,380)
                    .setColorValue(255)
                    .setColorBackground(color(255))
                    .setColorForeground(color(255)) 
                    ;
    myTextlabelG = cp5.addTextlabel("label12")
                    .setText("rndSeed")
                    .setPosition(400,440)
                    .setColorValue(255)
                    ;
   
    myTextlabelL = cp5.addTextlabel("rndSeed")
                    .setText("NAN")
                    .setPosition(400,420)
                    .setColorValue(255)
                    .setColorBackground(color(255))
                    .setColorForeground(color(255)) 
                    ;
    
   
  //cp5.addTextfield("Baudrate")
  //  .setPosition(x=340, y=270)
  //  .setColorBackground(color(60))
  //  .setColorForeground(color(88)) 
  //  .setText(getTestConfigString("Baudrate"))
  //  .setWidth(40)
  //  .setAutoClear(false)
  //; 
     
  cp5.addTextfield("Tsample")
    .setPosition(x=250, y=270)
    .setColorBackground(color(60))
    .setColorForeground(color(88))
    .setText(getTestConfigString("Tsample"))
    .setWidth(40)
    .setAutoClear(false)
  ; 

  cp5.addTextfield("timeStep1")
    .setPosition(x=250, y=310)
    .setText(getTestConfigString("timeStep1"))
    .setWidth(40)
    .setAutoClear(false)
    ; 
  cp5.addTextfield("timeStep2")
    .setPosition(x=340, y=310)
    .setText(getTestConfigString("timeStep2"))
    .setWidth(40)
    .setAutoClear(false)
  ;
  cp5.addTextfield("stopTest")
    .setPosition(x=340, y=270)
    .setText(getTestConfigString("stopTest"))
    .setWidth(40)
    .setAutoClear(false)
  ; 
  
  List modmotor = Arrays.asList("EMax_E2216", "Dji_2216");
  List ampdeg = Arrays.asList("14%", "20%", "30%", "40%", "50%", "60%", "70%");
  List sentrot = Arrays.asList("CCW", "CW");
  List ntest = Arrays.asList("1", "2", "3", "4", "5");
  //* add a ScrollableList, by default it behaves like a DropdownList */
  cp5.addScrollableList("Modelo_motor")
     .setPosition(30, 480)
     .setSize(100, 100)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(modmotor)
     .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
     ;
  cp5.addScrollableList("sent_rot")
     .setPosition(140, 480)
     .setSize(100, 100)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(sentrot)
     .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
     ;
  cp5.addScrollableList("Amp_Degrau")
     .setPosition(250, 480)
     .setSize(100, 100)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(ampdeg)
      .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
     ;
  
  cp5.addScrollableList("Num_Ensaio")
     .setPosition(360, 480)
     .setSize(100, 100)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(ntest)
     .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
     ;   
  
  cp5.addTextfield("nome do arquivo")
     .setPosition(30,590)
     .setSize(200,40)
     .setColorBackground(color(60))
     .setColorForeground(color(88)) 
     .setColor(color(255,255,255))
     .setText(filename)
     .setAutoClear(false)
     ;
     
     PFont pfont = createFont("Arial",15,false); // use true/false for smooth/no-smooth
     ControlFont font = new ControlFont(pfont,20);
     
   
   PImage[] start_imgs = {loadImage("images/start_a.png"),loadImage("images/start_a.png"),loadImage("images/start_b.png")};
   PImage[] stop_imgs = {loadImage("images/stop_a.png"),loadImage("images/stop_a.png"),loadImage("images/stop_b.png")};
   PImage[] restart_imgs = {loadImage("images/restart_a.png"),loadImage("images/restart_a.png"),loadImage("images/restart_b.png")};
  
   cp5.addBang("Restart")
     .setPosition(55,258)
     .setImages(restart_imgs)
     .setValue(1.0)
     .hide()
     .setTriggerEvent(Bang.RELEASE)
     .setSize(150,80)
     .setColorForeground(color(180,180,0))
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
   cp5.addBang("Start")
     .setPosition(55,258)
     .setValue(1.0)
     .setImages(start_imgs)
     .setTriggerEvent(Bang.RELEASE)
     .setSize(150,80)
     .setColorForeground(color(40,150,40))
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  
   cp5.addBang("Stop")
     .setPosition(55,350)
     .setImages(stop_imgs)
     .setValue(1.0)
     .setSize(150,80)
     .setFont(font)
     .setColorBackground(color(40))
     .setColorForeground(color(150,40,40))
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;    
 
  //cp5.addBang("Save")
  //   .setPosition(250,590)
  //   .setSize(80,40)
  //   .setColorBackground(color(60))
  //   .setColorForeground(color(40,150,40))
  //   .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
  //   ; 
       
  cp5.addBang("Clear")
     .setPosition(250,590)
     .setSize(80,40)
     .setColorForeground(color(150,40,40))
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;    
     myTextarea = cp5.addTextarea("Console_log")
                  .setPosition(30,700)
                  .setSize(500,50)
                  .setBorderColor(255) 
                  .setFont(createFont("arial",12))
                  .setLineHeight(14)
                  .setColor(color(255))
                  .setColorBackground(color(0,0,0))
                  ;
  myTextarea.setText("Interface Grafica inicializada, aguardando conexao com microcontrolador.");
     
  //cp5.addToggle("lgVisible2").setPosition(x, y=y+40).setValue(int(getPlotterConfigString("lgVisible2"))).setMode(ControlP5.SWITCH).setColorActive(graphColors[1]);
  //cp5.addToggle("lgVisible3").setPosition(x, y=y+40).setValue(int(getPlotterConfigString("lgVisible3"))).setMode(ControlP5.SWITCH).setColorActive(graphColors[2]);
  //cp5.addToggle("lgVisible4").setPosition(x, y=y+40).setValue(int(getPlotterConfigString("lgVisible4"))).setMode(ControlP5.SWITCH).setColorActive(graphColors[3]);
  //cp5.addToggle("lgVisible5").setPosition(x, y=y+40).setValue(int(getPlotterConfigString("lgVisible5"))).setMode(ControlP5.SWITCH).setColorActive(graphColors[4]);
  //cp5.addToggle("lgVisible6").setPosition(x, y=y+40).setValue(int(getPlotterConfigString("lgVisible6"))).setMode(ControlP5.SWITCH).setColorActive(graphColors[5]);
}
public void Clear() {
  cp5.get(Textfield.class,"nome do arquivo").clear();
}

//public void Save() {

//}
public void Start() {
  input.restartTime();
  force.restartTime();
  speed.restartTime();
  myTextarea.setText(" Teste Inicializado!"
                    +"\n Salvando dados no arquivo: "+cp5.get(Textfield.class,"nome do arquivo").getText() );
 
  filename=cp5.get(Textfield.class,"nome do arquivo").getText();
  output = createWriter(filename);
  cp5.get(Button.class,"laa").setImage(loadImage("images/laayellow.png"));
  cp5.get(Bang.class,"Start").hide();
  cp5.get(Bang.class,"Restart").show();
  start=true;
}
public void Restart() {
  output.close(); // Finishes the 
  start=false;
  input.restartTime();
  force.restartTime();
  speed.restartTime();
  //mockupSerialFunction(start);
  myTextarea.setText(" Teste Reinicializado!"
                    +"\n Salvando dados no arquivo: "+cp5.get(Textfield.class,"nome do arquivo").getText() );
 
  filename=cp5.get(Textfield.class,"nome do arquivo").getText();
  output = createWriter(filename);
  cp5.get(Button.class,"laa").setImage(loadImage("images/laayellow.png"));
  start=true;
}
public void Stop() {
  
  if(start==true){
    start=false;
    output.close(); // Finishes the file
    input.restartTime();
    force.restartTime();
    speed.restartTime();
    myTextarea.setText(" Teste Interrompido!"
                    +"\n Dados salvos em : "+cp5.get(Textfield.class,"nome do arquivo").getText() );
   cp5.get(Button.class,"laa").setImage(loadImage("images/laared.png"));
   cp5.get(Bang.class,"Start").show();
   cp5.get(Bang.class,"Restart").hide();
  }
  
}

void sent_rot(int n) {
  sent_rot=cp5.get(ScrollableList.class, "sent_rot").getItem(n).get("text").toString();
  filename=mod_mot+"_"+sent_rot+"_"+amp_step+"_"+num_test+".txt";
  cp5.get(Textfield.class,"nome do arquivo").setText(filename);
  
  CColor c = new CColor();
  c.setBackground(color(255,0,0));
  cp5.get(ScrollableList.class, "sent_rot").getItem(n).put("color", c);
}
void Num_Ensaio(int n) {
  num_test=cp5.get(ScrollableList.class, "Num_Ensaio").getItem(n).get("text").toString();
  filename=mod_mot+"_"+sent_rot+"_"+amp_step+"_"+num_test+".txt";
  cp5.get(Textfield.class,"nome do arquivo").setText(filename);
  
  CColor c = new CColor();
  c.setBackground(color(255,0,0));
  cp5.get(ScrollableList.class, "Num_Ensaio").getItem(n).put("color", c);
}
void Amp_Degrau(int n) {
  amp_step=cp5.get(ScrollableList.class, "Amp_Degrau").getItem(n).get("text").toString();
  filename=mod_mot+"_"+sent_rot+"_"+amp_step+"_"+num_test+".txt";
  cp5.get(Textfield.class,"nome do arquivo").setText(filename);
  
  CColor c = new CColor();
  c.setBackground(color(255,0,0));
  
  cp5.get(ScrollableList.class, "Amp_Degrau").getItem(n).put("color", c);
}

void Modelo_motor(int n) {
  /* request the selected item based on index n */
  //println(n,cp5.get(ScrollableList.class, "Modelo_motor").getItem(n));
  //println(n,cp5.get(ScrollableList.class, "Modelo_motor").getItem(n).get("text"));
  
  //List list_mot=cp5.get(ScrollableList.class, "Modelo_motor").getItems();
  mod_mot=cp5.get(ScrollableList.class, "Modelo_motor").getItem(n).get("text").toString();
  filename=mod_mot+"_"+sent_rot+"_"+amp_step+"_"+num_test+".txt";
  cp5.get(Textfield.class,"nome do arquivo").setText(filename);
  CColor c = new CColor();
  c.setBackground(color(255,0,0));
  cp5.get(ScrollableList.class, "Modelo_motor").getItem(n).put("color", c);
}




byte[] inBuffer = new byte[102]; // holds serial message
int i = 0; // loop variable
void draw() {
  
  
  /* Read serial and update values */
  
  
  if (mockupSerial || serialPort.available() > 0) {
    
    if(conection==true){
    myTextarea.setText(" Interface Grafica inicializada, conexao com o microcontrolador completa."
                       +"\n Aguardando comandos.");
    conection=false;
    cp5.get(Button.class,"laa").setImage(loadImage("images/laablue.png"));
    }
    
    String myString = "";
    
    if (!mockupSerial) {
      try {
        serialPort.readBytesUntil('\r', inBuffer);
      }
      catch (Exception e) {
      }
      myString = new String(inBuffer);
    }
    else {
      myString = mockupSerialFunction(start);
    }
  
   
   // split the string at delimiter (space)
   String[] nums = split(myString, '\t');
   
   //String[] nums1= split(myString, '\r');
   if(start==true){
     output.print(nums[0]+"\t"+nums[1]+"\t"+nums[2]+"\t"+nums[3]+"\t"+nums[4]);
    }
    println(myString);
    cp5.get(Textlabel.class,"Tsam").setText(nums[6].toString()+"[sec]");
    cp5.get(Textlabel.class,"Step1").setText(nf(float(nums[9])*float(nums[6]),0,2)+"[sec]");
    cp5.get(Textlabel.class,"Step2").setText(nf(float(nums[10])*float(nums[6]),0,2)+"[sec]");
    cp5.get(Textlabel.class,"stopT").setText(nf(float(nums[12])*float(nums[6]),0,2)+"[sec]");
    cp5.get(Textlabel.class,"stepAmp").setText(nf(map(float(nums[13]), 1000, 2000, 0, 100),0,2)+"[%]");
    cp5.get(Textlabel.class,"rndSeed").setText(nums[14]);
    
    
    if(float(nums[5])==1.0){
     start=false;
     output.close(); // Finishes the file
     cp5.get(Button.class,"laa").setImage(loadImage("images/laagreen.png"));
     cp5.get(Bang.class,"Start").show();
     cp5.get(Bang.class,"Restart").hide();
     myTextarea.setText("Teste Finalizado com sucesso!"
                    +"\n Dados salvos no arquivo: "+cp5.get(Textfield.class,"nome do arquivo").getText() );
   }
   //println(myString);
   //if(start==false){
   // println(myString);} 
    // build the arrays for bar charts and line graphs
    for (i=0; i<nums.length; i++) {

      // update line graph
      try {
        if (i<lineGraphValues.length) {
          for (int k=0; k<lineGraphValues[i].length-1; k++) {
            lineGraphValues[i][k] = lineGraphValues[i][k+1];
          }

          lineGraphValues[i][lineGraphValues[i].length-1] = float(nums[i]);
        }
      }
      catch (Exception e) {
      }
    }
  }
  
  //String[] nums = split(myString, TAB);
  // draw the line graphs
  background(44); 
  speed.DrawAxis();
  force.DrawAxis();
  input.DrawAxis();
  //if(start==true){
  for (int i=0;i<6; i++) {
    
    if(i==2){
    input.GraphColor = graphColors[i];
    input.LineGraph(lineGraphSampleNumbers, lineGraphValues[i]);
    }
    
    if(i==3){
    force.GraphColor = graphColors[i];
    force.LineGraph(lineGraphSampleNumbers, lineGraphValues[i]);
    }
    
    if(i==4){
    speed.GraphColor = graphColors[i];
    speed.LineGraph(lineGraphSampleNumbers, lineGraphValues[i]);
    }
  }
  //}
  delay(90);
}

// called each time the chart settings are changed by the user 
void setChartSettings() {


}

// handle gui actions
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Textfield.class) || theEvent.isAssignableFrom(Bang.class)||theEvent.isAssignableFrom(ScrollableList.class)) {
    String parameter = theEvent.getName();
    String value = "";
    if (theEvent.isAssignableFrom(Textfield.class))
      value = theEvent.getStringValue();
    else if (theEvent.isAssignableFrom(Bang.class))
      value = theEvent.getValue()+"";
    else if (theEvent.isAssignableFrom(ScrollableList.class))
      value = theEvent.getValue()+"";

    testConfigJSON.setString(parameter, value);
    saveJSONObject(testConfigJSON, topSketchPath+"/test_config.json");
    if (!mockupSerial) {
        serialPort.write("set"+parameter+" "+value+";");
        serialPort.clear();
      }
      print("set"+parameter+" "+value+";\n");
    if(theEvent.isAssignableFrom(Textfield.class)) {
    println("controlEvent: accessing a string from controller '"
            +theEvent.getName()+"': "
            +theEvent.getStringValue()
            );
    }
  }
  setChartSettings();
}

// get gui settings from settings file
String getTestConfigString(String id) {
  String r = "";
  try {
    r = testConfigJSON.getString(id);
  } 
  catch (Exception e) {
    r = "";
  }
  return r;
}
