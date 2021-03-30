class Mouse{
  public
  boolean mouseState;
  private
  Mouse(){
    mouseState = false;
  }
  boolean clicked(){
    if(mousePressed && !mouseState){
      mouseState = true;
      return true;
    }
    mouseState = mousePressed;
    return false;
  }
};
