import processing.embroider.*;

PEmbroiderGraphics E;
public void setup() {
  size(560,610);
  //Initialize file
  noLoop(); 
  
  //File setup info
  E = new PEmbroiderGraphics(this, width, height);
  String outputFilePath = sketchPath("File_Name.vp3");
  E.setPath(outputFilePath);
  
  //Starts Drawing
  E.beginDraw(); 
  E.clear();
  
  //-------Your code here-----------------
  

  //-------Draws Rectangle Border---------
  
  E.strokeLocation(E.INSIDE);   // stroke is completely inset within the shape
  E.strokeMode(E.PERPENDICULAR);
  E.setStitch(5,30,0);
  E.strokeWeight(30); 
  E.strokeSpacing(2);
  E.rect(5, 5, 550,600);
  
  //-------File saving & preview-----------
  
  //E.optimize(); // slow but good and important
  E.visualize(true, true, true); 
  //E.endDraw(); // write out the file
  //save("File_Name.png"); //outputs a screenshot
}
