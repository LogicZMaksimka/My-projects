
class CreateObject{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float D;
  float restLength;
public
  CreateObject(float length){
    restLength = length;
    mass = 3/*random(1, 2)*/;
    D=mass*20;
    //restLength = random(80, 400);
    location = new PVector(width/2+restLength, 0 /*random(D/2, width-D/2), random(D/2, height-D/2)*/);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    
    //println(location.x + "  " + location.y);
  }
  void walls(){
    if((location.x+D/2>width)||(location.x-D/2<0)) velocity.x = 1*(-velocity.x-0.1);
    if((location.y+D/2>height)||(location.y-D/2<0)) velocity.y = 1*(-velocity.y-0.1);

  }
  void update(){
    
    velocity.add(acceleration);
    //velocity.limit(20);
    //velocity.mult(0.99);
    location.add(velocity);
    acceleration.setMag(0);
  }
  void applyForce(PVector force){
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  void display(){
    line(origin.x, origin.y, location.x, location.y);
    ellipse(location.x,location.y, D, D);
  }
}

CreateObject[] balls;

int N = 1; 
//float restLength = 300;
int CurLength;

PVector origin;

void setup(){
  size(1200,700);  
  int length = 150;
  balls = new CreateObject[N];
  for(int i=0;i<balls.length;i++){
    balls[i] = new CreateObject(length);
    //length+=20;
  }
  origin = new PVector(width/2, 0);
  strokeWeight(3);
  stroke(255);
}


void draw(){
  background(0);
  fill(255, 100);
  stroke(255);
  for(CreateObject ball : balls){
    PVector gravitation = new PVector(0, 0.3);
    gravitation.mult(ball.mass);
    ball.applyForce(gravitation);
    
    PVector string = PVector.sub(ball.location, origin);
    float x = string.mag() - ball.restLength;
    float k=0.01;
    string.setMag(-k*x);
    //PVector a = string;
    //float cos = gravitation.y/sqrt((ball.location.x - gravitation.x)*(ball.location.x - gravitation.x) + gravitation.y*gravitation.y);
    //string.setMag(gravitation.mag()*cos(PVector.angleBetween(gravitation, string)));
    //string.setMag(gravitation.y*cos);
    ball.applyForce(string);
     
    //println(degrees(PVector.angleBetween(gravitation, string)));
    
    if(mousePressed && (mouseButton == LEFT)){
      PVector tornado = new PVector(0.5, 0);
      ball.applyForce(tornado);
    }
    if(mousePressed && (mouseButton == RIGHT)){
      PVector wind = new PVector(-0.5, 0);
      ball.applyForce(wind);
    }
    
    ball.walls();
    ball.update();
    ball.display();
  }
}
