// Test program for the PEmbroider library for Processing:
// Making a multi-color embroidery 
// based on individually colored .PNGs

import processing.embroider.*;
PEmbroiderGraphics E;
PImage img;

void setup() {
  noLoop(); 
  size (800, 800);

  E = new PEmbroiderGraphics(this, width, height);
  String outputFilePath = sketchPath("png_example.pes");
  E.setPath(outputFilePath); 
  
  // The image should consist of white shapes on a black background. 
  // The ideal image is an exclusively black-and-white .PNG or .GIF.
  img = loadImage("img.png");

  E.beginDraw(); 
  E.clear();

  // Stroke properties
  E.noStroke();

  // Fill properties
  E.hatchSpacing(4.0); 
  E.PARALLEL_RESAMPLING_OFFSET_FACTOR = 0.33;

  //Red fill is semi-sparse concentric
  E.hatchMode(PEmbroiderGraphics.CONCENTRIC); 
  E.setStitch(10, 20, 0);
  E.fill(255, 0, 0);
  E.image(img, 0, 0); 


  //-----------------------
  //E.optimize();   // slow, but good and important

  //setting first vaule true shows colorized preview
  E.visualize(true, false, false);  // 
  // E.printStats(); //
  // E.endDraw();    // write out the file
}


//--------------------------------------------
void draw() {
  ;
}
