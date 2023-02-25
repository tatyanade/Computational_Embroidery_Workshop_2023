import processing.embroider.*;

PEmbroiderGraphics E;
public void setup() {
  size(610,610);
  //Initialize file
  noLoop(); 
  
  //File setup info
  E = new PEmbroiderGraphics(this, width, height);
  String outputFilePath = sketchPath("file_name.pes");
  E.setPath(outputFilePath);
  
  //Starts Drawing
  E.beginDraw(); 
  E.clear();
  
  //-------Your code here-----------------

  
  
  
  
  //-------Draws Cirlce Border------------

  E.strokeLocation(E.INSIDE);   // stroke is completely inset within the shape
  E.strokeMode(E.PERPENDICULAR);
  E.strokeWeight(30); 
  E.strokeSpacing(2);
  E.setStitch(5,35,0);
  E.circle(width/2, height/2, 600);
  
  //-------File saving & preview-----------
  
  //E.optimize(); // slow but good and important
  E.visualize(true, true, true); 
  //E.endDraw(); // write out the file
  //save("file_name.png");  //outputs a screenshot
}
