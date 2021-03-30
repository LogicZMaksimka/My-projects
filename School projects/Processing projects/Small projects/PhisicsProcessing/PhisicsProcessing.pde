PVector location;  // Location of shape
PVector velocity;  // Velocity of shape
PVector gravity;   // Gravity acts at the shape's acceleration

float xSpeed = 10;
float ySpeed = 0;
float g = 0.7;
int r = 48;

void setup(){
  size(1200,700);
  stroke(255);
  location = new PVector(width/2, height/2);
  velocity = new PVector(xSpeed, ySpeed);
  gravity = new PVector(0, g);
  
  
}

  

void draw(){
  
  //background(0);
  
  // Add velocity to the location.
  location.add(velocity);
  // Add gravity to velocity
  //velocity.add(gravity);
  
  // Bounce off edges
  if ((location.x > width) || (location.x < 0)) {
    velocity.x = velocity.x * -1;
  }
  velocity.x = (location.x - mouseX)*-0.1;
  if ((location.y > height)|| (location.y < 0)) {
    // We're reducing velocity ever so slightly 
    // when it hits the bottom of the window
    velocity.y = velocity.y * -0.95; 
    //location.y = height;
  }
  velocity.y = (location.y - mouseY)*-0.1;
  
  
  // Display circle at location vector
    
  point(mouseX-100, mouseY);
  strokeWeight(2);
  fill(127);
  ellipse(location.x,location.y,r,r);
  }
