/*size(200, 200);
loadPixels();  
// Loop through every pixel column
for (int x = 0; x < width; x++) {
  // Loop through every pixel row
  for (int y = 0; y < height; y++) {
    // Use the formula to find the 1D location
    int loc = x + y * width;
    pixels[loc] = color(x, y, 100); 
  }
}
updatePixels(); */

class Complex{
  float rational;
  float irrational;
  Complex(float a, float b){
    rational = a;
    irrational = b;
  }
  /*void exp2(){
    int rat = rational;
    int irr = irrational;
    rational = rat*rat - irr*irr;
    irrational = 2*rat*irr;
  }*/
  void printComplex(){
    print("(" + rational + " ; " + irrational + ")\n");
  }
};

Complex sum(Complex a, Complex b){
  return new Complex(a.rational + b.rational, a.irrational + b.irrational);
}
Complex exp2(Complex x){
  return new Complex(x.rational * x.rational - x.irrational * x.irrational, 2 * x.rational * x.irrational);
}
float zoom = 1;
void setup(){
  size(1000, 1000);
  background(0);
  loadPixels();
  for(int x=0;x<width;++x){
    for(int y=0;y<height;++y){
      
      float accuracy = 1000;
      float lookAtX = -0.5;
      float lookAtY = 0;
      float a = map(x, 0, width, lookAtX - zoom, lookAtX + zoom);
      float b = map(y, 0, height, lookAtY - zoom, lookAtY + zoom);
      /*float mX = map(mouseX, 0, width, 0, 10);
      float mY = map(mouseY, 0, height, 0, 10);
      
      float a = map(x, 0, width, -mX, mX);
      float b = map(y, 0, height, -mY, mY);*/
      Complex MandFunc = new Complex(a, b);
      Complex c = MandFunc;
      int i = 0;
      for(;i<accuracy;++i){
        MandFunc = sum(exp2(MandFunc), c);
        if(MandFunc.rational*MandFunc.rational + MandFunc.irrational*MandFunc.irrational > 4) break;
      }
      float bright = map(i, 0, accuracy, 0, 255);
      if(bright == 255) bright = 0;
      int loc = x + y * width;
      pixels[loc] = color(bright*bright, 8*bright, 6*bright);
      
    }
  }
  updatePixels();
  //zoom *= 0.9;
  //delay(50);
  
  //saveFrame("Mandelbrot set5.jpg");
}

void draw(){
  
  
}
