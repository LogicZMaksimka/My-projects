

PVector location;
PVector velocity;
PVector acceleration;



void setup(){
  size(1200, 700);
  ellipseMode(CENTER);
  stroke(255);
  noFill();
  location = new PVector(width/2, height/2);
  velocity = new PVector(0, 0);
  acceleration = new PVector(0, 0);
}

void applyForce(PVector f){
  acceleration.add(f);
}

void draw(){
  PVector gravitation = new PVector(0, 0.3);
  PVector wind = new PVector(0.2, 0);
  background(0);
  fill(255);
  acceleration.mult(0);
  if(mousePressed) applyForce(wind);
  applyForce(gravitation);
  velocity.add(acceleration);
  location.add(velocity);
  if((location.x>width)||(location.x<0)) velocity.x *= -1;
  if((location.y>height)||(location.y<0)) velocity.y *= -1;
  ellipse(location.x, location.y, 70, 70);
  
}
