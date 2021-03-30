PVector[] path;
PVector location;
PVector direction;
float velocity = 5;
int genLength = 700;
int vectNum;
int time;
void setup(){
  size(1200, 600);
  background(0);
  fill(255);
  location = new PVector(width/2, height/2);
  direction = new PVector(0, 0);
  path  = new PVector[genLength];
  for(int i=0; i<genLength;i++){
    path[i] = PVector.random2D();
  }
  
}
int c= 0;
void draw(){
  if(c<genLength){
    background(0);
    ellipse(location.x, location.y, 30, 30);
    PVector dir = path[c];
    dir.setMag(velocity);
    location.add(dir);
    
    c++;
  }
  else {
  println("1");
  c = 0;}
  
}
