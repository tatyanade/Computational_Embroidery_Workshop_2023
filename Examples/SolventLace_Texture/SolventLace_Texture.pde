// TODO: implement a more tunable perlin noise fill using the PEmbroiderGraphics.VECFIELD
import processing.embroider.*;
String fileType = ".pes";
String fileName = "spiral_image"; // CHANGE ME
PEmbroiderGraphics E;

int frame;

PImage img;
PImage img2;
PImage img3;


void setup() {
  size(800, 800); //100 px = 1 cm (so 14.2 cm is 1420px)
  E = new PEmbroiderGraphics(this, width, height);
  frameRate(30);
  img = loadImage("ModifiedP-01.png");
  img2 = loadImage("ModifiedP-02.png");
  img3 = loadImage("ModifiedP-03.png");  
  
  E.stroke(0,255,0);
  E.noFill();
  E.image(img2,0,0);
  
  
  E.hatchMode(E.CROSS);
  E.hatchSpacing(10);
  E.fill(0);
  E.noStroke();
  E.image(img3, 0, 0);
  E.optimize();
  
  E.noFill();
  E.stroke(0);
  renderZigPolyFUNProf(E,img,160);
  PEmbroiderWrite(E,"SolventLaceTexture");
  E.visualize();
}

boolean doAnimate = true;
void draw() {
  if(doAnimate){
    background(180);
    int visualInput = int(map(mouseX, 0, width, 0, ndLength(E)));
    E.visualize(true,true,true,visualInput);
    pushStyle();
    fill(255);
    stroke(255);
    text("move mouse back and forth to step through needle downs", 30,height-30);
    popStyle();
  }
}




void renderZigPolyFUNProf(PEmbroiderGraphics E, PImage img, float stWidth) {
  PEmbroiderGraphics E_ref = new PEmbroiderGraphics(this, width, height);
  E_ref.setStitch(10,15,0);
  E_ref.image(img,0,0);
  E.setStitch(10,20,0);
  int dir = 1;
  for(int i = 0; i < E_ref.polylines.size(); i++){
  for (int k=0; k<E_ref.polylines.get(i).size()-1; k++) {
    PVector p1 = E_ref.polylines.get(i).get(k);
    PVector p2 = E_ref.polylines.get(i).get(k+1);
    PVector tan = p2.copy().sub(p1).normalize();
    tan.rotate(PI/30);
    tan.mult(stWidth/2);
    E.line(p1.x+tan.x*dir, p1.y+tan.y*dir, p1.x+tan.x*dir*-1, p1.y+tan.y*dir*-1);
    dir*= -1;
    }
  }
}

int ndLength(PEmbroiderGraphics E) {
  //return the total number of needle downs in the job
  int n = 0;
  for (int i=0; i<E.polylines.size(); i++) {
    n += E.polylines.get(i).size();
  }
  return n;
}

void PEmbroiderWrite(PEmbroiderGraphics E, String fileName) {
  String outputFilePath = sketchPath(fileName+timeStamp()+fileType);
  E.setPath(outputFilePath);
  E.endDraw(); // write out the file
}

String timeStamp() {
  return "D" + str(day())+"_"+str(hour())+"-"+str(minute())+"-"+str(second());
}
