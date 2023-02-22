import processing.embroider.*;
PEmbroiderGraphics E;
PEmbroiderGraphics E2;

// Diff growth Code: http://www.codeplastic.com/2017/07/22/differential-line-growth-with-processing/
// PARAMETERS
float _maxForce = 0.9; // Maximum steering force
float _maxSpeed = 1; // Maximum speed
float _desiredSeparation = 23;
float _separationCohesionRation = 1.001;
float _maxEdgeLen = 5;
ArrayList<DifferentialLine> _diff_lines = new ArrayList<DifferentialLine>();
ArrayList<PVector> mouseClicks = new ArrayList<PVector>();
//DifferentialLine _diff_line2;
//DifferentialLine _diff_line3;

boolean doEndMotion = false;
boolean addEdge = true;

boolean endDraw = false;

ArrayList<Node> setNodes;
ArrayList<ArrayList <Node>> genNodes;

// color management
ArrayList<Integer> colors = new ArrayList<Integer>();
color C = color(0, 0, 0);


//Ref images
PImage image_TEST;

void setup() {
  size(800, 800);
  image_TEST = loadImage("E_TEST.png");
  setNodes = new ArrayList<Node>();
  genNodes = new ArrayList<ArrayList <Node>> ();

  E = new PEmbroiderGraphics(this, width, height);
  E2 = new PEmbroiderGraphics(this, width, height);

  String filePath = sketchPath("dif_coral_"+timeStamp()+".pes");
  E.setPath(filePath);
  E.beginDraw();

  E.toggleResample(true);
  E.setStitch(20, 30, 0);
  E.stroke(180, 0, 0);

  E2.setStitch(4, 6, 0);
  E2.noFill();
  E2.rectMode(CENTER);
  E2.image(image_TEST, (width-image_TEST.width)/2, (height-image_TEST.height)/2);

  if (addEdge) {
    addSetNodes(E2, setNodes);
  }
}



void draw() {
  background(100);

  //// INTRUCTIONS
  pushStyle();
  fill(255);
  int yLoc = 30;
  int xLoc = 20;
  int space = 30;
  text("Click : Drop Differential Growth Loop", xLoc, yLoc);
  yLoc += space;
  text("Space : Capture Embroidery Design", xLoc, yLoc);
  yLoc += space;
  popStyle();


  ///////


  if (!endDraw) {
    E.clear();
    for (DifferentialLine diff_line : _diff_lines) {
      diff_line.run();
      diff_line.render(E);
    }

    if (doSkipFrames) {
      for (int i = 0; i <100; i++) {
        for (DifferentialLine diff_line : _diff_lines) {
          diff_line.run();
        }
      }


      for (DifferentialLine diff_line : _diff_lines) {
        diff_line.render(E);
      }
      doSkipFrames = false;
    }

    pushStyle();
    stroke(255, 0, 0);
    noFill();
    circle(mouseX, mouseY, radSet*2);
    popStyle();

    E.visualize(true, true, true);
    E2.visualize();
  } else {
    E.visualize(true, true, true);
  }



  fill(10);
  stroke(10);
}

// additional control keys
boolean doSkipFrames = false;
float radSet = 20;

void keyPressed() {
  if (key == ' ') {
    println("space");
    endDraw = true;
    E.endDraw();
  }
  if (key == 'f') {
    doSkipFrames = true;
  }
  if (key == 'c') {
    C = color(int(random(0, 255)), int(random(0, 255)), int(random(0, 255)));
    println(red(C), green(C), blue(C));
  }
  if (key == 'w') {
    radSet ++;
  } else if (key == 's') {
    radSet--;
  }
}

void mousePressed() {
  mouseClicks.add(new PVector(mouseX, mouseY));
  _diff_lines.add(addDiffCircle(mouseX, mouseY));
}



DifferentialLine addDiffCircle(float cx, float cy) {
  DifferentialLine _diff_line = new DifferentialLine(_maxForce, _maxSpeed, _desiredSeparation, _separationCohesionRation, _maxEdgeLen, _diff_lines.size());
  colors.add(C);
  float nodesStart = 20;
  float angInc = TWO_PI/nodesStart;
  float radStart = radSet;
  for (float a=0; a<TWO_PI; a+=angInc) {
    float x = cx + cos(a) * radStart;
    float y = cy + sin(a) * radStart;
    _diff_line.addNode(new Node(x, y, _diff_line.maxForce, _diff_line.maxSpeed, _diff_line.desiredSeparation, _diff_line.separationCohesionRation));
  }
  genNodes.add(_diff_line.nodes); // we give genNodes access to the full array list of points here
  return _diff_line;
}




//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


String timeStamp() {
  return "D" + str(day())+"_"+str(hour())+"-"+str(minute())+"-"+str(second());
}

void addSetNodes(PEmbroiderGraphics E, ArrayList<Node> setNodes) {
  for (int i=0; i<E.polylines.size(); i++) {
    for (int j=0; j<E.polylines.get(i).size(); j++) {
      PVector ND = E.polylines.get(i).get(j).copy();
      setNodes.add(new Node(ND.x, ND.y, true));
    }
  }
}

void renderSetNodes() {
  for (int i=0; i<setNodes.size(); i++) {
    PVector p1 = setNodes.get(i).position;
    circle(p1.x, p1.y, 2);
  }
}


void zigLine(PEmbroiderGraphics E, PVector P0, PVector P1, float stWidth, int stDir, float stLen) {
  float stepAmount = int(P1.copy().sub(P0).mag()/stLen);
  println(stepAmount);
  PVector step = P1.copy().sub(P0).div(stepAmount);
  PVector P = P0.copy();
  PVector tan = step.copy().rotate(PI/2).normalize().mult(stWidth);
  E.beginShape();
  int dir=stDir;
  for (int i = 0; i <= stepAmount; i++) {
    E.vertex(P.x+tan.x*dir, P.y+tan.y*dir);
    P.add(step);
    dir *= -1;
  }

  E.endShape();
}

void foldLine(PEmbroiderGraphics E, PVector P0, PVector P1, float stWidth) {
  E.setStitch(10, 15, 0);
  E.line(P0.x, P0.y, P1.x, P1.y);
  E.setStitch(10, 60, 0);
  zigLine(E, P1, P0, stWidth, 1, 20);
  zigLine(E, P0, P1, stWidth, 1, 20);
}









///////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////// NEEDLE DOWN HELPERS ////////////////////////////////////////////////////////////

PVector getND(PEmbroiderGraphics E, int ndIndex) {
  //get the ith needle down
  int n = 0;
  for (int i=0; i<E.polylines.size(); i++) {
    for (int j=0; j<E.polylines.get(i).size(); j++) {
      PVector needleLoc = E.polylines.get(i).get(j).copy();
      if (n >= ndIndex) {
        return needleLoc;
      }
      n++;
    }
  }
  return null; //will return null if the index is outside the needle down list
}

PVector getPolyND(PEmbroiderGraphics E, int ndIndex, int polylineIndex) {
  return E.polylines.get(polylineIndex).get(ndIndex).copy();
}

int polyndLength(PEmbroiderGraphics E, int polylineIndex) {
  return E.polylines.get(polylineIndex).size();
}

int ndLength(PEmbroiderGraphics E) {
  //return the total number of needle downs in the job
  int n = 0;
  for (int i=0; i<E.polylines.size(); i++) {
    n += E.polylines.get(i).size();
  }
  return n;
}

float getndDist(PEmbroiderGraphics E, int i1, int i2) {
  PVector P1 = getND(E, i1);
  PVector P2 = getND(E, i2);
  return P1.sub(P2).mag();
}



void checkStitchDens(PEmbroiderGraphics E) {
  int rows = height/5;
  int cols = width/5;
  float heightOffset = height/rows;
  float widthOffset = width/cols;

  println("Sample size:");
  println(str(widthOffset) + " x " + str(heightOffset));
  int stitchCounters[][] = new int[rows][cols];

  int lenE = ndLength(E);
  PVector pointLoc = new PVector();
  int maxStitches = 0;

  // This loop goes through each point on in E counts how many times the needle down falls within a certain stitch counter
  for (int i = 0; i < lenE; i++) {
    pointLoc = getND(E, i);
    int col = int(pointLoc.x/widthOffset);
    int row = int(pointLoc.y/heightOffset);
    stitchCounters[row][col]++;
  }

  for (int row=0; row < rows; row ++) {
    for (int col=0; col < cols; col++) {
      int r = int(float(stitchCounters[row][col])*10);
      if (maxStitches<stitchCounters[row][col]) {
        maxStitches =stitchCounters[row][col];
      }
      noStroke();
      fill(r, 0, 0);
      rect(col*widthOffset, row*heightOffset, widthOffset, heightOffset);
    }
  }


  for (int i = 0; i < lenE; i++) {
    pointLoc = getND(E, i);
    fill(255);
    stroke(255, 255, 255, 40);
    point(pointLoc.x, pointLoc.y);
  }

  println("Max Stitches:");
  println(maxStitches);
}


void randomStepPolys(PEmbroiderGraphics E, PEmbroiderGraphics E2, int steps) {
  for (int i=0; i<E.polylines.size(); i++) {
    int eLen = polyndLength(E, i);
    println(i);
    //   int i0 = 0%eLen;//int(random(eLen));
    // int i1 = (0+5)%eLen;//int(random(eLen));
    for (int j=0; j<steps; j++) {
      if (j%2 == 0) {
        int i0 = j%(eLen-1);//i1;
        int i1 = (j+8)%(eLen-1);//(i1+10);
        PVector P0 = getPolyND(E, i0, i);
        PVector P1 = getPolyND(E, i1, i);
        E2.line(P0.x, P0.y, P1.x, P1.y);
      } else {
        int i1 = j%(eLen-1);//i1;
        int i0 = (j+8)%(eLen-1);//(i1+10);
        PVector P0 = getPolyND(E, i0, i);
        PVector P1 = getPolyND(E, i1, i);
        E2.line(P0.x, P0.y, P1.x, P1.y);
      }
    }
  }
}



void filterND(PEmbroiderGraphics E, float intRad, float edgRad) {
  PVector center = new PVector(width/2, height/2);
  for (int i=0; i<E.polylines.size(); i++) {
    ArrayList<PVector> collection =  new ArrayList<PVector>();
    for (int j=0; j<E.polylines.get(i).size(); j++) {
      PVector needleLoc0 = E.polylines.get(i).get(j).copy();
      float dist = needleLoc0.sub(center).mag();
      boolean val = abs(dist-edgRad)<1 || (dist<intRad);// this includes all we want to keep (so everything that is on the edge OR is within 300 px of the center)
      if (!val) {
        collection.add(E.polylines.get(i).get(j));
      }
    }
    E.polylines.get(i).removeAll(collection);
  }
}



boolean NDaproxIn (PEmbroiderGraphics E, PVector ND) {
  for (int i=0; i<E.polylines.size(); i++) {
    for (int j=0; j<E.polylines.get(i).size(); j++) {
      PVector needleLoc = E.polylines.get(i).get(j).copy();
      if (needleLoc.sub(ND).mag()<.001) {
        return true;
      }
    }
  }
  return false;
}


////////////////////// END NEEDLE DOWN HELPERS /////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
