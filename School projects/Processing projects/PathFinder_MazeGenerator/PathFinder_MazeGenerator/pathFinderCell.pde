class pathFinderCell{
  public
    char mainState;//'w' - wall, 'n' - not visited, 't' - visited, 's' - start, 'f' - finish
    int x, y;
    int DistanceToFinish;
    int DistanceToStart;
    int FinalCost;
    int ParentCellX, ParentCellY;
    pathFinderCell(char MS, int SX, int SY){
      mainState = MS;
      x = SX;
      y = SY;
      DistanceToFinish = 0;
      DistanceToStart = 0;
      FinalCost = 0;
      ParentCellX = -1;
      ParentCellY = -1;
    }
};
