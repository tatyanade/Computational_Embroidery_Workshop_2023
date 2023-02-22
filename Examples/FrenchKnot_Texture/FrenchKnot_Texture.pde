/// Basic PEmbroidery Setup
import processing.embroider.*;
String fileType = ".pes";
String fileName = "mossyConcentricStitching"; // CHANGE ME
PEmbroiderGraphics E;
PEmbroiderGraphics E2;
int frames = 0;

PImage image;

boolean running = true;
boolean debugging = false;

int yLoc = 60;
int space = 30;
int xLoc = 20;

Pack p;

void setup() {
  size(800, 800); //100 px = 1 cm (so 14.2 cm is 1420px)
  PEmbroiderStart();
  E2 = new PEmbroiderGraphics(this, width, height);
  image = loadImage("E_TEST.png");
  p = new Pack();
  E2.image(image, (width-image.width)/2, (height-image.height)/2);
  p.addSetAlongPoly(E2);
}


void draw() {
  if (running) {
    background(100);
    p.run();
    
    //// INTRUCTIONS
    pushStyle();
    fill(255);
    yLoc = 60;
    text("'R' : Toggle Random Sizing",xLoc,yLoc);
    yLoc += space;
    text(" Up/Down Arrows : Change Knot Sizing",xLoc,yLoc);
    yLoc += space;
    text(" Space : Generate Embroidery Design",xLoc,yLoc);
    yLoc += space;
    popStyle();
    
    
    ///////
    
    
    
    if (!randomRadius) {
      pushStyle();
      stroke(255, 0, 0);
      noFill();
      circle(mouseX, mouseY, diameter);
      fill(255);
      text("Random Size: OFF",xLoc,30);
      popStyle();
    } else {
      pushStyle();
      noStroke();
      fill(255, 0, 0);
      circle(mouseX, mouseY, 10);
      fill(255);
      text("Random Size: ON",xLoc,30);
      popStyle();
      
    }
  } else {
  background(100);
  int visualInput = int(map(mouseX, 0, width, 0, ndLength(E)));
  E.visualize(true, true, true, visualInput);
  }
}

float maxDiam = 45;
float minDiam = 16;
boolean randomRadius = true;
int diameter = 40;

void mousePressed() {
  float diam = 0;
  if (randomRadius) {
    diam = random(minDiam, maxDiam);
  } else {
    diam = diameter;
  }
  p.circles.add(new Circle(mouseX, mouseY, diam));
}



int waitVal = 0;
void mouseDragged() {
  float diam = 0;
  if (randomRadius) {
    diam = random(minDiam, maxDiam);
  } else {
    diam = diameter;
  }
  
  if (waitVal == 0) {
    p.circles.add(new Circle(mouseX, mouseY, diam));
    waitVal = 5;
  } else if (waitVal > 0) {
    waitVal--;
  }
}


void keyPressed() {
  if (key == ' ') {
    running = false;
    for (int i=0; i<p.circles.size(); i++) {
      Circle circ = p.circles.get(i);
      if (!circ.set) {
        drawKnot1(E, circ.diameter/2, circ.position.x, circ.position.y);
      }
    }
    PEmbroiderWrite(E, "frenchKnottyBits");
  }
  if (key == 'r') {
    if (randomRadius) {
      randomRadius = false;
    } else {
      randomRadius = true;
    }
  }
  if (key == CODED) {
    if (keyCode == UP) {
      diameter+=2;
    } else if (keyCode == DOWN) {
      if (diameter > 15) {
        diameter-=2;
      }
    }
  }
}


//////// run these at begginning and end of setup ////////////////////////////////////

void PEmbroiderStart() {
  E = new PEmbroiderGraphics(this, width, height);
  String outputFilePath = sketchPath(fileName+fileType);
  E.setPath(outputFilePath);
  E.setStitch(8, 14, .1);
}

void PEmbroiderWrite(PEmbroiderGraphics E, String fileName) {
  String outputFilePath = sketchPath(fileName+timeStamp()+fileType);
  E.setPath(outputFilePath);
  E.endDraw(); // write out the file
}

String timeStamp() {
  return "D" + str(day())+"_"+str(hour())+"-"+str(minute())+"-"+str(second());
}

///////////////////////////////////////////////////////////////////////////////////////




/// Knot Functions

void drawKnot1(PEmbroiderGraphics E, float rad, float x, float y) {
  E.pushMatrix();
  E.translate(x, y);
  E.setStitch(4, 400, 0);

    drawStarKnot(E, int(rad-8*2));

    drawStarKnot(E, int(rad-8));

  E.rotate(PI/11);
  drawStarKnot(E, int(rad-2.5)); // .85
  E.popMatrix();
}


void drawStarKnot(PEmbroiderGraphics E, int rad) {
  println("/////radius:");
  println(rad*2);
  println("/////////");
  if (rad*2>=10) {
    float arLen = 4;

    float thStep = arLen/rad;

    float thSteps = 0;
    int i = 0;

    float angleDif = PI;

    while (thSteps < PI*1.1) {
      if (i%2==0) {
        connectPointsOnCircle(E, thSteps, thSteps+angleDif, rad);
      } else {
        connectPointsOnCircle(E, thSteps+angleDif, thSteps, rad);
      }
      thSteps += thStep;
      i++;
    }
  }
}


void connectPointsOnCircle(PEmbroiderGraphics E, float th1, float th2, int rad) {
  //th1 & th2 are in radians
  // centered on zero
  int x1 = int(cos(th1)*rad);
  int y1 = int(sin(th1)*rad);
  int x2 = int(cos(th2)*rad);
  int y2 = int(sin(th2)*rad);
  E.line(x1, y1, x2, y2);
}



////////////////////////////Mossy circle2 : no double stitch on inside











void connect2CircleVertex(PEmbroiderGraphics E, float th1, float th2, int rad1, int rad2) {
  // th1 & th2 are in radians
  // centered on zero
  int x1 = int(cos(th1)*rad1);
  int y1 = int(sin(th1)*rad1);
  int x2 = int(cos(th2)*rad2);
  int y2 = int(sin(th2)*rad2);
  E.vertex(x1, y1);
  E.vertex(x2, y2);
}


PVector pol2cart(float r, float theta) {
  int x = int(cos(theta)*r);
  int y = int(sin(theta)*r);
  return new PVector(x, y);
}

PVector getPointOnRadius(float th, int rad) {
  int x = int(cos(th)*rad);
  int y = int(sin(th)*rad);
  return new PVector(x, y);
}


float noiseLoop(float rad, float t, float z) {
  // we translate the center of the cicle so that there are no neg values
  // note: for some reason some symmetry was observed when the circle was centered on 0,0 and the input loop was symmetrical across the x and y axis
  // we assign t so that 0 is beginning of loop; 1 is end of loop
  float val = 0;
  float theta = t*2*PI; // map t to theta
  float x = cos(theta)*rad+rad;
  float y = sin(theta)*rad+rad;
  if (debugging) {
    println("x: "+str(x));
    println("y: "+str(y));
    pushMatrix();
    translate(width/2, height/2);
    circle(x*100, y*100, 5);
    popMatrix();
  }
  return noise(x, y, z);
}




//////////////////////////////////////////////////////////////////////////////


int ndLength(PEmbroiderGraphics E) {
  //return the total number of needle downs in the job
  int n = 0;
  for (int i=0; i<E.polylines.size(); i++) {
    n += E.polylines.get(i).size();
  }
  return n;
}
