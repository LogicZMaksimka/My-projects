class Stack{
  private
    int maxSize;
    mazeCell []stackArray;
    int top;
  public
    Stack(int mSize){
      maxSize = mSize;
      stackArray = new mazeCell[maxSize];
      top = -1;
    }
    void addElement(mazeCell element){
      top++;
      stackArray[top] = element;
    }
    void deleteElement(){
      top--;
    }
    int size(){
      return top;
    }
    mazeCell readTop(){
      return stackArray[top];
    }
    boolean isEmpty(){
      return (top == -1);
    }
    boolean isFull(){
      return (top == maxSize-1);
    }
}
