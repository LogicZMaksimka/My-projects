class mazeCell{
  public int state;//0 - wall; 1 - not tested; 2 - tested
  public int x, y;
  public mazeCell(int st, int sx, int sy){
    state = st;
    x = sx;
    y = sy;
  }
}
