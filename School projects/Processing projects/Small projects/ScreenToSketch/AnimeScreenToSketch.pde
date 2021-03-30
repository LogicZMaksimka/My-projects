import processing.video.*;

float[][] transformationMatrix = {
   /*
   {1, 1, 1},
   {1, 1, 1},
   {1, 1, 1},
   */
   
   /*
   {-1, -1, -1},
   {-1,  9, -1},
   {-1, -1, -1},
   */
   
   /*
   {1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1},
   */
   
   /*
   {-1, -1, -1, -1, -1},
   {-1, -1, -1, -1, -1},
   {-1, -1, 25, -1, -1},
   {-1, -1, -1, -1, -1},
   {-1, -1, -1, -1, -1},
   */
   
   /*
   {-2, -2, -2, -2, -2},
   {-2, -1, -1, -1, -2},
   {-2, -1, 41, -1, -2},
   {-2, -1, -1, -1, -2},
   {-2, -2, -2, -2, -2},
   */
   
   /*
   {1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1},
   {1, 1, 1, 1, 1, 1, 1},
   */
   
   {2,  4,  5,  4, 2},
   {4,  9, 12,  9, 4},
   {5, 12, 15, 12, 5},
   {4,  9, 12,  9, 4},
   {2,  4,  5,  4, 2},
};




int darkCoefficient = 0;
float lowerLimit,  upperLimit;

String loadFileName = "forest.jpg";
String saveFileName = "1.0.png";

PImage loadImg, transformedImage;
Capture webcam, transformedVideo;

ImageFilter img;
VideoFilter video;

void setup(){
  size(1280, 720);
  
  loadImg = loadImage(loadFileName);
  img = new ImageFilter(loadImg);
  
  
  webcam = new Capture(this, 1280, 720);
  video = new VideoFilter(webcam);
  
  
  /*
  image(loadImg, 0, 0, width/2, height);
  stroke(255, 0, 0);
  line(0, 0, height, height);
  img.multiplyImageByMatrix(transformationMatrix, 5);
  */
}

void draw(){
  //transformedImage = img.getImageSketch(mouseX, mouseY);
  //image(transformedImage, width/2, 0, width/2, height);
  transformedVideo = video.getDarkestColor(darkCoefficient);
  image(transformedVideo, 0, 0);
}

void keyPressed(){
  print(darkCoefficient + "\n");
  //if(key == 's')  saveFrame(saveFileName);
  if (key == CODED){
    if(keyCode == UP) darkCoefficient += 5;
    if(keyCode == DOWN) darkCoefficient -= 5;
  }
}
