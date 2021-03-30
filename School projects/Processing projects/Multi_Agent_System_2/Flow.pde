class FlowField{
  private
  int resolution;//размер клетки на которую разбивается поле
  FlowFieldCell cell[][];
  int arrI, arrJ;//размеры массива
  PVector mouseCoord;
  public
  FlowField(int resolution_){
    resolution = resolution_;
    arrI = int(width/resolution);
    arrJ = int(height/resolution);
    cell = new FlowFieldCell[arrI][arrJ];//[x][y]
    mouseCoord = new PVector(width/2, height/2);
    setlVelocityByAngle();
  }
  void setlVelocityByAngle(){//векторы всех скоростей соонаправлены, в параметрах: угол наклона
    float fieldSmooth = 0.1;
    for(int i=0;i<arrI;++i){
      for(int j=0;j<arrJ;++j){
        float angle = map(noise(i*fieldSmooth, j*fieldSmooth), 0, 1, 0, 2*PI);
        PVector vel = new PVector(cos(angle), -sin(angle));//система координат перевёрнута по оси y => -sin(angle)
        vel.normalize();
        cell[i][j] = new FlowFieldCell(new PVector(resolution * (0.5 + i), resolution * (0.5 + j)), vel.copy());
      }
    }
  } 
  void setMouseVelocity(){//установка направления векторов скоростей клеток поля с помощью мышки
    if(key == 'f' && mousePressed){
      PVector mouseVel = PVector.sub(new PVector(mouseX, mouseY), mouseCoord);
      mouseVel.normalize();
      int i = int(mouseX/resolution);
      int j = int(mouseY/resolution);
      if((0 <= i) && (i < arrI) && (0 <= j) && (j < arrJ)){
        cell[i][j].velocity = mouseVel.copy();
      }
    }
    mouseCoord = new PVector(mouseX, mouseY);
  }
  PVector getCellVelocity(PVector coord){//получение вектора скорости записанного, записанного в ячейке, в которой находится агент
    int i = int(coord.x/resolution);
    int j = int(coord.y/resolution);
    return cell[i][j].velocity;
  }
  int getResolution(){
    return resolution;
  }
  void drawFlowField(){//отображение поля
    for(int i=0;i<arrI;++i){
      for(int j=0;j<arrJ;++j){
        PVector vel = cell[i][j].velocity.copy();
        vel.setMag(resolution/2);//установка длинны стрелки
        PVector arrowEdge = PVector.add(cell[i][j].coord, vel);
        fill(130);
        noStroke();
        ellipse(cell[i][j].coord.x, cell[i][j].coord.y, 3, 3);
        stroke(0);
        line(cell[i][j].coord.x, cell[i][j].coord.y, arrowEdge.x, arrowEdge.y);
      }
    }
  }
};
