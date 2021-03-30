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
  void display(){//исправить отображение тени, она должна доходить до краёв экрана
    //отображаем треугольник тени (всё от источника света до краёв экрана)
    
    
    
    
    //отображаем светлый треугольник (всё от источника света, до крайних точек фигуры)
    fill(255);
    triangle(lightSource.x, lightSource.y, extremePoint1.x, extremePoint1.y, extremePoint2.x, extremePoint2.y);
  }
}
