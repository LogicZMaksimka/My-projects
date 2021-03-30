Target target1 = new Target(width/2, height/2, color(0, 255, 0));
Agent[] agent = new Agent[10000];
Target[] target = new Target[10000];
int agentsCount = 0, targetsCount = 0;
FlowField flow1 = new FlowField(20);
Road road1 = new Road(20);
Scrollbar avCr, fGr, fR;
Obstackle obst1 = new Obstackle();

void setup(){
  //size(600, 600);
  fullScreen();
  ellipseMode(RADIUS);
  rectMode(CORNERS);
  avCr = new Scrollbar(100, 0, 180, 20, 20);
  fGr = new Scrollbar(100, 30, 180, 50, 20);
  fR = new Scrollbar(100, 60, 180, 80, 20);
}

void draw(){
  background(200);
  fill(0);
  text("avoid crush", 10, 13);
  avCr.update();
  avCr.display();
  text("form group", 10, 43);
  fGr.update();
  fGr.display();
  text("follow road", 10, 73);
  fR.update();
  fR.display();
  
  //доделать добавление нового объекта, когда предыдущая фигура смыкается (т.е. её дорисовали)
  if(key == 'o') obst1.createObstackle();
  obst1.displayObstackle();
  if(key == 's') obst1.drawShadow(new PVector(mouseX, mouseY));
  
  if(key == 'r' && mousePressed) road1.createRoad();
  road1.drawRoad();
  
  //target1.drawTarget();
  //target1.SetTarget();
  
  
  //flow1.setMouseVelocity();
  //flow1.drawFlowField();
  
  for(int i=0;i<agentsCount;++i){
    agent[i].updateAgent();
    //agent[i].drawAgentParameters();
    agent[i].drawBeautifulArrowlikeAgent();
    agent[i].avoidCrush(agent, agentsCount, avCr.getPos());
    //agent[i].avoidCrush(target, targetsCount, 2);
    agent[i].followTarget(road1, fR.getPos());
   // agent[i].followTarget(target1.getCoord(), 2);
    agent[i].formGroup(agent, agentsCount, fGr.getPos());
  }
  for(int i=0;i<targetsCount;++i){
    target[i].drawTarget();
  }
  
}

void mouseDragged(){
  if(key == 'a'){
    agent[agentsCount] = new Agent(mouseX, mouseY, 5, 0.7);
    ++agentsCount;
  }
  /*if(key == 't'){
    target[targetsCount] = new Target(mouseX, mouseY, color(255, 0, 0, 180));
    ++targetsCount;
  }*/
}
