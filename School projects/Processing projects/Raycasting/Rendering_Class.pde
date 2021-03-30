class Render{
  private
  Obstackle[] obst;
  int obstCount;
  Ray[] ray;
  int raysCount;
  PVector cameraDir;
  public
  Render( Ray[] ray_, int raysCount_, Obstackle[] obst_, int obstCount_, PVector cameraDir_){
    obstCount = obstCount_;
    raysCount = raysCount_;
    ray = ray_;
    obst = obst_;
    cameraDir = cameraDir_;
  }
  void displayRays(){
    strokeWeight(2);
    stroke(255, 80);
    for(int i=0;i<raysCount;++i){//пересечение лучей с группой объектов
      float minDist = height*height + width*width;
      PVector intersectionPoint = new PVector(-1, -1);
      boolean intersect = false;
      for(int j=0;j<obstCount;++j){
        if(obst[j].intersectBy(ray[i])){
          intersect = true;
          PVector x = obst[j].rayIntersectionPoint(ray[i]);
          PVector y = ray[i].getCoord();
          if(PVector.dist(x, y) < minDist){
            minDist = PVector.dist(x, y);
            intersectionPoint = x;
          }
        }
      }
      if(!intersect){//пересечение с экраном
        PVector[] screenBox = {new PVector(0, 0), new PVector(width, 0), new PVector(width, height), new PVector(0, height), new PVector(0, 0)};
        Obstackle screen = new Obstackle(screenBox, 5);
        intersectionPoint = screen.rayIntersectionPoint(ray[i]);
      }
      line(ray[i].getCoord().x, ray[i].getCoord().y, intersectionPoint.x, intersectionPoint.y);
    }
  }
  void displayRoundLighting(PVector coord, int radius, int frequency){
    //отображение света в виде кругов с изменяющимся радиусом
    noStroke();
    for(int i = frequency; i > 0; --i){
      float bright = (frequency - i) * 255 / frequency;
      float r = i * radius / frequency;
      fill(bright);
      ellipse(coord.x, coord.y, r, r);
    }
    //отображаем тень
    for(int i=0;i<obstCount;++i){
      obst[i].drawRoundShadow(coord);
    }
    //отобржаем препятствие
    for(int i=0;i<obstCount;++i){
      obst[i].displayObstackle();
    }
  }
  void renderObstackles(){
    //окно отображения
    fill(0);
    rectMode(CORNERS);
    rect(width/2, 0, width, height);
    
    float lineWidth = width/(2*raysCount);
    for(int i=0;i<raysCount;++i){//пересечение лучей с группой объектов
      float minDist = height*height + width*width;
      PVector intersectionPoint = new PVector(-1, -1);
      boolean intersect = false;
      for(int j=0;j<obstCount;++j){
        if(obst[j].intersectBy(ray[i])){
          intersect = true;
          PVector x = obst[j].rayIntersectionPoint(ray[i]);
          PVector y = ray[i].getCoord();
          if(PVector.dist(x, y) < minDist){
            minDist = PVector.dist(x, y);
            intersectionPoint = x;
          }
        }
      }
      if(!intersect){//пересечение с экраном
        PVector[] screenBox = {new PVector(0, 0), new PVector(width, 0), new PVector(width, height), new PVector(0, height), new PVector(0, 0)};
        Obstackle screen = new Obstackle(screenBox, 5);
        intersectionPoint = screen.rayIntersectionPoint(ray[i]);
      }
      
      float distanceToObstackle = PVector.dist(ray[i].getCoord(), intersectionPoint);//нужно преобразовать, чтобы убрать эффект рыбьего глаза
      
      distanceToObstackle *= cos(PVector.angleBetween(cameraDir, ray[i].getDir()));
      float obstackleHeight;
      color obstackleColor;
      obstackleHeight = height*100/distanceToObstackle;//map(distanceToObstackle*distanceToObstackle, 0, width*width/16, height, 0);
      obstackleColor = color(map(distanceToObstackle*distanceToObstackle, 0, width*width/4, 255, 0));
      noStroke();
      rectMode(CENTER);
      fill(obstackleColor);
      rect(width/2 + (i + 0.5) * lineWidth, height/2, lineWidth, obstackleHeight);
    }
  }
}
