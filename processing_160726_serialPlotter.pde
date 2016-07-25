import processing.serial.*;
import controlP5.*;

/*
 * v0.2 2016 Jul. 26
 *   - add graph drawing feature
 * v0.1 2016 Jul. 26
 *   - add serialEvent()
 *   - add ComPort()
 *   - add COM port UI
 */
 
Serial myPort;

ControlP5 cp5;
int curSerial = -1;

int grstartx = 100;
int grstarty = 100;
int grwidth = 600;
int grheight = 350;

int numData = 300;
float[] datavals1 = new float [numData];
float[] datavals2 = new float [numData];

// for series1
ControlP5 btnEnlarge1;
ControlP5 btnShrink1;
ControlP5 btnUpper1;
ControlP5 btnLower1;
float multi1 = 1.0;
float bias1 = 0.0;
// for series2
ControlP5 btnEnlarge2;
ControlP5 btnShrink2;
ControlP5 btnUpper2;
ControlP5 btnLower2;
float multi2 = 1.0;
float bias2 = 0.0;

int btnX1 = 40;
int btnX2 = 70;

void data_setup() {
   for(int idx=0; idx < numData; idx++) {
     datavals1[idx] = random(100);
   }
   for(int idx=0; idx < numData; idx++) {
     datavals2[idx] = random(100);
   }
}

void graph_setup() {
  // for series1
  btnEnlarge1 = new ControlP5(this);
  btnEnlarge1.addButton("enlarge1")
    .setLabel("*")
    .setPosition(btnX1, 150)
    .setSize(20,20);

  btnEnlarge1 = new ControlP5(this);
  btnEnlarge1.addButton("shrink1")
    .setLabel("/")
    .setPosition(btnX1, 180)
    .setSize(20,20);

  btnUpper1 = new ControlP5(this);
  btnUpper1.addButton("upper1")
    .setLabel("+")
    .setPosition(btnX1, 350)
    .setSize(20,20);   

  btnLower1 = new ControlP5(this);
  btnLower1.addButton("lower1")
    .setLabel("-")
    .setPosition(btnX1, 380)
    .setSize(20,20);

  // for series2
  btnEnlarge2 = new ControlP5(this);
  btnEnlarge2.addButton("enlarge2")
    .setLabel("*")
    .setPosition(btnX2, 150)
    .setSize(20,20);

  btnEnlarge2 = new ControlP5(this);
  btnEnlarge2.addButton("shrink2")
    .setLabel("/")
    .setPosition(btnX2, 180)
    .setSize(20,20);

  btnUpper2 = new ControlP5(this);
  btnUpper2.addButton("upper2")
    .setLabel("+")
    .setPosition(btnX2, 350)
    .setSize(20,20);   

  btnLower2 = new ControlP5(this);
  btnLower2.addButton("lower2")
    .setLabel("-")
    .setPosition(btnX2, 380)
    .setSize(20,20);
}

void comUI_setup() {
  cp5.addScrollableList("ComPort")
     .setPosition(30, 30)
     .setSize(200, 100)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(Serial.list());
}

void setup() {
  size(500, 500);
  frameRate(10);
  data_setup();
  graph_setup();

  cp5 = new ControlP5(this);
  
  comUI_setup();
}

void ComPort(int n)
{
  println(n); 
  curSerial = n;
  if (myPort != null) {
     myPort.stop(); 
     myPort = null;
  }
  myPort = new Serial(this, Serial.list()[curSerial], 9600);
  myPort.bufferUntil('\n');  
}

void serialEvent(Serial myPort) {
  String mystr = myPort.readStringUntil('\n');
  mystr = trim(mystr);
  println(mystr);
}

void draw() {
  background(0);
  
}