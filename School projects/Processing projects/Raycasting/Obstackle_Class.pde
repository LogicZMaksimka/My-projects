class Obstackle{
  private
  PVector[] nodePoint;
  int nodesCount;
  int attractionRadius;
  boolean obstackleClosed;
  Mouse mouse1;
  public
  Obstackle(){
    nodePoint = new PVector[100];
    mouse1 = new Mouse();
    obstackleClosed = false;
    nodesCount = 0;
    attractionRadius = 10;
  }
  Obstackle(PVector[] obj, int count){
    nodePoint = new PVector[100];
    for(int i = 0; i < count; ++i){
      nodePoint[i] = obj[i];
    }
    mouse1 = new Mouse();
    obstackleClosed = true;
    nodesCount = count;
    attractionRadius = 10;
  }
  void createObstackle(){//нормально работает?
    if(!obstackleClosed){
      if(nodesCount > 0){
        //отрисовка вспомогательной линии
        strokeWeight(2);
        stroke(0, 0, 255);
        fill(0, 0, 255);
        line(nodePoint[nodesCount - 1].x, nodePoint[nodesCount - 1].y, mouseX, mouseY);
           
        //отрисовка поля притяжения вершины ломанной
        fill(0, 0, 255, 100);
        stroke(2);
        for(int i = 0; i < nodesCount; ++i){
          if(dist(mouseX, mouseY, nodePoint[i].x, nodePoint[i].y) <= attractionRadius){
            ellipse(nodePoint[i].x, nodePoint[i].y, attractionRadius, attractionRadius);
          }
        }
     }
      
      //добавление новой точки в контур
      if(mouse1.clicked()){
        if(nodesCount == 0){
          nodePoint[nodesCount] = new PVector(mouseX, mouseY);
          ++nodesCount;
        }
        else{
          PVector mouse = new PVector(mouseX, mouseY);
          for(int i = 0; i < nodesCount; ++i){
            if(dist(mouseX, mouseY, nodePoint[i].x, nodePoint[i].y) <= attractionRadius){
              mouse = nodePoint[i];
              if(i == 0) obstackleClosed = true;//проверка на замыкание фигуры
              break;
            }
          }
          nodePoint[nodesCount] = mouse;
          ++nodesCount;
        }
      }
    }
  }
  void displayObstackle(){//нормально работает?
    if(obstackleClosed){
      strokeWeight(3);
      stroke(50);
      fill(50);
      beginShape();
      for(int i = 0; i < nodesCount; ++i){
        vertex(nodePoint[i].x, nodePoint[i].y);
      }
      endShape();
    }
    else{
      stroke(0, 0, 255);
      for(int i = 1; i < nodesCount; ++i){
         line(nodePoint[i-1].x, nodePoint[i-1].y, nodePoint[i].x, nodePoint[i].y);
      }
    }
  }
  Shadow getObstackleShadow(PVector coord){//пока работает только для выпуклых многоугольников
    //для определения параметров тени фигуры нужно среди всех вершин этой фигуры найти 2 такие, которые образуют самый большой угол с источником света
    //для их определения нужно:
    //1 - выбрать любую точку фигуры (первую например), и задать вектор "normal", направленный из точки источника света в выбранную случайную точку. Это и будет вектор, от которого будут отсчитываться углы
    //2 - в каждой из полуплоскостей на которые вектор "normal" делит плоскость, создаём вектор направленный из точки источника света в каждую точку этой полуплоскости.
    //3 - Ищем точку, которая задаст вектор, образующий максимальный угол с вектором "normal".
    //в каждой полуплоскости будет своя "крайняя" точка
    
    PVector extrPointUp = coord, extrPointDown = coord;
    if(nodesCount > 1){
      float maxAngleUp = -1;
      float maxAngleDown = -1;
      PVector normalVector = PVector.sub(nodePoint[0], coord);//выктор от которого отсчитываются углы
      //для определения полуплоскости, в которую попадает точка, восользуемся косым произведением векторов
      //при таком решении не требуется дополнительного вычисления уравнения прямой
      //косое произведение векторов a(x1, y1) и b(x2, y2): [a, b] = x1*y2 - x2*y1
      //по знаку [a, b] определяем положение точки относительно прямой
      for(int i = 0; i < nodesCount; ++i){
        PVector curVector = PVector.sub(nodePoint[i], coord);
        
        if((curVector.x*normalVector.y - curVector.y*normalVector.x) >= 0){
          float angle = PVector.angleBetween(curVector, normalVector);
          if(maxAngleUp < angle){
            maxAngleUp = angle;
            extrPointUp = nodePoint[i];
          }
        }
        
        if((curVector.x*normalVector.y - curVector.y*normalVector.x) <= 0){
          float angle = PVector.angleBetween(curVector, normalVector);
          if(maxAngleDown < angle){
            maxAngleDown = angle;
            extrPointDown = nodePoint[i];
          }
        }
      }
    }
    
    return new Shadow(coord, extrPointUp, extrPointDown);
  }
  void drawRoundShadow(PVector coord){
    getObstackleShadow(coord).display();
  }
  
  boolean intersectBy(Ray ray){
    for(int i=1;i<nodesCount;++i){
      if(ray.intersect(nodePoint[i-1].x, nodePoint[i-1].y, nodePoint[i].x, nodePoint[i].y)){
        return true;
      }
    }
    return false;
  }
  
  PVector rayIntersectionPoint(Ray ray){//пересечение луча с объектом
    float minDist = height*height + width*width;
    PVector intersectionPoint = new PVector(0, 0);
    for(int i=1;i<nodesCount;++i){
      if(ray.intersect(nodePoint[i-1].x, nodePoint[i-1].y, nodePoint[i].x, nodePoint[i].y)){
        PVector x = ray.intersectionPoint(nodePoint[i-1].x, nodePoint[i-1].y, nodePoint[i].x, nodePoint[i].y);
        PVector y = ray.getCoord();
        if(PVector.dist(x, y) < minDist){
          minDist = PVector.dist(x, y);
          intersectionPoint = x;
        }
      }
    }
    return intersectionPoint;
  }
  
  boolean endFigure(){//проверяет доросована фигура или нет
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
