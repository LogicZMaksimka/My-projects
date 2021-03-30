class Target{
  private
  PVector coord;
  color targetColor;
  public
  Target(int x, int y, color color_){
    coord = new PVector(x, y);
    targetColor = color_;
  }
  void drawTarget(){
    stroke(targetColor);
    fill(targetColor);
    ellipse(coord.x, coord.y, 10, 10);
  }
  void SetTarget(){
    if((key == 't') && mousePressed){
      if((0 <= mouseX) && (mouseX <= width) && (0 <= mouseY) &&(mouseY <= height)){
        coord = new PVector(mouseX, mouseY);
      }
    }
  }
  PVector getCoord(){
    return coord.copy();
  }
};
