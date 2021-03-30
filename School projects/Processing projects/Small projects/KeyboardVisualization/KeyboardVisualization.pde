PVector location;
PVector velocity;
PVector acceleration;
PFont letter;
float rotation_angle;

void setup() {
  size(1200, 900);
  location = new PVector(random(width/2 - 50,width/2 + 50), height);
  velocity = new PVector(random(-6, 6), random(-21, -14));//-10  -18
  acceleration = new PVector(0, 0.3);
  letter = createFont("Arial",70,true);
  rotation_angle = 0;
}

void draw() {
  //delay(100);
  background(255);
  textFont(letter);
  textAlign(LEFT);
  fill(155, 65, 78);
  translate(location.x, location.y);  // Translate to the center
  rotate(rotation_angle);
  text("T", 0, 0);
  rotation_angle += PI/16;
  /*textFont(letter);
  textAlign(CENTER);
  fill(0);
  translate(width/2, height/2);  // Translate to the center
  rotate(rotation_angle);
  text("T", 0, 0);
  rotation_angle += PI/16;*/
  
  // Add the current speed to the location.
  location.add(velocity);
  velocity.add(acceleration);
  
  if ((location.x >= width) || (location.x <= 0)) {
    velocity.x = velocity.x * -1;
  }
  if (location.y >= height) {
    location = new PVector(random(width/2 - 50,width/2 + 50), height);
    velocity = new PVector(random(-5, 5), random(-18, -13));//-10  -18
  }
}
