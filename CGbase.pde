import com.leapmotion.leap.CircleGesture;
import com.leapmotion.leap.Gesture.State;
import com.leapmotion.leap.Gesture.Type;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.KeyTapGesture;
import com.leapmotion.leap.ScreenTapGesture;
import com.leapmotion.leap.SwipeGesture;
import com.onformative.leap.LeapMotionP5;

import gifAnimation.*;
GifMaker gifMaker;
LeapMotionP5 leap;

String imgName="IMG_2180.JPG";
PImage img;

int fineness=50;

float cameraRad=86;
float R = 800;
float camY = 350;
color[][] clr;
float[][] h,s,b;
float speed = 3.0;

void setup() {
  size(600, 600, P3D);
  colorMode(HSB, 255);
  img=loadImage(imgName);
  int xNum = img.width/fineness;
  int yNum = img.height/fineness;
  clr = new color[xNum][yNum];
  h = new float[xNum][yNum];
  s = new float[xNum][yNum];
  b = new float[xNum][yNum];
  for ( int x=0; x<img.width/fineness; x++ ) {
    for ( int y=0; y<img.height/fineness; y++ ) {
      clr[x][y] = img.get(x*fineness, y*fineness);
      h[x][y] = map(hue(clr[x][y]), 0, 255, 0, 360);
      s[x][y] = map(saturation(clr[x][y]), 0, 255, -width/2, width/2);
      b[x][y] = map(brightness(clr[x][y]), 0, 255, 0, width);
    }
  }
  noStroke();
  leap = new LeapMotionP5(this);
  leap.enableGesture(Type.TYPE_SWIPE);
  /*
  gifMaker = new GifMaker(this, "lifegamecolor.gif");
  gifMaker.setDelay(10);
  */
}

void draw() {
  camera(cos(radians(cameraRad))*R, 0, sin(radians(cameraRad))*R,
         0, 0, 0,
         0, 1, 0 );
  background(0);
  strokeWeight(3);
  stroke(#ff0000);
  line(0,0,0,100,0,0);
  stroke(#0000ff);
  line(0,0,0,0,100,0);
  stroke(#00ff00);
  line(0,0,0,0,0,-100);
  noStroke();
  for ( int x=0; x<img.width/fineness; x++ ) {
    for ( int y=0; y<img.height/fineness; y++ ) {
      pushMatrix();
      rotateY(radians(h[x][y]));
      fill(clr[x][y]);
      translate(b[x][y], s[x][y], 0);
      sphere(10);
      popMatrix();
    }
  }
  for (Hand hand : leap.getHandList()) {
    PVector handPos = leap.getPosition(hand);
    ellipse(handPos.x, handPos.y, 20, 20);
  }
  /*
  gifMaker.addFrame();
  if (frameCount >= 200) {
    gifMaker.finish();
    exit();
  }
  */
  println(speed);
  cameraRad+=speed;
  if(speed>3) speed-=0.5;
}
public void swipeGestureRecognized(SwipeGesture gesture) {
  if (gesture.state() == State.STATE_STOP) {
    speed+=6;
  }
}