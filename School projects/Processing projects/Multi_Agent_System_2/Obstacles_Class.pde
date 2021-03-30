class Obstackle{
  private
  PVector[] node;
  int nodesCount;
  int attractionRadius;
  boolean obstackleClosed;
  Mouse mouse1;
  public
  Obstackle(){
    node = new PVector[100];
    mouse1 = new Mouse();
    obstackleClosed = false;
    nodesCount = 0;
    attractionRadius = 10;
  }
  void createObstackle(){//нормально работает?
    if(!obstackleClosed){
      //отрисовка вспомогательной линии
      stroke(2);
      fill(0, 0, 255);
      line(node[nodesCount - 1].x, node[nodesCount - 1].y, mouseX, mouseY);
      
      //отрисовка поля притяжения вершины ломанной
      fill(0, 0, 255, 100);
      stroke(2);
      for(int i = 0; i < nodesCount; ++i){
        if(dist(mouseX, mouseY, node[i].x, node[i].y) <= attractionRadius){
          ellipse(node[i].x, node[i].y, attractionRadius, attractionRadius);
        }
      }
      
      //добавление новой точки в контур
      if(mouse1.clicked()){
        if(nodesCount == 0){
          node[nodesCount] = new PVector(mouseX, mouseY);
          ++nodesCount;
        }
        else{
          PVector mouse = new PVector(mouseX, mouseY);
          for(int i = 0; i < nodesCount; ++i){
            if(dist(mouseX, mouseY, node[i].x, node[i].y) <= attractionRadius){
              mouse = node[i];
              if(i == 0) obstackleClosed = true;
              break;
            }
          }
          node[nodesCount] = mouse;
          ++nodesCount;
        }
      }
    }
  }
  void displayObstackle(){//нормально работает?
    beginShape();
    for(int i = 0; i < nodesCount; ++i){
      vertex(node[i].x, node[i].y);
    }
    endShape();
  }
  Shadow getObstackleShadow(PVector coord){//пока работает только для выпуклых многоугольников
    //для определения параметров тени фигуры нужно среди всех вершин этой фигуры найти 2 такие, которые образуют самый большой угол с источником света
    //для их определения нужно:
    //1 - выбрать любую точку фигуры (первую например), и задать вектор "normal", направленный из точки источника света в выбранную случайную точку. Это и будет вектор, от которого будут отсчитываться углы
    //2 - в каждой из полуплоскостей на которые вектор "normal" делит плоскость, создаём вектор направленный из точки источника света в каждую точку этой полуплоскости.
    //3 - Ищем точку, которая задаст вектор, образующий максимальный угол с вектором "normal".
    //в каждой полуплоскости будет своя "крайняя" точка
    fill(0, 0, 255);
    strokeWeight(2);
    line(coord.x, coord.y, node[0].x, node[0].y); 
    PVector extrPointUp = coord, extrPointDown = coord;
    if(nodesCount > 1){
      float maxAngleUp = -1;
      float maxAngleDown = -1;
      PVector normalVector = PVector.sub(node[0], coord);//выктор от которого отсчитываются углы
      //для определения полуплоскости, в которую попадает точка, восользуемся косым произведением векторов
      //при таком решении не требуется дополнительного вычисления уравнения прямой
      //косое произведение векторов a(x1, y1) и b(x2, y2): [a, b] = x1*y2 - x2*y1
      //по знаку [a, b] определяем положение точки относительно прямой
      for(int i = 0; i < nodesCount; ++i){
        PVector curVector = PVector.sub(node[i], coord);
        
        if((curVector.x*normalVector.y - curVector.y*normalVector.x) >= 0){
          float angle = PVector.angleBetween(curVector, normalVector);
          if(maxAngleUp < angle){
            maxAngleUp = angle;
            extrPointUp = node[i];
          }
          fill(255, 0, 0);
          ellipse(node[i].x, node[i].y, 3, 3);
        }
        
        if((curVector.x*normalVector.y - curVector.y*normalVector.x) <= 0){
          float angle = PVector.angleBetween(curVector, normalVector);
          if(maxAngleDown < angle){
            maxAngleDown = angle;
            extrPointDown = node[i];
          }
          fill(0, 255, 0);
          ellipse(node[i].x, node[i].y, 3, 3);
        }
      }
    }
    return new Shadow(coord, extrPointUp, extrPointDown);
  }
  void drawShadow(PVector coord){//отрисовка тени     //нормально работает?
    
    getObstackleShadow(coord).display();//доделать
    
    
    
    
    //отображаём всю фигуру
    
  }
  boolean endFigure(){
    return obstackleClosed;
  }
};





//работает, но это хрень
  /*void createObstackle(){
    //отрисовка поля притяжения вершины ломанной
    fill(0, 0, 255, 100);
    stroke(2);
    for(int i = 0; i < nodesCount; ++i){
      if(dist(mouseX, mouseY, node[i].x, node[i].y) <= attractionRadius){
        ellipse(node[i].x, node[i].y, attractionRadius, attractionRadius);
      }
    }
    //добавление новой точки в контур
    if(mouse1.clicked()){
      if(nodesCount == 0){
        node[nodesCount] = new PVector(mouseX, mouseY);
        ++nodesCount;
      }
      else{
        PVector mouse = new PVector(mouseX, mouseY);
        for(int i = 0; i < nodesCount; ++i){
          if(dist(mouseX, mouseY, node[i].x, node[i].y) <= attractionRadius){
            mouse = node[i];
            break;
          }
        }
        node[nodesCount] = mouse;
        ++nodesCount;
      }
    }
    //отрисовка вспомогательной линии
    if(nodesCount % 2 == 1){
      stroke(2);
      fill(0, 0, 255);
      line(node[nodesCount - 1].x, node[nodesCount - 1].y, mouseX, mouseY);
    }
  }
  void updateObstackle(){//отрисовка полного контура
    stroke(2);
    fill(0, 0, 255);
    if(nodesCount > 1){
      for(int i = 1; i < nodesCount; i += 2){
        line(node[i-1].x, node[i-1].y, node[i].x, node[i].y);
      }
    }
  }*/
