int xspeed = 8;
int yspeed = 8;
int x=width/2, y=height/2;
int d = 72;
int r = d/2;
void setup(){
  size(700, 500);
  
  fill(0, 255, 0);
}
void draw(){
  background(255);
  x += xspeed;
  y += yspeed;
  if((x-r<0)||(x+r>width)) xspeed *= -1;
  if((y-r<0)||(y+r>height)) yspeed *= -1;
  ellipse(x, y, d, d);
}
