import processing.serial.*;
import controlP5.*;

/*
 * v0.7 2016 Jul. 28
 *   - add buttons and Y axis labels for series 3 and 4
 *   - loop with series in graph_setup()
 *   - use nameEnlargeButtons[] to name the enlarge buttons
 *   - use btnXs[] instead of [btnX1],[btnX2]
 *   - display ymin and ymax labes for series 1 and 2
 *   - add drawAxisLabels()
 * v0.6 2016 Jul. 28
 *   - move cls[] from local to file scope static as lineColors[]
 *   - loop with series index in drawGraph()
 *   - use cls[] for series line colors
 *   - use biasCoeffs[] instead of [bias1],[bias2]
 *   - use multiCoeffs[] instead of [multi1],[multi2]
 * v0.5 2016 Jul. 28
 *   - use [di] to store temporary index value
 *   - use String[] items to store parsed data items
 * v0.4 2016 Jul. 27
 *   - use for loop for parsing received data string for serieses
 *   - use numSeriesData[] instead of [numSeries1],[numSeries2]
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

float grOriginalYMax = 100.0;
float grOriginalYMin = 0.0;

final int maxnumData = 300;
final int maxnumSeries = 4;
float[][] datamatrix = new float [maxnumSeries][maxnumData];
int numSeriesData[] = new int [maxnumSeries];
float multiCoeffs[] = new float [maxnumSeries];
float biasCoeffs[] = new float [maxnumSeries];

color lineColors[] = new color [maxnumData];

// for series1
ControlP5 btnEnlarge1;
ControlP5 btnShrink1;
ControlP5 btnUpper1;
ControlP5 btnLower1;
// for series2
ControlP5 btnEnlarge2;
ControlP5 btnShrink2;
ControlP5 btnUpper2;
ControlP5 btnLower2;

int btnXs[] = { 20, 65, 720, 765 };

void data_setup() {
   //for(int idx=0; idx < maxnumData; idx++) {
   //  datamatrix[0][idx] = random(100);
   //}
   //for(int idx=0; idx < maxnumData; idx++) {
   //  datamatrix[1][idx] = random(100);
   //}
   
   for(int idx=0; idx < maxnumSeries; idx++) {
     numSeriesData[idx] = 0;   
   }
   for(int idx=0; idx < maxnumSeries; idx++) {
     multiCoeffs[idx] = 1.0;
   }
   for(int idx=0; idx < maxnumSeries; idx++) {   
     biasCoeffs[idx] = 0.0;
   }
}

final String nameEnlargeButtons[] = { "enlarge1", "enlarge2", "enlarge3", "enlarge4" };
final String nameShrinkButtons[] = { "shrink1", "shrink2", "shrink3", "shrink4" };
final String nameUpperButtons[] = { "upper1", "upper2", "upper3", "upper4" };
final String nameLowerButtons[] = { "lower1", "lower2", "lower3", "lower4" };

void graph_setup() {
  lineColors[0] = color(0, 0, 0);
  lineColors[1] = color(255, 0, 0);
  lineColors[2] = color(0, 0, 255);
  lineColors[3] = color(0, 255, 0);
  
  for(int si=0; si < maxnumSeries; si ++) { // si: series index
    btnEnlarge1 = new ControlP5(this);
    btnEnlarge1.addButton(nameEnlargeButtons[si])
      .setLabel("*")
      .setPosition(btnXs[si], 150)
      .setSize(20,20);
  
    btnEnlarge1 = new ControlP5(this);
    btnEnlarge1.addButton(nameShrinkButtons[si])
      .setLabel("/")
      .setPosition(btnXs[si], 180)
      .setSize(20,20);
  
    btnUpper1 = new ControlP5(this);
    btnUpper1.addButton(nameUpperButtons[si])
      .setLabel("+")
      .setPosition(btnXs[si], 350)
      .setSize(20,20);   
  
    btnLower1 = new ControlP5(this);
    btnLower1.addButton(nameLowerButtons[si])
      .setLabel("-")
      .setPosition(btnXs[si], 380)
      .setSize(20,20);
  }
  
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
  multiCoeffs[0] *= 2.0;
}
void shrink1() {
  multiCoeffs[0] *= 0.5; 
}
void upper1() {
  biasCoeffs[0] += 10;
}  
void lower1() {
  biasCoeffs[0] -= 10;
}

void enlarge2() {
  multiCoeffs[1] *= 2.0;
}
void shrink2() {
  multiCoeffs[1] *= 0.5; 
}
void upper2() {
  biasCoeffs[1] += 10;
}  
void lower2() {
  biasCoeffs[1] -= 10;
}

void enlarge3() {
  multiCoeffs[2] *= 2.0;
}
void shrink3() {
  multiCoeffs[2] *= 0.5; 
}
void upper3() {
  biasCoeffs[2] += 10;
}  
void lower3() {
  biasCoeffs[2] -= 10;
}

void enlarge4() {
  multiCoeffs[3] *= 2.0;
}
void shrink4() {
  multiCoeffs[3] *= 0.5; 
}
void upper4() {
  biasCoeffs[3] += 10;
}  
void lower4() {
  biasCoeffs[3] -= 10;
}

void serialEvent(Serial myPort) {
  String mystr = myPort.readStringUntil('\n');
  mystr = trim(mystr);
  println(mystr);
    
  String[] items = mystr.split("\\s+");
  int num = Math.min(items.length, maxnumSeries);
  for(int si = 0; si < num; si++) { // si: series index
    String wrk = items[si];
    if (wrk.length() > 0) {
      int di = numSeriesData[si]++;
      datamatrix[si][di] = float(wrk);
    }
  }
}

void drawGraph() {
  stroke(0, 0, 0);
  fill(255);
  rect(grstartx, grstarty, grwidth, grheight);

  float work;
  
  for(int si = 0; si < maxnumSeries; si++) { // si: series index
    stroke(lineColors[si]);
    for(int di_st1=1; di_st1 < numSeriesData[si]; di_st1++) { // di: data index
      int di = di_st1 - 1;
      
      float stx = map(di, 0, maxnumData, grstartx, grstartx + grwidth);
      work = datamatrix[si][di] * multiCoeffs[si] + biasCoeffs[si];
      float sty = map(work, 0, 100, grheight + grstarty, grstarty);
      
      float etx = map(di_st1, 0, maxnumData, grstartx, grstartx + grwidth);
      work = datamatrix[si][di_st1] * multiCoeffs[si] + biasCoeffs[si];
      float ety = map(work, 0, 100, grheight + grstarty, grstarty);
      
      line(stx, sty, etx, ety);
    }
  }
}

void drawAxisLabels() {
   final int shiftX = -10;   

   for (int si=0; si < maxnumSeries; si++) { // si: series index
     float ymn, ymx;
     String msg;

     ymx = (grOriginalYMax - biasCoeffs[si]) / multiCoeffs[si];   
     msg = String.format("%.3f", ymx);
     textAlign(RIGHT);
     text(msg, btnXs[si] + shiftX, grstarty - 10, 40, 40);
     
     ymn = (grOriginalYMin - biasCoeffs[si]) / multiCoeffs[si];   
     msg = String.format("%.3f", ymn);
     textAlign(RIGHT);
     text(msg, btnXs[si] + shiftX, grstarty + grheight - 10, 40, 40);   
   }
}

void draw() {
  background(150);
  drawGraph();
  drawAxisLabels();
}