

class DNA{
    //int fitness;
    int genLength;
    char genes[];
    //String genes;
  public
    DNA(int genLen){
      genLength = genLen;
      genes = new char[genLength];
      for(int i=0;i<genLength;i++){
        genes[i] = char(floor(random(32, 128)));
      }
    }
    double fitness(String aimStroke){
      int score=0;
      for(int i=0;i<genLength;i++){
        if(genes[i] == aimStroke.charAt(i)){
          score++;
        }
      }
      return score/genLength;//возвращает процент совпадения
    }
    void crossover(char[] parentA, char[] parentB/*String parentA, String parentB*/){//перемешиваем родительские гены
      int midpoint = floor(random(genLength));
      //parentA.getChars(0, midpoint, genes, 0);//
      //parentB.getChars(midpoint, aimStroke.length()-1, genes, midpoint);
      for(int i=0;i<genLength;i++){
        if(i<midpoint) genes[i] = parentA[i];
        else genes[i] = parentB[i];
      }
    }
    void mutation(float mutationRate){
      for(int i=0;i<genLength;i++){
        if(random(1)<mutationRate){
          genes[i] = char(floor(random(32, 128)));
        }
      }
    }
    void displayGen(){
      for(int i=0;i<genLength;i++){
        print(genes[i]);
      }
    }
    /*boolean endCondition(String aimStroke){
      boolean state = false;
      for(int i=0;i<genLength;i++){
        if(genes[i]!=aimStroke.charAt(i)){
          state = true;
          break;
        }
      }
      return state;
    }*/
    char[] getGen(){
      return genes;//блин проверь это, что-то стрёмно
    }
};


class Population{
  DNA[] target;
  
  String aimStroke = new String("to be or not to be");
  //char[] aimStrokeMass;//костыли как смысл жизни//я исправил
  
  int popLength = 200;
  
  float mutationRate=0.01;
  
  //int length = aimStroke.length();
  
  char[] parentA, parentB;
  
  public
    Population(){
      //aimStroke.getChars(0, aimStroke.length(), aimStrokeMass, 0);//проверить нормально ли осуществляется копирование
      target = new DNA[200];
      parentA = new char[aimStroke.length()];
      parentB = new char[aimStroke.length()];
      //создание и инициальзация популяции
      for(int i=0;i<aimStroke.length();i++){
        target[i] = new DNA(aimStroke.length());
      }
    }
  void generatePopulation(){
    chooseParents();
    for(int i=0;i<popLength;i++){
        target[i].crossover(parentA, parentB);
        target[i].mutation(mutationRate);
    }
  }
  
  void showPopulation(){
    for(int i=0;i<popLength;i++){
      target[i].displayGen();
      println();
    }
  }
  boolean endCondition(){
    for(int i=0;i<popLength;i++){
      if(target[i].fitness(aimStroke)==1.0){
        return true;
      }
    }
    return false;
  }
  void chooseParents(){
    int n=100;//максимальное количество повторяющихся номеров
    int counter = 0;
    int parents[] = new int[n*popLength];
    for(int i = 0; i<popLength;i++){
      for(int j=0;j<n*target[i].fitness(aimStroke);j++){
        parents[counter] = i;//заполнение массива для выбора родителей с учётом вероятности
        counter++;
      }
    }
    parentA = target[parents[(int)(Math.random()*counter)]].getGen();
    parentB = target[parents[(int)(Math.random()*counter)]].getGen(); 
    counter=0;//это бессмысленно, но так легче на душе, ПОНИМАЕТЕ?!
  }
};

void setup(){
  Population search = new Population();
  while(!search.endCondition()){
    search.generatePopulation();
    search.showPopulation();
  }
  
}
