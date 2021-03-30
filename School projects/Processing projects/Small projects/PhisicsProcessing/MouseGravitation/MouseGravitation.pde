//PVector location;
//PVector velocity;

class CreateObject{
  PVector location;
  PVector velocity;
  float g;
public
  CreateObject(float gravity){
    location = new PVector(width/2, height/2);
    velocity = new PVector(0, 0);
    g = gravity;
  }
  void walls(){
    if((location.x>width)||(location.x<0)) velocity.x *= -0.0;
    if((location.y>height)||(location.y<0)) velocity.y *= -0.0;
  }
  void update(){
    PVector acceleration = new PVector(mouseX, mouseY);
    acceleration.sub(location);
    acceleration.setMag(g);
    velocity.add(acceleration);
    //velocity.limit(20);
    location.add(velocity);
  }
  float getX(){
    return location.x;
  }
  float getY(){
    return location.y;
  }
}

void setup(){
  size(1200, 700);
  ellipseMode(CENTER);
  stroke(255);
  noFill();
  //location = new PVector(width/2, height/2);
  //velocity = new PVector(0, 0);
}

CreateObject ball1 = new CreateObject(1.5);
CreateObject ball2 = new CreateObject(0);

void draw(){
  background(0);
  
  /*PVector acceleration = new PVector(mouseX, mouseY);
  acceleration.sub(location);
  acceleration.normalize();
  acceleration.mult(2);
  velocity.add(acceleration);
  location.add(velocity);
  if((location.x>width)||(location.x<0)) velocity.x *= -0.95;
  if((location.y>height)||(location.y<0)) velocity.y *= -0.95;
  ellipse(location.x, location.y, 70, 70);*/
  
  fill(0,255,0);
  ball1.walls();
  ball1.update();
  ellipse(ball1.location.x, ball1.location.y, 60, 60);
  //fill(255,0,0);
  //ball2.walls();
  //ball2.update();
  //ellipse(ball2.location.x, ball2.location.y, 60, 60);
}
