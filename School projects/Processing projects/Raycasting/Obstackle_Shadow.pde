class Shadow{
  private
  //тень задаётся 3 точками: координатой источника света и "крайними" точками фигуры
  PVector lightSource;
  PVector extremePoint1;
  PVector extremePoint2;
  public
  Shadow(PVector lightSource_, PVector extremePoint1_, PVector extremePoint2_){
    lightSource = lightSource_;
    extremePoint1 = extremePoint1_;
    extremePoint2 = extremePoint2_;
  }
  void display(){
    Ray ray1 = new Ray(lightSource, PVector.sub(extremePoint1, lightSource));
    Ray ray2 = new Ray(lightSource, PVector.sub(extremePoint2, lightSource));
    
    //находим точки пересечения с границами экрана
    PVector screenIntersectPoint1 = new PVector(0, 0), screenIntersectPoint2 = new PVector(0, 0);
    PVector[] screenBox = {new PVector(0, 0), new PVector(width, 0), new PVector(width, height), new PVector(0, height), new PVector(0, 0)};
    
    for(int i = 1; i < 5; ++i){
      if(ray1.intersect(screenBox[i-1].x, screenBox[i-1].y, screenBox[i].x, screenBox[i].y)){
        screenIntersectPoint1 = ray1.intersectionPoint(screenBox[i-1].x, screenBox[i-1].y, screenBox[i].x, screenBox[i].y);
      }
      if(ray2.intersect(screenBox[i-1].x, screenBox[i-1].y, screenBox[i].x, screenBox[i].y)){
        screenIntersectPoint2 = ray2.intersectionPoint(screenBox[i-1].x, screenBox[i-1].y, screenBox[i].x, screenBox[i].y);
      }
    }
    
    strokeWeight(2);
    stroke(0);
    fill(0);
    beginShape();
    vertex(extremePoint1.x, extremePoint1.y);
    vertex(extremePoint2.x, extremePoint2.y);
    vertex(screenIntersectPoint2.x, screenIntersectPoint2.y);
    vertex(screenIntersectPoint1.x, screenIntersectPoint1.y);
    endShape(CLOSE);
    
    //находим граничные точки экрана
    //эти точки и источник света находяться по разные стороны от прямой заданной точками screenIntersectPoint1 и screenIntersectPoint2
    PVector main = PVector.sub(screenIntersectPoint2, screenIntersectPoint1);//вектор, от которого отсчитываются углы
    PVector lightSourceDir = PVector.sub(lightSource, screenIntersectPoint1);
    float lightSourceProduct = lightSourceDir.x*main.y - lightSourceDir.y*main.x;
    
    PVector screenCornerDir;
    float screenCornerProduct;
    int cornerDotsCount = 0;
    PVector[] cornerDots = new PVector[3];
    
    
    screenCornerDir = PVector.sub(new PVector(0, 0), screenIntersectPoint1);
    screenCornerProduct = screenCornerDir.x*main.y - screenCornerDir.y*main.x;
    if(screenCornerProduct*lightSourceProduct < 0){
      cornerDots[cornerDotsCount] = new PVector(0, 0);
      ++cornerDotsCount;
    }
    
    screenCornerDir = PVector.sub(new PVector(width, 0), screenIntersectPoint1);
    screenCornerProduct = screenCornerDir.x*main.y - screenCornerDir.y*main.x;
    if(screenCornerProduct*lightSourceProduct < 0){
      cornerDots[cornerDotsCount] = new PVector(width, 0);
      ++cornerDotsCount;
    }
    
    screenCornerDir = PVector.sub(new PVector(0, height), screenIntersectPoint1);
    screenCornerProduct = screenCornerDir.x*main.y - screenCornerDir.y*main.x;
    if(screenCornerProduct*lightSourceProduct < 0){
      cornerDots[cornerDotsCount] = new PVector(0, height);
      ++cornerDotsCount;
    }
    
    screenCornerDir = PVector.sub(new PVector(width, height), screenIntersectPoint1);
    screenCornerProduct = screenCornerDir.x*main.y - screenCornerDir.y*main.x;
    if(screenCornerProduct*lightSourceProduct < 0){
      cornerDots[cornerDotsCount] = new PVector(width, height);
      ++cornerDotsCount;
    }
    
    fill(0);
    //это ужас, но лучше я ничего не придумал
    if(cornerDotsCount == 1) triangle(cornerDots[0].x, cornerDots[0].y, screenIntersectPoint1.x, screenIntersectPoint1.y, screenIntersectPoint2.x, screenIntersectPoint2.y);
    if(cornerDotsCount == 2){
      triangle(cornerDots[0].x, cornerDots[0].y, screenIntersectPoint1.x, screenIntersectPoint1.y, screenIntersectPoint2.x, screenIntersectPoint2.y);
      triangle(cornerDots[1].x, cornerDots[1].y, screenIntersectPoint1.x, screenIntersectPoint1.y, screenIntersectPoint2.x, screenIntersectPoint2.y);
      triangle(cornerDots[0].x, cornerDots[0].y, cornerDots[1].x, cornerDots[1].y, screenIntersectPoint1.x, screenIntersectPoint1.y);
      triangle(cornerDots[0].x, cornerDots[0].y, cornerDots[1].x, cornerDots[1].y, screenIntersectPoint2.x, screenIntersectPoint2.y);
    }
    if(cornerDotsCount == 3){
      triangle(screenIntersectPoint1.x, screenIntersectPoint1.y, cornerDots[0].x, cornerDots[0].y, cornerDots[1].x, cornerDots[1].y);
      triangle(screenIntersectPoint1.x, screenIntersectPoint1.y, cornerDots[0].x, cornerDots[0].y, cornerDots[2].x, cornerDots[2].y);
      triangle(screenIntersectPoint1.x, screenIntersectPoint1.y, cornerDots[0].x, cornerDots[0].y, screenIntersectPoint2.x, screenIntersectPoint2.y);
      triangle(screenIntersectPoint1.x, screenIntersectPoint1.y, cornerDots[1].x, cornerDots[1].y, cornerDots[2].x, cornerDots[2].y);
      triangle(screenIntersectPoint1.x, screenIntersectPoint1.y, cornerDots[1].x, cornerDots[1].y, screenIntersectPoint2.x, screenIntersectPoint2.y);
      triangle(screenIntersectPoint1.x, screenIntersectPoint1.y, cornerDots[2].x, cornerDots[2].y, screenIntersectPoint2.x, screenIntersectPoint2.y);
    }
  }
};
