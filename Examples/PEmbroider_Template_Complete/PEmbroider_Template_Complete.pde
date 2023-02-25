import processing.embroider.*;

PEmbroiderGraphics E;
public void setup() {
  size(700,700);
  //Initialize file
  noLoop(); 
  
  //File setup info
  E = new PEmbroiderGraphics(this, width, height);
  String outputFilePath = sketchPath("Example_Demo.pes");
  E.setPath(outputFilePath);
  
  //Starts Drawing
  E.beginDraw(); 
  E.clear();
  
  //-------Your code here-----------------
  
  E.strokeWeight(10);
  E.stroke(0,0,255);
  // red,green,blue
  E.strokeMode(E.TANGENT);
  E.rect(50,50,100,300);
  
  //E.noStroke();
  E.strokeWeight(15);
  E.fill(0,255,0);
  E.hatchMode(E.PERLIN);
  E.circle(350,350,200);
  
  
  
  //-------File saving & preview-----------
  
  E.optimize(); // slow but good and important
  E.visualize(true,true,true); 
  //Color, Needle-downs, Connecting Lines
  E.endDraw(); // write out the file
  save("Example_Demo.png");
}
