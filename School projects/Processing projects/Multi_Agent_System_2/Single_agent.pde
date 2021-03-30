class Agent{
  private
  PVector coord;//координаты
  PVector velocity;//скорость
  PVector resultForce;//результирующая сила
  float maxSpeed;//максимальная скорость перемещения
  float maxSteerForce;//максимальная сила, действующая в направлении цели
  float maxForce;//максимальная результирующая сила
  float futurePosLen;
  float visionRadius;
  PVector futureCoord(PVector pos, PVector vel){
    vel.setMag(map(vel.mag(), 0, maxSpeed, 0, futurePosLen));
    return PVector.add(pos, vel);
  }
  public
  Agent(int x, int y, float maxSpeed_, float maxSteerForce_){
    coord = new PVector(x, y);
    velocity = PVector.random2D().setMag(maxSpeed_);
    resultForce = new PVector(0, 0);
    maxSpeed = maxSpeed_;
    maxSteerForce = maxSteerForce_;
    futurePosLen = 40;
    visionRadius = 30;
  }
  
  void followTarget(PVector targetCoord, float multiplier){//движение к неподвижной цели    
    PVector desiredVelocity = PVector.sub(targetCoord, coord);//вектор скорости с которым нужно двигаться
    if(desiredVelocity.mag() > 100){//торможение
      desiredVelocity.setMag(maxSpeed);
    }
    else{
      desiredVelocity.setMag(map(desiredVelocity.mag(), 0, 100, 0, maxSpeed));
    }
    PVector FollowTargetForce = PVector.sub(desiredVelocity, velocity);
    FollowTargetForce.limit(maxSteerForce);
    FollowTargetForce.mult(multiplier);
    resultForce.add(FollowTargetForce);
  }
  void followTarget(PVector targetCoord, PVector targetVelocity, float multiplier){//следование за подвижной целью
    followTarget(futureCoord(targetCoord, targetVelocity), multiplier);
  }
  void followTarget(FlowField flow, float multiplier){
    PVector desiredVelocity = flow.getCellVelocity(coord);//вектор скорости с которым нужно двигаться; в параметре функции передаётся будущее положение объекта для лучшего управления
    desiredVelocity.setMag(maxSpeed);
    PVector FollowTargetForce = PVector.sub(desiredVelocity, velocity);
    FollowTargetForce.limit(maxSteerForce);
    FollowTargetForce.mult(multiplier);
    resultForce.add(FollowTargetForce);
  }
  void followTarget(Road road, float multiplier){//движение вдоль дороги    //добавить несколько точек, которые буду находиться слева и справа от будущего положения, чтобы улучшить прохождение повопротов
    PVector projection = road.projectToRoad(futureCoord(coord.copy(), velocity.copy()));
    if(road.haveProjection(coord)){
      PVector desiredVelocity;
      if(PVector.dist(projection, futureCoord(coord.copy(), velocity.copy())) > (road.getRoadWidth()/2)){
        desiredVelocity = PVector.sub(projection, coord).setMag(maxSpeed);
      }
      else{
        desiredVelocity = velocity.copy();
        desiredVelocity.setMag(maxSpeed);
      }
      PVector FollowTargetForce = PVector.sub(desiredVelocity, velocity);
      FollowTargetForce.limit(maxSteerForce);
      FollowTargetForce.mult(multiplier);
      resultForce.add(FollowTargetForce);
    }
  }
  void avoidCrush(Agent[] agent, int targetCount, float multiplier){//избегать столкновения с другими агентами
    int visibleAgentsCount = 0;
    PVector desiredVelocity = new PVector(0, 0);
    for(int i=0;i<targetCount;++i){
      float agentDist = PVector.dist(coord, agent[i].getCoord());
      if((agentDist > 0) && (agentDist <= visionRadius)){//>0 чтобы не проверять свои же координаты
        PVector dir = PVector.sub(coord, agent[i].getCoord());
        dir.normalize();
        dir.div((agentDist-20)*(agentDist-20));//могут врзникнуть проблемы из-за деления на 0
        desiredVelocity.add(dir);
         ++visibleAgentsCount;
      }
    }
    if(visibleAgentsCount > 0){
      desiredVelocity.div(visibleAgentsCount);
      desiredVelocity.setMag(maxSpeed);
      PVector FollowTargetForce = PVector.sub(desiredVelocity, velocity);
      FollowTargetForce.limit(maxSteerForce);
      FollowTargetForce.mult(multiplier);
      resultForce.add(FollowTargetForce);
    }
  }
  void avoidCrush(Target[] target, int targetsCount, float multiplier){
    int visibleAgentsCount = 0;
    PVector desiredVelocity = new PVector(0, 0);
    for(int i=0;i<targetsCount;++i){
      float targetDist = PVector.dist(coord, target[i].getCoord());
      if((targetDist > 0) && (targetDist <= visionRadius)){//>0 чтобы не проверять свои же координаты
        PVector dir = PVector.sub(coord, target[i].getCoord());
        dir.normalize();
        dir.div((targetDist-20)*(targetDist-20));//могут врзникнуть проблемы из-за деления на 0
        desiredVelocity.add(dir);
         ++visibleAgentsCount;
      }
    }
    if(visibleAgentsCount > 0){
      desiredVelocity.div(visibleAgentsCount);
      desiredVelocity.setMag(maxSpeed);
      PVector FollowTargetForce = PVector.sub(desiredVelocity, velocity);
      FollowTargetForce.limit(maxSteerForce);
      FollowTargetForce.mult(multiplier);
      resultForce.add(FollowTargetForce);
    }
  }
  
  void formGroup(Agent[] agent, int agentsCount, float multiplier){//формирование групп
    int visibleAgentsCount = 0;
    PVector desiredVelocity = new PVector(0, 0);
    PVector FollowTargetForce = new PVector(0, 0);
    for(int i=0;i<agentsCount;++i){
      float agentDist = PVector.dist(coord, agent[i].getCoord());
      if((agentDist > 0) && (agentDist <= visionRadius)){//>0 чтобы не проверять свои же координаты
         desiredVelocity.add(agent[i].getVelocity());
         ++visibleAgentsCount;
      }
    }
    if(visibleAgentsCount > 0){
      desiredVelocity.div(visibleAgentsCount);
      desiredVelocity.setMag(maxSpeed);
      FollowTargetForce = PVector.sub(desiredVelocity, velocity);
      FollowTargetForce.limit(maxSteerForce);
      FollowTargetForce.mult(multiplier);
      resultForce.add(FollowTargetForce);
    }
  }
  
  PVector getCoord(){
    return coord.copy();
  }
  PVector getVelocity(){
    return velocity.copy();
  }
  PVector getFutureCoord(){
    return futureCoord(coord.copy(), velocity.copy());
  }
  void updateAgent(){
    
    //хрень переписать
    //граница (futurePosLen + maxSpeed) нужна, чтобы никогда не выходить за границы массива
    if(coord.x < (futurePosLen + maxSpeed)) coord.x = width - (futurePosLen + maxSpeed);
    if(coord.x > (width-(futurePosLen + maxSpeed))) coord.x = (futurePosLen + maxSpeed);
    if(coord.y < (futurePosLen + maxSpeed)) coord.y = height - (futurePosLen + maxSpeed);
    if(coord.y > (height-(futurePosLen + maxSpeed))) coord.y = (futurePosLen + maxSpeed);
    
    //отрисовка границ
    /*stroke(255, 0, 0);
    strokeWeight(5);
    noFill();
    rect((futurePosLen + maxSpeed), (futurePosLen + maxSpeed), width - (futurePosLen + maxSpeed), height - (futurePosLen + maxSpeed));
    strokeWeight(1);*/
   
    /*if(coord.x < 0) coord.x= width;
    if(coord.x > width) coord.x = 0;
    if(coord.y < 0) coord.y = height;
    if(coord.y > height) coord.y = 0;  */  
    
    resultForce.limit(maxSteerForce);
    velocity.add(resultForce);
    //velocity.setMag(maxSpeed);
    velocity.limit(maxSpeed);
    coord.add(velocity);
    resultForce.mult(0);
  }
  
  void drawBeautifulArrowlikeAgent(){
    float angle = PVector.angleBetween(velocity, new PVector(0, 1));
    if(PVector.add(coord, velocity).x > coord.x) angle = -angle;
    pushMatrix();
    translate(coord.x, coord.y);
    rotate(angle);
    stroke(0);
    fill(70);
    triangle(-5, -5, 5, -5, 0, 10);
    popMatrix(); 
  }
  
  void drawAgentParameters(){//не работает как нужно
    float maxArrowLen = 50;
    
    //тело объекта
    noStroke();
    fill(0, 0, 255, 150);
    ellipse(coord.x, coord.y, 20, 20);
    
    //будущее положение объекта
    stroke(120);
    fill(150);
    ellipse(futureCoord(coord.copy(), velocity.copy()).x, futureCoord(coord.copy(), velocity.copy()).y, 4, 4);
    
    //стрелка силы - красная
    PVector resultForceDir = resultForce.copy();
    resultForceDir.setMag(maxArrowLen/2);
    PVector forceCoord = coord.copy();
    forceCoord.add(resultForceDir);
    stroke(255, 0, 0);
    line(coord.x, coord.y, forceCoord.x, forceCoord.y);
    
    
    //стрелка скорости - зелёная
    PVector velocityDir = velocity.copy();
    velocityDir.setMag(map(velocity.mag(), 0, maxSpeed, 0, maxArrowLen));
    PVector velCoord = coord.copy();
    velCoord.add(velocityDir);
    stroke(0, 255, 0);
    line(coord.x, coord.y, velCoord.x, velCoord.y);
  }
};
