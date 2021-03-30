class Road{
  private
  float roadWidth;
  PVector[] road;
  float roadMinLen;
  int pointsCount;
  PVector getPerpendicularPoint(PVector firstLinePoint, PVector secondLinePoint, PVector projectionPoint){//1 и 2 - 2 точки на линии, 3 - точка которую проецируем
    PVector line = PVector.sub(secondLinePoint, firstLinePoint).normalize();
    PVector objVector = PVector.sub(projectionPoint, firstLinePoint);
    //расстояние от 1-й точки до точки проекции равняется скалярному произведению вектора "objVector" и нормаллизированного вектора "line"
    float len = objVector.x*line.x + objVector.y*line.y;
    PVector projection = PVector.add(firstLinePoint, line.mult(len));
    return projection;
  }
  public
  Road(int roadWidth_){
    roadWidth = roadWidth_;
    road = new PVector[1000];
    pointsCount = 0;
    roadMinLen = 20;
  }
  
  void createRoad(){//это работает криво (типо функция вызывается постоянно, пока мышка нажата), но правильно
    if(pointsCount == 0){
      road[pointsCount] = new PVector(mouseX, mouseY);
      ++pointsCount;
    }
    else{
      PVector roadLen = PVector.sub(new PVector(mouseX, mouseY), road[pointsCount - 1]);
      if(roadLen.mag() >= roadMinLen){//чтобы не ставить много маленьких секций дороги
        road[pointsCount] = new PVector(mouseX, mouseY);
        ++pointsCount;
      }
    }
  }
  
  PVector projectToRoad(PVector coord){//улучшить
    float minDist = sqrt(width*width + height*height);
    PVector result = new PVector(-1, -1);//точка не проецируется
    for(int i=0;i<pointsCount-1;++i){      
      PVector perpendicularPoint = getPerpendicularPoint(road[i], road[i+1], coord);
      //проверка на принадлежность точки отрезку дороги
      float x = perpendicularPoint.x;
      float y = perpendicularPoint.y;
      float x1 = min(road[i].x, road[i+1].x);
      float x2 = max(road[i].x, road[i+1].x);
      float y1 = min(road[i].y, road[i+1].y);
      float y2 = max(road[i].y, road[i+1].y);
      if((x1 <= x) && (x <= x2) && (y1 <= y) && (y <= y2)){
        PVector projectPoint = new PVector(x, y);
        if(PVector.sub(projectPoint, coord).mag() < minDist){
          minDist = PVector.sub(projectPoint, coord).mag();
          result = projectPoint;
        }
      }
    }
    return result;
  }
  
  boolean haveProjection(PVector coord){//улучшить
    float minDist = sqrt(width*width + height*height);
    PVector result = new PVector(-1, -1);//точка не проецируется
    for(int i=0;i<pointsCount-1;++i){      
      PVector perpendicularPoint = getPerpendicularPoint(road[i], road[i+1], coord);
      //проверка на принадлежность точки отрезку дороги
      float x = perpendicularPoint.x;
      float y = perpendicularPoint.y;
      float x1 = min(road[i].x, road[i+1].x);
      float x2 = max(road[i].x, road[i+1].x);
      float y1 = min(road[i].y, road[i+1].y);
      float y2 = max(road[i].y, road[i+1].y);
      if((x1 <= x) && (x <= x2) && (y1 <= y) && (y <= y2)){
        return true;
      }
    }
    return false;
  }
  
  float getRoadWidth(){
    return roadWidth;
  }
  
  void drawRoad(){
    stroke(50, 150);
    strokeWeight(roadWidth);
    for(int i=0;i<pointsCount-1;++i){      
      line(road[i].x, road[i].y, road[i+1].x, road[i+1].y);
    }
    strokeWeight(1);
  }
};
