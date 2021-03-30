PImage img;

float angle = PI / 7;
void setup(){
  size(1200, 700);
  //img = loadImage("more_gory.jpg");
  /*translate(30, 20);
  rect(0, 0, 55, 55);  // Draw rect at new 0,0
  translate(14, 14);*/
  noLoop();
  
  println(cos(radians(45.0)));
  line(0, 0, 0, -50);
  background(255);
}
int x = 0;
void draw(){
  fill(255);
  translate(width/2, height-120);
  DrawFractalBranch1(100.0, 10);

  // Saves each frame as line-000001.png, line-000002.png, etc.
  //saveFrame("FractalTree20.jpg");
  /*line(width/2, 0, width/2, 100);
  rotate(PI/5.0);
  line(width/2+100, 0, width/2+100, 100);
  line(width/2+200, 0, width/2+200, 100);*/
}

void DrawFractalBranch1(float length, float thickness){
  stroke(250, 100, length+50);
  //stroke(0);
  /*if(thickness>1)*/ thickness*=0.8;
  strokeWeight(thickness);
  line(0, 0, 0, -length);
  //translate(int(sin(radians(angle))*length), -int(cos(radians(angle))*length));
  translate(0, -length);
  
  if(length>4){
    pushMatrix();
    rotate(1.6*angle);
    strokeWeight(thickness);
    DrawFractalBranch1(length*0.8, thickness);
    popMatrix();
    pushMatrix();
    rotate(-0.7*angle);
    strokeWeight(thickness);
    DrawFractalBranch1(length*0.8, thickness);
    popMatrix();
  }
}
