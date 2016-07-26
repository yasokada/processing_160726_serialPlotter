import processing.serial.*;
import controlP5.*;

/*
 * v0.4 2016 Jul. 27
 *   - use datamatrix[][] instead of datavals1[], datavals2[]
 * v0.3 2016 Jul. 27
 *   - use String split() instead of processing split() to parse received data strings
 * v0.2 2016 Jul. 26
 *   - read serial values to graph data
 *   - add [numSeries1] [numSeries2]
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

final int maxnumData = 300;
final int maxnumSeries = 4;
float[][] datamatrix = new float [maxnumSeries][maxnumData];

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
int numSeries1 = 0;
int numSeries2 = 0;

void data_setup() {
   for(int idx=0; idx < maxnumData; idx++) {
     datamatrix[0][idx] = random(100);
   }
   for(int idx=0; idx < maxnumData; idx++) {
     datamatrix[1][idx] = random(100);
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
  size(800, 500);
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

void enlarge1() {
  multi1 *= 2.0;
}
void shrink1() {
  multi1 *= 0.5; 
}
void upper1() {
  bias1 += 10;
}  
void lower1() {
  bias1 -= 10;
}

void enlarge2() {
  multi2 *= 2.0;
}
void shrink2() {
  multi2 *= 0.5; 
}
void upper2() {
  bias2 += 10;
}  
void lower2() {
  bias2 -= 10;
}

void serialEvent(Serial myPort) {
  String mystr = myPort.readStringUntil('\n');
  mystr = trim(mystr);
  println(mystr);
    
  String wrk;
  wrk = mystr.split("\\s+")[0];
  if (wrk.length() > 0) {
    datamatrix[0][numSeries1] = float(wrk);
    numSeries1++;
  }
  wrk = mystr.split("\\s+")[1];
  if (wrk.length() > 0) {
    datamatrix[1][numSeries2] = float(wrk);
    numSeries2++;  
  }
}

void drawGraph() {
  stroke(0, 0, 0);
  fill(255);
  rect(grstartx, grstarty, grwidth, grheight);

  float work;
  stroke(0, 0, 0); // for series1  
  for(int idx=1; idx < numSeries1; idx++) {
    float stx = map(idx-1, 0, maxnumData, grstartx, grstartx + grwidth);
    work = datamatrix[0][idx-1] * multi1 + bias1;
    float sty = map(work, 0, 100, grheight + grstarty, grstarty);
    float etx = map(idx, 0, maxnumData, grstartx, grstartx + grwidth);
    work = datamatrix[0][idx] * multi1 + bias1;
    float ety = map(work, 0, 100, grheight + grstarty, grstarty);
    line(stx, sty, etx, ety);
  }

  stroke(255, 0, 0); // for series2
  for(int idx=1; idx < numSeries2; idx++) {
    float stx = map(idx-1, 0, maxnumData, grstartx, grstartx + grwidth);
    work = datamatrix[1][idx-1] * multi2 + bias2;
    float sty = map(work, 0, 100, grheight + grstarty, grstarty);
    float etx = map(idx, 0, maxnumData, grstartx, grstartx + grwidth);
    work = datamatrix[1][idx] * multi2 + bias2;
    float ety = map(work, 0, 100, grheight + grstarty, grstarty);
    line(stx, sty, etx, ety);
  }
}

void draw() {
  background(150);
  drawGraph();
}