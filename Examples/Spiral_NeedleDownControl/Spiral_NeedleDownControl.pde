// TODO: implement a more tunable perlin noise fill using the PEmbroiderGraphics.VECFIELD 
import processing.embroider.*;
String fileType = ".pes";
String fileName = "spiral_image"; // CHANGE ME
PEmbroiderGraphics E;

int frame;

 PImage img;



void setup() {
  size(1024, 675); //100 px = 1 cm (so 14.2 cm is 1420px)
  PEmbroiderStart();
  frameRate(30);
  noLoop();
  img = loadImage("pearlEaring.jpg");
  img.loadPixels();
  
  drawBlackAndWhite();
}

void draw() {
  ;
}


void drawBlackAndWhite(){
    background(255);
  E.pushMatrix();
  E.translate(width/2, height/2);
  float theta = 1;
  float stepLen = 3;
  int steps = 10*1000;
  E.stroke(0);
  E.setStitch(40, 40, .1);
  E.beginShape();
  for (int i=1; i<=steps; i++) {
    float r = theta*1.8;
    float thetaStep = stepLen/r;
    PVector coord = radi2card(r+offset(r, theta, i), theta);
    E.vertex(coord.x, coord.y);
    theta+= thetaStep;
  }
  E.endShape();
  E.popMatrix();
 // E.endDraw();
  E.visualize(true,false,false);
  println(maxBrightness);
  E.endDraw();
}



float maxBrightness = 0;

float getPixelBrightness(PImage img, int x, int y){
  int loc = x + y*img.width;
  float b = brightness((img.pixels[loc]));
  if(b>maxBrightness){
    maxBrightness = b;
  }
  return b;    
}

float offset(float r, float theta, int i) {
  PVector coord = radi2card(r,theta).add(new PVector(width/2,height/2));
  float bright = getPixelBrightness(img,int(coord.x),int(coord.y));
  float off = (300-bright)/300*5;
  if (i%2 == 0) {
    return -1*off;
  }
  return off;
}


float offset2(float r, float theta, int i) {
  PVector coord = radi2card(r,theta).add(new PVector(width/2,height/2));
  float bright = getPixelBrightness(img,int(coord.x),int(coord.y));
  float off = bright/255*5;
  if (i%2 == 0) {
    return -1*off;
  }
  return off;
}

void PEmbroiderStart() {
  E = new PEmbroiderGraphics(this, width, height);
  String outputFilePath = sketchPath(fileName+fileType);
  E.setPath(outputFilePath);
  E.setStitch(8, 14, 0);
}




PVector radi2card(float r, float th) {
  PVector card = new PVector(0, r);
  return card.rotate(th);
}
