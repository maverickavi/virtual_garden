class pathfinder {
  PVector lastLocation;
  PVector location;
  PVector velocity;
  float diameter;
  boolean isFinished;
  pathfinder() {
    location = new PVector(width/2, height - 198);
    lastLocation = new PVector(location.x, location.y);
    velocity = new PVector(0, 10);
    diameter = 6;
    isFinished = false;
  }
  pathfinder(pathfinder parent) {
    location = parent.location.get();
    lastLocation = parent.lastLocation.get();
    velocity = parent.velocity.get();
    diameter = parent.diameter * 0.62;
    isFinished = parent.isFinished;
    parent.diameter = diameter;
  }
  void update() {
     
    if(location.x > -10 && location.x < width + 10 && location.y > -10 && location.y < height + 10) {
      lastLocation.set(location.x, location.y);
      if (diameter > 0.2) {
        count1 ++;
        PVector bump = new PVector(random(-1, 1), random(-1, 1));
        velocity.normalize();
        bump.mult(0.2);
        velocity.mult(0.8);
        velocity.add(bump);
        velocity.mult(random(5, 10));
        location.add(velocity);
        if (random(0, 1) < 0.2) { // control length
          paths = (pathfinder[]) append(paths, new pathfinder(this));
        }
      } else {
        if(!isFinished) {
          isFinished = true;
          noStroke();
          
        }
      }
    }
  }
}

