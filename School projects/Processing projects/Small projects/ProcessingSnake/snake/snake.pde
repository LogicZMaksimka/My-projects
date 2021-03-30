//Змейка версия 1.2
//баг с одновременным нажатием на as sd wd aw - разворот на месте т.е. проигрыш
//если не работает управление (wasd), надо кликнуть мышкой
//кривая регулировка скорости
//кривая установка яблока
//если раскомментировать строки 79-82, закомментировать строки 56, 84-98, 112 и выставить размер клетки на 30 - будет весело


class Snake{
  int distanceBetweenRects, rectSize;
  boolean gameEnded;
  int sectionsCount, sectionNum;
  int x, y;
  char direction;
  int lastX, lastY;
  int appleX, appleY, appleCount; 
  int screenLength,  screenWight;
  int snakePartCoordinates[][];
public
  Snake(int rectSize1, int distanceBetweenRects1, int startX, int startY, int screenLength1, int screenWight1, int startSnakeLength){
    
    //размер клеки змейки, расстояние между клетками,  начальное положение змейки (X;Y), размер экрана (X;Y), начальная длина змейки
    
    rectSize = rectSize1;
    distanceBetweenRects = distanceBetweenRects1;
    appleCount = startSnakeLength+1;
    x = startX-startX % (2*rectSize+distanceBetweenRects);//форматирование начальных координат
    y = startY-startY % (2*rectSize+distanceBetweenRects);
    gameEnded = false;
    screenLength = screenLength1;
    screenWight = screenWight1;
    lastX = x;
    lastY = y-(2*rectSize+distanceBetweenRects);
    snakePartCoordinates = new int [5000][2];
    snakePartCoordinates[0][0]=x;
    snakePartCoordinates[0][1]=y;
    for(int i=1;i<appleCount;i++){
      snakePartCoordinates[i][0]=-1;
      snakePartCoordinates[i][1]=-1;
    }
    
  }
  void SetApple(){//установка яблока (кривая, яблоко может появиться в змейке)
      fill(255, 0, 0);
      appleX = (1 + (int) (Math.random() * (screenLength/(2*rectSize+distanceBetweenRects)-1)))*(2*rectSize+distanceBetweenRects);
      appleY = (1 + (int) (Math.random() * (screenWight/(2*rectSize+distanceBetweenRects)-1)))*(2*rectSize+distanceBetweenRects);
      ellipse(appleX, appleY,rectSize*1.7, rectSize*1.7);
  }
  
  void StopGame(){
    gameEnded=true;
  }
  
  boolean DetectApple(){//обнаружение яблока
    if(x==appleX&&y==appleY){
      appleCount++;
      return true; 
    }
    return false;
  }
  
  int GetPoints(){return appleCount;}//очки за игру
  
  boolean LoseCondition(){//условие проигрыша
    for(int i = 1; i<appleCount; i++){
      if(snakePartCoordinates[0][0]==snakePartCoordinates[i][0]&&snakePartCoordinates[0][1]==snakePartCoordinates[i][1]){
        return true;
      }
    }
    if(x<=0||x>=screenLength||y<=0||y>=screenWight) return true;
    return false;
  }
  
  
  void DrawSnake(char direction){//отрисовка змейки
    if(!gameEnded){
      rectMode(CORNERS);
      
      /*if(x<appleX) x+=(2*rectSize+distanceBetweenRects);
      else if(x>appleX)  x-=(2*rectSize+distanceBetweenRects);
      if(y<appleY) y+=(2*rectSize+distanceBetweenRects);
      else if(y>appleY) y-=(2*rectSize+distanceBetweenRects);*/
      
      switch (direction)//направление движения
      {
         case 'w':
           y-=(2*rectSize+distanceBetweenRects);
           break;
         case 's':
           y+=(2*rectSize+distanceBetweenRects);
           break;
         case 'a':
           x-=(2*rectSize+distanceBetweenRects);
           break;
         case 'd':
           x+=(2*rectSize+distanceBetweenRects);
           break;
      }
      
      for(int i = appleCount; i>0; i--){//смещение координаты каждой клетки вправо на 1 клетку
        snakePartCoordinates[i][0]=snakePartCoordinates[i-1][0];
        snakePartCoordinates[i][1]=snakePartCoordinates[i-1][1];
      }
      snakePartCoordinates[0][0]=x;//обновление координат первой клетки
      snakePartCoordinates[0][1]=y;
      lastX = snakePartCoordinates[appleCount-1][0];
      lastY = snakePartCoordinates[appleCount-1][1];
      fill(int(x/4.4),int(y/2.7), 105);
      rect(x - rectSize, y - rectSize, x + rectSize, y + rectSize);//отрисовка первой клетки змейки
      fill(0);
      rect(lastX - rectSize, lastY - rectSize, lastX + rectSize, lastY + rectSize);//стрирание хвоста
      
    }
  }
};



Snake FirstSnake = new Snake(10, 1, 600, 300, 1122, 680, 3);
void setup(){
  size(1122, 680);
  noStroke();
  background(0);
  FirstSnake.SetApple();
}

char direction='s';
void draw(){
  //отрисовываются только начало и стирается конец, поэтому обновления экрана НЕ нужно
  if(FirstSnake.DetectApple()) FirstSnake.SetApple();
  
  FirstSnake.DrawSnake(direction);
  
  delay(100);//регулировки скорости змейки
  
  if(FirstSnake.LoseCondition()){
      FirstSnake.StopGame();
      fill(255, 0, 0);
      textSize(48);
      text("YOU LOSE", 450, 350);
      textSize(32);
      text("Points:"+FirstSnake.GetPoints(), 500, 400);
  }
}

void keyPressed(){
  if(direction=='w'&&key!='s'||direction=='s'&&key!='w'||direction=='a'&&key!='d'||direction=='d'&&key!='a'){
        direction = key;
    }
}
