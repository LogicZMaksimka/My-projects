Obstackle[] obst = new Obstackle[1000];
Render light;
Ray[] ray = new Ray[1000];
PVector player;
int obstacklesCount = 0;
int raysCount = 500;
void setup(){
  size(1200, 600);
  //fullScreen();
  ellipseMode(RADIUS);
  rectMode(CORNERS);
  for(int i = 0; i < 1000; ++i){
    obst[i] = new Obstackle();
  }
  player = new PVector(width/4, height/2);
}
void draw(){
  background(0);
  if(keyPressed){
    if (keyCode == UP) player.y -= 5;
    if (keyCode == DOWN) player.y += 5;
    if (keyCode == RIGHT) player.x += 5;
    if (keyCode == LEFT) player.x -= 5;
  }
  
  //создание фигур
  if(key == 'o') obst[obstacklesCount].createObstackle();
  if(obst[obstacklesCount].endFigure()){
    ++obstacklesCount;
    delay(150);
  }
  for(int i = 0; i <= obstacklesCount; ++i){
    obst[i].displayObstackle();
  }
  
  //обновление лучей
  PVector dir = PVector.sub(new PVector(mouseX, mouseY), player);//направление камеры
  float mouseAngle = PVector.angleBetween(dir, new PVector(1, 0));
  if(mouseY > player.y) mouseAngle *= -1;
  float angle1 = mouseAngle - radians(20), angle2 = mouseAngle + radians(20);
  //ось направлена по часовой стрелке
  angle1 *= -1;
  angle2 *= -1;
  float angle = min(angle1, angle2);
  for(int i=0;i<raysCount;++i){
    PVector rayDirection = new PVector(cos(angle), sin(angle));
    ray[i] = new Ray(player, rayDirection);
    angle += abs(angle1 - angle2)/raysCount;
  }
  noStroke();
  fill(255, 0, 0);
  ellipse(player.x, player.y, 10, 10);
  //отображение света
  light = new Render(ray, raysCount, obst, obstacklesCount, dir);
  //light.displayRoundLighting(new PVector(mouseX, mouseY), 500, 50);//работает только для выпуклых многоугольников
  light.displayRays();
  light.renderObstackles();
}
