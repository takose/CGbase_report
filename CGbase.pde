import com.leapmotion.leap.Gesture.State;
import com.leapmotion.leap.Gesture.Type;
import com.leapmotion.leap.SwipeGesture;
import com.onformative.leap.LeapMotionP5;

import gifAnimation.*;

GifMaker gifMaker;
LeapMotionP5 leap;

String imgName = "img1.jpg";
PImage img;
int fineness = 20;
int rangeThreshold = 5;
ArrayList<ColorMap> colors = new ArrayList<ColorMap>();

float camAngle = 0;
float camRadius = 1200;
float camSpeed = 3.0;

class ColorMap {
  color clr;
  float posTheta, posRadius, posHigh;
  int size;
  ColorMap(color c) {
    posTheta = radians(map(hue(c), 0, 255, 0, 360));
    posRadius = map(saturation(c), 0, 255, -width, width);
    posHigh = map(brightness(c), 0, 255, 0, width);
    size = 15;
    clr = color(c);
  }
  
  void draw(){
    pushMatrix();
    rotateY(this.posTheta);
    fill(this.clr, 180);
    translate(this.posHigh, this.posRadius, 0);
    sphere(this.size);
    popMatrix();
  }
  
  float range(color c) {
    return dist(hue(this.clr), saturation(this.clr), brightness(this.clr), hue(c), saturation(c), brightness(c));
  }
}

void makeColorMap() {
  for (int x=0; x<img.width/fineness; x++) {
    for (int y=0; y<img.height/fineness; y++) {
      color dot = img.get(x*fineness, y*fineness);
      if (colors.size() <= 0) {
        colors.add(new ColorMap(dot));
      }
      boolean flg=false;
      for (ColorMap c : colors) {
        if (c.range(dot) < rangeThreshold) {
          c.size+=10;
          flg = true;
          break;
        }
      }
      if (!flg)colors.add(new ColorMap(dot));
    }
  }
}



void setup() {
  size(600, 600, P3D);
  colorMode(HSB, 255);
  noStroke();
  img=loadImage(imgName);

  makeColorMap();

  leap = new LeapMotionP5(this);
  leap.enableGesture(Type.TYPE_SWIPE);
  
  gifMaker = new GifMaker(this, "demo.gif");
  gifMaker.setRepeat(0);
  gifMaker.setDelay(20);
}

void draw() {
  background(0);
  camera(cos(radians(camAngle))*camRadius, 0, sin(radians(camAngle))*camRadius, 
    0, 0, 0, 
    0, 1, 0 );
  camAngle+=camSpeed;
  if (camSpeed > 3) camSpeed-=1;

  for (ColorMap c : colors) {
    c.draw();
  }
  if(frameCount <= 50*3){
    gifMaker.addFrame();
  } else {
    gifMaker.finish();
    exit();
  }
}

public void swipeGestureRecognized(SwipeGesture gesture) {
  if (gesture.state() == State.STATE_STOP) camSpeed+=6;
}

void keyPressed() {
  if (keyCode == UP) {
    fineness+=10;
  }
  if (keyCode == DOWN) {
    fineness-=10;
  }
  if (keyCode == RIGHT) {
    rangeThreshold-=10;
  }
  if (keyCode == LEFT) {
    rangeThreshold+=10;
  }
  if (key == 's') {
    camSpeed+=6;
  }
  colors.clear();
  makeColorMap();
}
