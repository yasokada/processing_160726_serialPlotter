import processing.serial.*;
import controlP5.*;

/*
 * v0.1 2016 Jul. 26
 *   - add serialEvent()
 *   - add ComPort()
 *   - add COM port UI
 */
 
Serial myPort;

ControlP5 cp5;
int curSerial = -1;

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