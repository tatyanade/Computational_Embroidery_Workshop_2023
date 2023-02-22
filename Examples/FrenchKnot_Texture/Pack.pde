class Pack {
  ArrayList<Circle> circles = new ArrayList<Circle>();
  float max_speed = 1;
  float max_force = 1;
  
  Pack(){
  }
  
  Pack(int numCircles, float minRad, float maxRad) {
    initiate(numCircles, minRad, maxRad);
  }
  
  void initiate(int numCircles, float minRad, float maxRad) {
    int circlesAmount = numCircles ;
    for (int i = 0; i < circlesAmount; i++) {
      addCircle(new Circle(width/2, height/2, random(minRad, maxRad)));
    }
  }


  void addCircle(Circle b) {
    circles.add(b);
  }

  void addSetAlongPoly() {

    float rad = 200;
    for (float i = 0; i < 2*PI; i+= 2*PI/200) {
      float x = rad*cos(i)+width/2;
      float y = rad*sin(i)+height/2;
      circles.add(new Circle(x, y, 5, true));
    }
  }

  void addSetAlongPoly(PEmbroiderGraphics E) {
    float rad = 200;
    for (ArrayList<PVector> poly : E.polylines) {
      for (PVector P : poly) {
        float x = P.x;
        float y = P.y;
        circles.add(new Circle(x, y, 5, true));
      }
    }
  }

  void run() {
    PVector[] separate_forces = new PVector[circles.size()];
    int[] near_circles = new int[circles.size()];
    for (int i=0; i<circles.size(); i++) {
      checkBorders(i);
      checkCirclePosition(i);
      applySeparationForcesToCircle(i, separate_forces, near_circles);
      displayCircle(i);
    }
  }
  void checkBorders(int i) {
    Circle circle_i=circles.get(i);
    if (circle_i.position.x-circle_i.diameter/2 < 0 || circle_i.position.x+circle_i.diameter/2 > width)
    {
      circle_i.velocity.x*=-1;
      circle_i.update();
    }
    if (circle_i.position.y-circle_i.diameter/2 < 0 || circle_i.position.y+circle_i.diameter/2 > height)
    {
      circle_i.velocity.y*=-1;
      circle_i.update();
    }
  }
  void checkCirclePosition(int i) {
    Circle circle_i=circles.get(i);
    for (int j=i+1; j<=circles.size(); j++) {
      Circle circle_j = circles.get(j == circles.size() ? 0 : j);
      int count = 0;
      float d = PVector.dist(circle_i.position, circle_j.position);
      if (d < circle_i.diameter/2+circle_j.diameter/2) {
        count++;
      }
      // Zero velocity if no neighbours
      if (count == 0) {
        circle_i.velocity.x = 0.0;
        circle_i.velocity.y = 0.0;
      }
    }
  }
  void applySeparationForcesToCircle(int i, PVector[] separate_forces, int[] near_circles) {
    if (separate_forces[i]==null)
      separate_forces[i]=new PVector();
    Circle circle_i=circles.get(i);
    for (int j=i+1; j<circles.size(); j++) {
      if (separate_forces[j] == null)
        separate_forces[j]=new PVector();
      Circle circle_j=circles.get(j);
      PVector forceij = getSeparationForce(circle_i, circle_j);
      if (forceij.mag()>0) {
        separate_forces[i].add(forceij);
        separate_forces[j].sub(forceij);
        near_circles[i]++;
        near_circles[j]++;
      }
    }
    if (near_circles[i]>0) {
      separate_forces[i].div((float)near_circles[i]);
    }
    if (separate_forces[i].mag() >0) {
      separate_forces[i].setMag(max_speed);
      separate_forces[i].sub(circles.get(i).velocity);
      separate_forces[i].limit(max_force);
    }
    PVector separation = separate_forces[i];
    circles.get(i).applyForce(separation);
    circles.get(i).update();
  }
  PVector getSeparationForce(Circle n1, Circle n2) {
    PVector steer = new PVector(0, 0, 0);
    float d = PVector.dist(n1.position, n2.position);
    if ((d > 0) && (d < n1.diameter/2+n2.diameter/2)) {
      PVector diff = PVector.sub(n1.position, n2.position);
      diff.normalize();
      diff.div(d);
      steer.add(diff);
    }
    return steer;
  }
  void displayCircle(int i) {
    circles.get(i).display();
  }
}
