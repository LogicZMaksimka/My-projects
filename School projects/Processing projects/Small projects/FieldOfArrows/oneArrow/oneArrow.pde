void arrow(int x1, int y1, int len){
  float full_len = sqrt((mouseX-x1)*(mouseX-x1) + (mouseY-y1)*(mouseY-y1));
  float cur_len = len / full_len;
  float x2 = (mouseX - x1)*cur_len + x1;
  float y2 = (mouseY - y1)*cur_len + y1;
  float angle = radians(30);
  float small_len = 0.3;
  strokeWeight(2);
  stroke(255);
  line(x1, y1, x2, y2);
  pushMatrix();
    translate(x2, y2);
    rotate(angle);
    line((x1-x2)*small_len, (y1-y2)*small_len, 0, 0);
  popMatrix();
  pushMatrix();
    translate(x2, y2);
    rotate(-angle);
    line((x1-x2)*small_len, (y1-y2)*small_len, 0, 0);
  popMatrix();
}
void setup(){
  size(1000, 700);
}
void draw(){
  background(0);
  arrow(width/2, height/2, 50);
}
