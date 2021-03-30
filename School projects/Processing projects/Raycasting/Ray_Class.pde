class Ray{//evangelion )))
  private
  PVector coord;
  PVector dir;
  public
  Ray(PVector coord_, PVector dir_){
    coord = coord_;
    dir = dir_;
  }
  boolean intersect(float x1, float y1, float x2, float y2){//пересечение отрезка и луча
    float x3 = coord.x;
    float y3 = coord.y;
    float x4 = coord.x + dir.x;
    float y4 = coord.y + dir.y;
    float den = (x1 - x2)*(y3 - y4) - (y1 - y2)*(x3 - x4);
    if(den == 0) return false;
    float t = ((x1 - x3)*(y3 - y4) - (y1 - y3)*(x3 - x4)) / den;
    float u = -((x1 - x2)*(y1 - y3) - (y1 - y2)*(x1 - x3)) / den;
    if(0 < t && t < 1 && 0 < u) return true;
    else return false;
  }
  PVector intersectionPoint(float x1, float y1, float x2, float y2){
    float x3 = coord.x;
    float y3 = coord.y;
    float x4 = coord.x + dir.x;
    float y4 = coord.y + dir.y;
    float den = (x1 - x2)*(y3 - y4) - (y1 - y2)*(x3 - x4);
    float t = ((x1 - x3)*(y3 - y4) - (y1 - y3)*(x3 - x4)) / den;
    //float u = - ((x1 - x2)*(y1 - y3) - (y1 - y2)*(x1 - x3)) / den;
    float xIntersect = x1 + t*(x2-  x1);
    float yIntersect = y1 + t*(y2 - y1);
    
    return new PVector(xIntersect, yIntersect);
  }
  PVector getCoord(){
    return coord;
  }
  PVector getDir(){
    return dir;
  }
};
