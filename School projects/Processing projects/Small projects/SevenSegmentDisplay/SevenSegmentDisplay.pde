class SevenSegmentScreen{
private
  int background;
  color segColor;
  int xCor, yCor;
  int segWidth, segLen;
  int segDist;
public
  SevenSegmentScreen(){
    background = 80;
    segColor = color(255, 0, 0);
    xCor = 0;
    yCor = 0;
    segWidth = 50;
    segLen = 150;
    segDist = 280;
  }
  
  void setColor(color _segColor){
    segColor = _segColor;
  }
  
  void setBackground(int _background){
    background = _background;
  }
  
  void setCoordinates(int _x, int _y){
    xCor = _x;
    yCor = _y;
  }
  
  void setSize(int _segWidth, int _segLen){
    segWidth = _segWidth;
    segLen = _segLen;
    segDist = 2 * segWidth + segLen;
    segDist += segDist / 4;
  }
  
  /*void setDist(int _segDist){
    segDist = _segDist;
  }*/
  
  color getColor(int mask, int segNum){
    float redK = red(segColor)/255.0;
    float greenK = green(segColor)/255.0;
    float blueK = blue(segColor)/255.0;
    int on_off = (mask >> segNum) & 1;
    int rectangleState = background + (255 - background) * on_off;
    int r = int(redK * rectangleState);
    int g = int(greenK * rectangleState);
    int b = int(blueK * rectangleState);
    return color(r, g, b);
  }
  
  void drawDigit(int digit, int x, int y){
    int a = segWidth;
    int b = segLen;
    noStroke();
    int[] numMasks = {0x7E, 0x30, 0x6D, 0x79, 0x33, 0x5B, 0x5F, 0x70, 0x7F, 0x7B};
    int mask = numMasks[digit];
    int r = a / 2;
    rectMode(CORNERS);
    //A
    fill(getColor(mask, 6));
    rect(x + a, y, x + a + b, y + a, r);
    //B
    fill(getColor(mask, 5));
    rect(x + a + b, y + a, x + 2 * a + b, y + a + b, r);
    //C
    fill(getColor(mask, 4));
    rect(x + a + b, y + 2 * a + b, x + 2 * a + b, y + 2 * a + 2 * b, r);
    //D
    fill(getColor(mask, 3));
    rect(x + a, y + 2 * a + 2 * b, x + a + b, y + 3 * a + 2 * b, r);
    //E
    fill(getColor(mask, 2));
    rect(x, y + 2 * a + b, x + a, y + 2 * a + 2 * b, r);
    //F
    fill(getColor(mask, 1));
    rect(x, y + a, x + a, y + a + b, r);
    //G
    fill(getColor(mask, 0));
    rect(x + a, y + a + b, x + a + b, y + 2 * a + b, r);
    
  }
  void drawSegment(int num){//число, левый верхний край, размеры сегмента цифры (segLen < segDist)
    int numLen = 0, numCopy = num;
    int x = xCor;
    int y = yCor;
    //криво, нужно сделать нормальный разворот числа
    while(num > 0){
      num /= 10;
      ++numLen;
    }
    int []digit = new int[numLen];
    for(int i = 0; numCopy > 0; ++i){
      digit[i] = numCopy % 10;
      numCopy /= 10;
    }
    for(int i = numLen - 1; i >= 0; --i){
      drawDigit(digit[i], x, y);
      x += segDist;
    }
  }
};



SevenSegmentScreen screen1 = new SevenSegmentScreen();
void setup(){
  size(1900, 900);
  screen1.setCoordinates(300, 200);
  screen1.setSize(30, 150);
  screen1.setColor(color(230, 120, 170));
  screen1.setBackground(50);
}

int c = 0;
void draw(){
  background(0);
  frameRate(2);
  c++;
  screen1.drawSegment(c);
}


/*
color getColor(int mask, int segNum){
  int background = 100;
  int r = background + (255 - background) * ((mask >> segNum) & 1);
  int g = 0;
  int b = 0;
  return color(r, g, b);
};
void drawDigit(int num, int x, int y, int a, int b){//число, левый верхний край, размеры сегмента
  noStroke();
  int[] numMasks = {0x7E, 0x30, 0x6D, 0x79, 0x33, 0x5B, 0x5F, 0x70, 0x7F, 0x7B};
  int mask = numMasks[num];
  int r = a / 2;
  rectMode(CORNERS);
  //A
  fill(getColor(mask, 6));
  rect(x + a, y, x + a + b, y + a, r);
  //B
  fill(getColor(mask, 5));
  rect(x + a + b, y + a, x + 2 * a + b, y + a + b, r);
  //C
  fill(getColor(mask, 4));
  rect(x + a + b, y + 2 * a + b, x + 2 * a + b, y + 2 * a + 2 * b, r);
  //D
  fill(getColor(mask, 3));
  rect(x + a, y + 2 * a + 2 * b, x + a + b, y + 3 * a + 2 * b, r);
  //E
  fill(getColor(mask, 2));
  rect(x, y + 2 * a + b, x + a, y + 2 * a + 2 * b, r);
  //F
  fill(getColor(mask, 1));
  rect(x, y + a, x + a, y + a + b, r);
  //G
  fill(getColor(mask, 0));
  rect(x + a, y + a + b, x + a + b, y + 2 * a + b, r);
}*/
