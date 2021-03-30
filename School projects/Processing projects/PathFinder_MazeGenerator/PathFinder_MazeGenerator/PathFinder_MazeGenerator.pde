class PathFinding{
    
    pathFinderCell board[][];
    pathFinderCell searchAreaCorners[];
    int cornersLength;
    int mazeX, mazeY;
    int x, y;
    int startX, startY, currentX, currentY, finishX, finishY;
    int FinalPathX, FinalPathY;
    int boardLength, boardHeight;
    int rectSize, rectDistance;
    int min;
    int minI, minJ;
    int c;
  public
    PathFinding(int rectSize1, int rectDistance1, int screenLength, int screenHigth){
      rectSize = rectSize1;
      rectDistance = rectSize+rectDistance1;
      cornersLength = 0;
      c=0;
      mazeX = 1;
      mazeY = 1;
      boardLength = (screenLength - (screenLength % rectDistance))/rectDistance;//вычисление кол-ва клеток опред. размера для данного размера экрана
      boardHeight = (screenHigth - (screenHigth % rectDistance))/rectDistance;
      board = new pathFinderCell [boardHeight][boardLength];
      searchAreaCorners = new pathFinderCell[boardHeight*boardLength];
      for(int i = 0; i<boardHeight;i++){
        for(int j = 0; j<boardLength;j++){
          if(i==0||i==boardHeight-1||j==0||j==boardLength-1) board[i][j]  = new pathFinderCell('w', j, i);
          else board[i][j]  = new pathFinderCell('n', j, i);
        }
      }
    }
    
    void SetCells(){//установка клеток мышью
      if((mouseX - (mouseX % rectDistance))/rectDistance>=0&&(mouseX - (mouseX % rectDistance))/rectDistance<=boardLength) x = (mouseX - (mouseX % rectDistance))/rectDistance;
      if((mouseY - (mouseY % rectDistance))/rectDistance>=0&&(mouseY - (mouseY % rectDistance))/rectDistance<=boardHeight) y = (mouseY - (mouseY % rectDistance))/rectDistance;
      if (mousePressed){
        switch (key){
          case 'w':
            board[y][x].mainState='w';//wall
            break;
          case 's':
            board[y][x].mainState='s';//start
            startX = x;
            startY = y;
            currentX = x;
            currentY = y;
            break;
          case 'f':
            board[y][x].mainState='f';//finish
            finishX = x;
            finishY = y;
            FinalPathX = x;
            FinalPathY = y;
            break;
          case 'n':
            board[y][x].mainState='n';//none
            break;
        }
      }
    }
    void CellsText(){//для отладки
      for(int i = 0; i<boardHeight;i++){
        for(int j = 0; j<boardLength;j++){
          fill(0, 0, 255);
          textSize(15);
          text("   " + board[i][j].x + "     " + board[i][j].y, j*rectDistance, i*rectDistance+rectSize-40);
          text("   " + board[i][j].ParentCellX + "     " + board[i][j].ParentCellY, j*rectDistance, i*rectDistance+rectSize-30);
          text("     " + board[i][j].mainState, j*rectDistance, i*rectDistance+rectSize-20);
        }
      }
    }
    
    void GenerateRandBoard(float x){//рандомная доска
      for(int i=0;i<int(boardHeight*boardHeight)*x;i++){
        board[(int) (Math.random() * (boardHeight-1))][(int) (Math.random() * (boardLength-1))].mainState = 'w';
      }
      for(int i = 0; i<boardLength;i++){
        for(int j = 0; j<boardHeight;j++){
          print("'" + board[j][i].mainState + "', ");
        }
      }
    }
    
    void GenerateMaze(){
      Maze maze;
      maze = new Maze(boardHeight, boardLength);
      maze.GenerateMaze();

      for(int i = 0; i<boardHeight;i++){
        for(int j = 0; j<boardLength;j++){
          if(maze.getCellState(j, i)==true) board[i][j].mainState = 'n';
          else board[i][j].mainState = 'w';
        }
      } 
    }
    
    void ShowBoard(){//отображение доски
      for(int i = 0; i<boardHeight;i++){
        for(int j = 0; j<boardLength;j++){
          switch(board[i][j].mainState){
            case 'w':
              fill(0);
              break;
            case 'n': 
              fill(250);
              break;
            case 't': 
              fill(150);
              //fill(250);
              break;
            case 's': 
              fill(0, 255, 0);
              break;
            case 'f': 
              fill(255, 0, 0);
              break;
            case 'p':
              fill(0, 0, 255);
          }
          strokeWeight(0);
          //stroke(0);
          rectMode(CORNERS);
          rect(j*rectDistance,i*rectDistance, rectSize + j*rectDistance, rectSize + i*rectDistance);
          
        }
      }
    }
    
    boolean EndCondition(){
      if(currentX==finishX && currentY==finishY){
        return true;
      }
      else return false;
    }
    
    void FindPath(){
      //println(c++);
      board[currentY][currentX].mainState='t';
      for(int i=currentX-1;i<currentX+2;i++){
        for(int j=currentY-1;j<currentY+2;j++){
          if(board[j][i].mainState!='w' && board[j][i].mainState!='t'){
                       
            board[j][i].DistanceToFinish = Math.min(abs(i-finishX), abs(j-finishY))*14 + (Math.max(abs(i-finishX), abs(j-finishY))-Math.min(abs(i-finishX), abs(j-finishY)))*10;
            
            int distance;//расстояние до соседней клетки
            
            if((i-currentX)==(j-currentY)||(i-currentX)==(currentY-j)) {
              distance = 14;//пошли по диагонали
            }
            else{
              distance = 10;//пошли по прямой
            }
            
            if(board[j][i].FinalCost > (board[j][i].DistanceToFinish + board[currentY][currentX].DistanceToStart + distance) || board[j][i].FinalCost==0){
               board[j][i].DistanceToStart = board[currentY][currentX].DistanceToStart + distance;
               board[j][i].ParentCellX = board[currentY][currentX].x;
               board[j][i].ParentCellY = board[currentY][currentX].y;
            }
            
            board[j][i].FinalCost = board[j][i].DistanceToStart + board[j][i].DistanceToFinish;
            
            searchAreaCorners[cornersLength] = board[j][i];
            //println("(" + i + ";" + j + ") = (" + board[j][i].x + ";" + board[j][i].y + ")\n");
            //println("э-т (" + searchAreaCorners[cornersLength].mainState + ";" + searchAreaCorners[cornersLength].FinalCost + ")  =  (" + board[j][i].mainState + ";" + board[j][i].FinalCost + ")\n");
            cornersLength++;
            
            for(int c=0;c<cornersLength;c++){
              //println("(" + searchAreaCorners[c].x + ";" + searchAreaCorners[c].y + ")");
              if(board[searchAreaCorners[c].y][searchAreaCorners[c].x].mainState == 't' || searchAreaCorners[c].mainState == 't'/* || (i==searchAreaCorners[c].x && j==searchAreaCorners[c].y && board[searchAreaCorners[c].y][searchAreaCorners[c].x].FinalCost!=0 && board[searchAreaCorners[c].y][searchAreaCorners[c].x].FinalCost < searchAreaCorners[c].FinalCost)*/){
                //удаление элемента "c" из searchAreaCorners
                for(int k=c;k<cornersLength-1;k++){
                  searchAreaCorners[k] = searchAreaCorners[k+1];
                }
                c=0;
                cornersLength--;
              }
            }
          }
        }
      }
      
      /*println(cornersLength + " элементов");
      for(int c=0;c<cornersLength;c++){
          println("(" + searchAreaCorners[c].x + ";" + searchAreaCorners[c].y + ") - " + searchAreaCorners[c].mainState);   
      }
      println();
      
      println("удалили " + minn + "\n");
      
      println("\n\n");*/
      
      
      for(int i = 0; i<cornersLength;i++){
        if(searchAreaCorners[i].FinalCost==0 ||  searchAreaCorners[i].mainState=='s' || searchAreaCorners[i].mainState=='t'){
            //min = searchAreaCorners[i].FinalCost;
            print(searchAreaCorners[i].mainState + " (" + searchAreaCorners[i].x + ";" + searchAreaCorners[i].y + ")  ");
            println(min + "\n");
        }  
      }
      
      min = 100000000;
      for(int i = 0; i<cornersLength;i++){
        if(searchAreaCorners[i].FinalCost<min && searchAreaCorners[i].FinalCost!=0 &&  searchAreaCorners[i].mainState!='t'){
            min = searchAreaCorners[i].FinalCost;
            minI = searchAreaCorners[i].x;
            minJ = searchAreaCorners[i].y;
        }  
      }

      for(int i = 0; i<cornersLength;i++){
          if(searchAreaCorners[i].FinalCost == board[minJ][minI].FinalCost && searchAreaCorners[i].DistanceToFinish < min  && searchAreaCorners[i].FinalCost!=0 &&  searchAreaCorners[i].mainState!='t'){
                min = searchAreaCorners[i].DistanceToFinish;
                minI = searchAreaCorners[i].x;
                minJ = searchAreaCorners[i].y;
          }
        
      }
      currentX = minI;
      currentY = minJ;
      
      /*noStroke();
      fill(100);
      rect(currentX*rectDistance,currentY*rectDistance, rectSize + currentX*rectDistance, rectSize + currentY*rectDistance);*/
      
      
      //println("currentX = " + currentX + "\ncurrentY = " + currentY);
      /*print("\n\nboard - ");
      for(int i = 0; i<boardLength;i++){
        for(int j = 0; j<boardHeight;j++){
          if(board[j][i].mainState == 'n' && board[j][i].FinalCost !=0) print("(" + i + ";" + j + ")   ");
        }
      }
      print("\ncorners - ");
      for(int i = 0; i<cornersLength;i++){
        print("(" + searchAreaCorners[i].x + ";" + searchAreaCorners[i].y + ")   ");
      }
      println("\n\n\n");*/
      
    }
    
    void DisplayPath(){
        FinalPathX = currentX;
        FinalPathY = currentY;
        int a, b;
        while(FinalPathX!=startX || FinalPathY!=startY){
          a = board[FinalPathY][FinalPathX].ParentCellX;
          b = board[FinalPathY][FinalPathX].ParentCellY;
          
          line(FinalPathX*rectDistance + rectSize/2, FinalPathY*rectDistance + rectSize/2, a*rectDistance + rectSize/2, b*rectDistance + rectSize/2);
          //rintln("(" + a + ";" + b + ") -> (" + FinalPathX + ";" + FinalPathY + ")");
          FinalPathX = a;
          FinalPathY = b;
          //board[FinalPathY][FinalPathX].mainState = 'p';
        }
        //println("shit");
    }
    
};

PathFinding Finder = new PathFinding(10, 0, 1900, 1000);
void setup(){
  size(1900, 1000);
  //Finder.GenerateRandBoard(1.3);
  Finder.GenerateMaze();
  Finder.ShowBoard();
}


void draw(){
  frameRate(200);
  if(key == 'w'||key == 's'||key == 'f'||key == 'n'){
    Finder.ShowBoard();
    Finder.SetCells();
  }
  if(key == ' '){
    if(!Finder.EndCondition()){
      Finder.FindPath();
      stroke(0);
      strokeWeight(2);
      //Finder.DisplayPath();
    }
    else{
      stroke(0,0,255);
      strokeWeight(3);
      //Finder.ShowBoard();
      Finder.DisplayPath();
    }
  }
  
}
void keyPressed(){
  Finder.SetCells();
}
