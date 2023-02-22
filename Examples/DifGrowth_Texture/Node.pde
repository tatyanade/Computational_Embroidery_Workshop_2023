class Node {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float maxForce;
  float maxSpeed;
  float desiredSeparation;
  float separationCohesionRation;
  int lastNoded = 300;

  Node(float x, float y) {
    acceleration = new PVector(0, 0);
    velocity =PVector.random2D();
    position = new PVector(x, y);
  }

  Node(float x, float y, boolean set) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    position = new PVector(x, y);
  }
  Node(float x, float y, float mF, float mS, float dS, float sCr) {
    acceleration = new PVector(0, 0);
    velocity =PVector.random2D();
    position = new PVector(x, y);
    maxSpeed = mF;
    maxForce = mS;
    desiredSeparation = dS;
    separationCohesionRation = sCr;
  }
  void run(ArrayList<Node> nodes) {
    differentiate(nodes);
    update();
  }
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  void differentiate(ArrayList<Node> nodes) {
    PVector separation = new PVector();
    for (int i = 0; i<genNodes.size(); i++) {
      separation.add(separate(genNodes.get(i)));
    }
    separation.add(separate(setNodes));
    PVector cohesion = edgeCohesion(nodes);
    separation.mult(separationCohesionRation);
    applyForce(separation);
    applyForce(cohesion);
  }
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);
    acceleration.mult(0);
  }
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);
    desired.setMag(maxSpeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    return steer;
  }

  void render() {
    fill(0);
    ellipse(position.x, position.y, 2, 2);
  }

  PVector separate(ArrayList<Node> nodes) {
    PVector steer = new PVector(0, 0);
    int count = 0;
    for (Node other : nodes) {
      float d = PVector.dist(position, other.position);
      if (d>0 && d < desiredSeparation) {
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d); // Weight by distance
        steer.add(diff);
        count++;
      }
    }
    if (count>0) {
      steer.div((float)count);
    }
    if (steer.mag() > 0) {
      steer.setMag(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }

  PVector edgeCohesion (ArrayList<Node> nodes) {
    PVector sum = new PVector(0, 0);      
    int this_index = nodes.indexOf(this);
    if (this_index!=0 && this_index!=nodes.size()-1) {
      sum.add(nodes.get(this_index-1).position).add(nodes.get(this_index+1).position);
    } else if (this_index == 0) {
      sum.add(nodes.get(nodes.size()-1).position).add(nodes.get(this_index+1).position);
    } else if (this_index == nodes.size()-1) {
      sum.add(nodes.get(this_index-1).position).add(nodes.get(0).position);
    }
    sum.div(2);
    return seek(sum);
  }
}
