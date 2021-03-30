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

  //int[][] board = new int [boardLength][boardHeight];
void setup(){
  size(1800, 1000);
}
  int rectSize = 100;
  int rectDist = 2;
  int rectDistance = rectSize + rectDist;
  int boardLength = (1800 - (1800 % rectDistance))/rectDistance;
  int boardHeight = (1000 - (1000 % rectDistance))/rectDistance;
  
void draw(){
  background(0);
  for(int i = 0; i < boardLength;i++){
    for(int j=0;j<boardHeight;j++){
      arrow(i * rectDistance, j * rectDistance, rectSize/2);
    }
  }
}
