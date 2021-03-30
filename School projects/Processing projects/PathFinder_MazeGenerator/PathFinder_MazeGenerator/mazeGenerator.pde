class Maze{
  private
    int mazeHeight, mazeLength;
    int x, y;
    int xDir, yDir;
    mazeCell [][]mazeBoard;
    Stack path;
    boolean neighbours = false;
  public
    Maze(int Height, int Length){//размеры лабиринта x, y; 
      x = 1;
      y = 1;
      xDir=0;
      yDir=0;
      mazeHeight = Height;
      mazeLength = Length;
      mazeBoard = new mazeCell[mazeHeight][mazeLength];
      for(int i = 0;i<mazeHeight;i++){
        for(int j = 0;j<mazeLength;j++){
          mazeBoard[i][j] = new mazeCell(0, j, i);
        }
      }
      for(int i = 1;i<mazeHeight-1;i+=2){
        for(int j = 1;j<mazeLength-1;j+=2){
          mazeBoard[i][j].state = 1;
        }
      }
      mazeBoard[y][x].state = 2;
      path = new Stack(mazeHeight*mazeLength);
      path.addElement(mazeBoard[y][x]);
      
    }

    boolean isNeighbours(){//проверка на тупик
      neighbours = false;
      if((y+2)<mazeHeight){
        if(mazeBoard[y+2][x].state==1){//down
          neighbours = true;
        }
      }
      if((y-2)>0){
        if(mazeBoard[y-2][x].state==1){//up
          neighbours = true;
        }
      }
      if((x+2)<mazeLength){
        if(mazeBoard[y][x+2].state==1){//right
          neighbours = true;
        }
      }
      if((x-2)>0){
        if(mazeBoard[y][x-2].state==1){//left
          neighbours = true;
        }
      }
      return neighbours;
    }
    
    boolean screenIntersect(int a, int b){
      if(b<mazeHeight && b>0 && a>0 && a<mazeLength){
        return true;
      }
      return false;
    }
    
    void deleteWall(int point1X, int point1Y, int point2X, int point2Y){
      mazeBoard[(int)((point1Y+point2Y)/2)][(int)((point1X+point2X)/2)].state = 1;
    }
    
    boolean getCellState(int xm, int ym){
      if(mazeBoard[ym][xm].state==1 || mazeBoard[ym][xm].state==2) return true;
      return false;
    }

    void GenerateMaze(){
      while(!path.isEmpty()){
        while(isNeighbours()){//движемся в произвольном направлении
            int rand = (int)(Math.random()*4);
            switch(rand){//выбираем направление движения
              case 0://right
                xDir=1;
                yDir=0;
                break;
              case 1://left
                xDir=-1;
                yDir=0;
                break;
              case 2://down
                yDir=1;
                xDir=0;
                break;
              case 3://up
                yDir=-1;
                xDir=0;
                break;
            }
        
          if(screenIntersect(x+xDir*2, y+yDir*2) && mazeBoard[y+yDir*2][x+xDir*2].state==1){//сдвигаемся в клетку по выбранному направлению
              mazeBoard[y][x].state = 2;
              deleteWall(x, y, x+xDir*2, y+yDir*2);
              x += xDir*2;
              y += yDir*2;
              path.addElement(mazeBoard[y][x]);//добавляем новую клетку в стек
              mazeBoard[y][x].state = 2;
          }
          
        }
      
        //если тупик - двигаемся по стеку обратно пока не найдём свободные соседние клетки

        path.deleteElement();
        
        if(!path.isEmpty()){
          mazeCell curCell = path.readTop();
          x = curCell.x;
          y = curCell.y;
        }
      }
    }
}
