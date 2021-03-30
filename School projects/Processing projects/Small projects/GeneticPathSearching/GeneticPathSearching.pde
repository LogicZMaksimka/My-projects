int FX = 1200;
int FY = 700/2;
float maxDistance = FX + FY;

class DNA{
  private
    PVector[] path;
    PVector location;
    PVector direction;
    float velocity;
    int genLength;
    int timeAlive;//timeAlive<=genlength
    int move;
  public
    DNA(float speed, int maxPathLength){
      genLength = maxPathLength;
      velocity = speed;
      move = 1;
      timeAlive = 0;
      location = new PVector(width/2, height/2);
      direction = new PVector(0, 0);
      path  = new PVector[genLength];
      for(int i=0; i<genLength;i++){
        path[i] = PVector.random2D();
      }
    }
    
    float fitness(){
      float distance = abs(location.x - FX) + abs(location.y - FY);
      float fit = (maxDistance-distance)/maxDistance + timeAlive/genLength;
      return pow(fit, 3);//возвращает процент совпадения
    }

    void crossover(PVector[] parentA, PVector[] parentB/*String parentA, String parentB*/){//перемешиваем родительские гены
      int midpoint = floor(random(genLength));
      //parentA.getChars(0, midpoint, genes, 0);//
      //parentB.getChars(midpoint, aimStroke.length()-1, genes, midpoint);
      for(int i=0;i<genLength;i++){
        if(i<midpoint) path[i] = parentA[i];
        else path[i] = parentB[i];
      }
    }
    void mutation(double mutationRate){
      for(int i=0;i<genLength;i++){
        if(random(1)<mutationRate){
          path[i] = PVector.random2D();
        }
      }
    }
    void displayGen(){
      //fill(random(255), random(255), random(255));
      fill(255);
      ellipse(location.x, location.y, 10, 10);
      fill(255, 0, 0);
      text(floor(fitness()*100) + "%", location.x-10, location.y+15);
    }
    void updateGen(){
      if(move!=0) timeAlive++;
      PVector dir = path[timeAlive];
      dir.setMag(velocity*move);
      location.add(dir);
      
      
    }
    
    PVector[] getGen(){
      return path;//блин проверь это, что-то стрёмно
    }
};


class Population{
private
  DNA[] target;
  
  PVector polygons[][];
  
  int popLength;
  
  int polygonNum;
  
  double mutationRate;
  
  boolean k;
  
  int genlength;
  
  int time;
  
  float speed;
  
  PVector[] parentA, parentB;
  
public
    Population(){
      k = true;
      polygonNum=0;
      time=0;
      popLength = 500;
      mutationRate = 0.1;
      genlength = 100;
      speed = 7;//0-10
      polygons = new PVector[500][2];
      for(int i = 0;i<500;i++){
        polygons[i][0] = new PVector(0, 0);
        polygons[i][1] = new PVector(0, 0);
      }
      target = new DNA[popLength];
      //создание и инициальзация популяции
      for(int i=0;i<popLength;i++){
        target[i] = new DNA(speed, genlength);
      }
      parentA = new PVector[genlength];
      parentB = new PVector[genlength];
      
    }
  void updatePopulation(){
    //println("maxDistance = " + maxDistance);
    for(int i=0;i<popLength;i++){
      target[i].updateGen();
    }
    time++;
  }
  void generatePopulation(){
      println("shit");
      time = 0;
      for(int i=0;i<popLength;i++){
          target[i].move = 1;
          target[i].timeAlive = 0;
          target[i].location.x = width/2;
          target[i].location.y = height/2;
          parentA = target[chooseParents()].getGen();
          parentB = target[chooseParents()].getGen();
          target[i].crossover(parentA, parentB);
          //target[i].path = target[chooseParents()].getGen();
          target[i].mutation(mutationRate);
      }
    
  }
  
  void intersection(){
    for(int i=0;i<popLength;i++){
      for(int j=0;j<polygonNum;j++){
        if(target[i].location.x<=max(polygons[j][0].x, polygons[j][1].x)&&target[i].location.x>=min(polygons[j][0].x, polygons[j][1].x)&&target[i].location.y<=max(polygons[j][0].y, polygons[j][1].y)&&target[i].location.y>=min(polygons[j][0].y, polygons[j][1].y)){
          target[i].move = 0;
        }
      }
    }
  }

  void drawPolygon(){
    if(mousePressed&&mouseButton==LEFT&&k){
      polygons[polygonNum][0].x=mouseX;
      polygons[polygonNum][0].y=mouseY;
      k=!k;
    }
    if(mousePressed&&mouseButton==RIGHT&&!k){
      polygons[polygonNum][1].x=mouseX;
      polygons[polygonNum][1].y=mouseY;
      k=!k;
    }
    println("кол-во прямоугольников = " + polygonNum);
    println(polygons[polygonNum][0].x + "  " + polygons[polygonNum][0].y + "  " + polygons[polygonNum][1].x + "  " + polygons[polygonNum][1].y);
      //delay(1000);
    fill(255);
    rectMode(CORNERS);
    for(int i=0;i<polygonNum+1;i++){
      if((polygons[i][0].x * polygons[i][0].y * polygons[i][1].x * polygons[i][1].y)!=0){
        rect(polygons[i][0].x, polygons[i][0].y, polygons[i][1].x, polygons[i][1].y);
      } 
    }
    if((polygons[polygonNum][0].x * polygons[polygonNum][0].y * polygons[polygonNum][1].x * polygons[polygonNum][1].y)!=0){
      polygonNum++;
      
      polygons[polygonNum][0].x=0;
      polygons[polygonNum][0].y=0;
      polygons[polygonNum][1].x=0;
      polygons[polygonNum][1].y=0;
    }
  }
  
  void showPopulation(){
    background(0);
    for(int i=0;i<popLength;i++){
      //print(i + " = ");
      target[i].displayGen();
      //println(i + " - unicorn");
    }
  }
  
  void bestGen(){
    float maxFitness = 0;
    int maxi = 0;
    for(int i = 0; i<popLength;i++){
      if(maxFitness<target[i].fitness()){
        maxFitness = target[i].fitness();
        maxi = i;
      }
    }
    //println(target[maxi].fitness());
  }
  
  boolean popEndCondition(){
    /*for(int i=0;i<popLength;i++){
      if(target[i].fitness()==1.0){
        return true;
      }
    }
    return false;*/
    if(time+1>=genlength) return true;
    return false;
  }
  
  int chooseParents(){
    float maxFitness = 0;
    int maxi = 0;
    for(int i = 0; i<popLength;i++){
      if(maxFitness<target[i].fitness()){
        maxFitness = target[i].fitness();
        maxi = i;
      }
    }
    while(true){
      int randGen = floor(random(popLength));
      float r = random(maxFitness);
      if(r < target[randGen].fitness()||maxFitness==0.0){
        return randGen;
      }
      
    }
    //return maxi;
  }
};
Population search;
void setup(){
  size(1200, 700);
  stroke(255);
  search = new Population();
  rectMode(CORNERS);
  //println("generation " + c);
}
void draw(){
  background(0);
  search.drawPolygon();
  if(key == ' '){
    search.intersection();
    
    search.updatePopulation();
    if(search.popEndCondition()) search.generatePopulation();
    search.showPopulation();
    search.bestGen();
    search.drawPolygon();
  }
}
