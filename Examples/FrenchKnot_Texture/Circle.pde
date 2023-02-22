class Circle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  boolean set = false;

  float diameter;
  Circle(float x, float y, float diam, PVector initVel) {
    acceleration = new PVector(0, 0);
    velocity = initVel;//PVector.random2D();
    position = new PVector(x, y);
    diameter = diam;
  }

  Circle(float x, float y, float diam) {
    acceleration = new PVector(0, 0);
    velocity = PVector.random2D().mult(6);
    position = new PVector(x, y);
    diameter = diam;
  }
  
  Circle(float x, float y, float diam, boolean setVal) {
    acceleration = new PVector(0, 0);
    velocity = PVector.random2D().mult(6);
    position = new PVector(x, y);
    set = setVal;
    diameter = diam;
  }

  void applyForce(PVector force) {
    if (!set) {
      acceleration.add(force);
    }
  }

  void update() {
    if (!set) {
      velocity.add(acceleration);
      position.add(velocity);
      acceleration.mult(0);
    }
  }
  void display() {
    circle(position.x, position.y, diameter);
  }
}
