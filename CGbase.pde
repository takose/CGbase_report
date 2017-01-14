import gifAnimation.*;
GifMaker gifMaker;

//make csv
String imgName="icon.jpg";
PImage img;
PImage gray_img;

//lifegame
int [][] cell;
int cellWidth=5;
int cellHeight=5;
int numCellX, numCellY;
int threshold=100;
color strokeClr=255;

int setColor(int posx, int posy) {
  int clr=0;
  color grayColor = gray_img.pixels[posy*(width)+posx];
  clr=(int)red(grayColor);
  return clr;
}

void setup() {
  numCellX = width/cellWidth;
  numCellY = height/cellHeight;
  cell = new int [numCellY+2][numCellX+2];
  for (int i=0; i<numCellY+2; i++) {
    for (int j=0; j<numCellX+2; j++) {
      cell[i][j]=0;
    }
  }
  /*
  gifMaker = new GifMaker(this, "lifegamecolor.gif");
  gifMaker.setDelay(10);
  */
}

void settings(){
  img=loadImage(imgName);
  size(img.width, img.height);
}

void draw() {
  for ( int x=1; x<numCellX+1; x++ ) {
    for ( int y=1; y<numCellY+1; y++ ) {
      fill(img.get(x*cellWidth, y*cellHeight));
      rect((x-1)*cellWidth, (y-1)*cellHeight, cellWidth, cellHeight);
    }
  }
  /*
  gifMaker.addFrame();
  if (frameCount >= 200) {
    gifMaker.finish();
    exit();
  }
  */
}