// Doodle recorder for the PEmbroider library for Processing!
// Press 's' to save the embroidery file. Press space to clear.
// This is the code from examples/PEmbroider_interactive_demo_2

import processing.embroider.*;
PEmbroiderGraphics E;

ArrayList<PVector> currentMark;
ArrayList<ArrayList<PVector>> marks;

//===================================================
void setup() { 
  size (610, 610);
  E = new PEmbroiderGraphics(this, width, height);
  String outputFilePath = sketchPath("patch_freehand_draw.pes");
  E.setPath(outputFilePath);

  currentMark = new ArrayList<PVector>();
  marks = new ArrayList<ArrayList<PVector>>();
  
  
}

//===================================================
void draw() {
  
  // Clear the canvas, init the PEmbroiderGraphics
  background(200); 
  E.beginDraw(); 
  E.clear();
  E.noFill(); 

  
  //================FRAMES===================================
  
  // DRAWS FRAME FOR PATCH
  //RECT
  //E.strokeLocation(E.INSIDE);   // stroke is completely inset within the shape
  //E.strokeMode(E.PERPENDICULAR);
  //E.setStitch(5,30,0);
  //E.strokeWeight(30); 
  //E.strokeSpacing(2);
  //E.rect(5, 5, 550,600);
  
  
  //CIRCLE
  E.strokeLocation(E.INSIDE);   // stroke is completely inset within the shape
  E.strokeMode(E.PERPENDICULAR);
  E.strokeWeight(30); 
  E.strokeSpacing(2);
  E.setStitch(5,35,0);
  E.circle(width/2, height/2, 600);
  
  
  
  //===================================================

  // Set some graphics properties
  E.stroke(0, 0, 0); 
  E.strokeWeight(20); 
  E.strokeSpacing(4.0); 
  E.strokeMode(E.TANGENT);  // E.TANGENT or E.PERPENDICULAR
  E.RESAMPLE_MAXTURN = 0.8f; // 
  E.setStitch(10, 40, 0.0);
  

  
  
  // Draw all previous marks
  for (int m=0; m<marks.size(); m++) {
    ArrayList<PVector> mthMark = marks.get(m); 
    E.beginShape(); 
    for (int i=0; i<mthMark.size(); i++) {
      PVector ithPoint = mthMark.get(i); 
      E.vertex (ithPoint.x, ithPoint.y);
    }
    E.endShape();
  }

  // If the mouse is pressed, 
  // add the latest mouse point to current mark,
  // and draw the current mark
  if (mousePressed) {
    currentMark.add(new PVector(mouseX, mouseY));
    
    E.beginShape(); 
    for (int i=0; i<currentMark.size(); i++) {
      PVector ithPoint = currentMark.get(i); 
      E.vertex (ithPoint.x, ithPoint.y);
    }
    E.endShape();
  }

  E.visualize();
}

//===================================================
void mousePressed() {
  // Create a new current mark
  currentMark = new ArrayList<PVector>();
  currentMark.add(new PVector(mouseX, mouseY));
}

//===================================================
void mouseReleased() {
  // Add the current mark to the arrayList of marks
  marks.add(currentMark); 
  E.printStats();
}

//===================================================
void keyPressed() {
  if (key == ' ') {
    currentMark.clear(); 
    marks.clear();
    
  } else if (key == 's' || key == 'S') { // S to save
    E.optimize(); // slow, but very good and important
    E.printStats(); 
    E.endDraw(); // write out the file
    save("patch_freehand_draw.png");
  }
}
