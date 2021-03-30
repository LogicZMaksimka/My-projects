class Scrollbar{
  int x1, y1, x2, y2;
  int sX, sY;
  int sLen, sHeight;
  boolean activateScroll;
  public
  Scrollbar(int xLeft, int yLeft, int xRight, int yRight, int len){
    x1 = xLeft;
    y1 = min(yLeft, yRight);
    x2 = xRight;
    y2 = max(yLeft, yRight);
    sLen = len;
    sHeight = abs(y1 - y2);
    sX = x1 + sLen/2;
    sY = abs(y1 + y2)/2;
    activateScroll = false;
  }
  void mouseClicked(){
    if(x1 <= mouseX && mouseX <= x2 && y1 <= mouseY && mouseY <= y2) activateScroll = true;
  }
  void update(){
    mouseClicked();
    if(!mousePressed) activateScroll = false;
    if(activateScroll){
      if(mouseX < x1 + sLen/2) sX = x1 + sLen/2;
      else if(x2 - sLen/2 < mouseX) sX = x2 - sLen/2;
      else sX = mouseX;
    }
  }
  void display(){
    noStroke();
    fill(150);
    rectMode(CORNERS);
    rect(x1, y1, x2, y2);
    fill(0);
    rectMode(CENTER);
    rect(sX, sY, sLen, sHeight);
  }
  float getPos(){
    return float(sX - x1 - sLen/2)/(x2 - x1 - sLen);
  }
};
