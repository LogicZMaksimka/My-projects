class VideoFilter{
  private
  Capture video;
  public
  VideoFilter(Capture video_){
    video = video_;
  }
  
  Capture getVideo(){
    return video;
  }
  
  //цвет отобразится если отличается от самого тёмного цвета на картинке не более чем на darkCoefficient (обычно darkCoefficient - это число от 0 до 255)
  Capture getDarkestColor(float darkCoefficient){
    float minBrightness = 256;
    for(int x = 0; x < video.width;++x){
      for(int y = 0; y < video.height;++y){
        int imgLoc = x + y*video.width;
        float curBrightness = brightness(video.pixels[imgLoc]);
        if(minBrightness > curBrightness){
          minBrightness = curBrightness;
        }
      }
    }
    Capture transformedVideo = video;
    transformedVideo.loadPixels();
    for(int x = 0; x < video.width;++x){
      for(int y = 0; y < video.height;++y){
        int imgLoc = x + y*video.width;
        float curBrightness = brightness(video.pixels[imgLoc]);
        if(minBrightness + darkCoefficient >= curBrightness){
          transformedVideo.pixels[imgLoc] = color(curBrightness - minBrightness);
        }
        else{
          transformedVideo.pixels[imgLoc] = color(255);
        }
      }
    }
    transformedVideo.updatePixels();
    return transformedVideo;
  }
  
  
  /*
  
  
  //изменение резкости картинки
  //цвет пикселя X определяется таким образом:
  //цвет каждого пикселя в окрестность пикселя X (окрестность задаётся размером матрицы) "домножается" на соответствующее ему число в матрице
  //после умножения складываем полученные значения (усредняем цвет)
  //полученный таким цвет делим на коэффициент нормирования (div) чтобы сохранить яркость картинки
  //P.S. цвета домножается посредством разложения их на состовляющие (RGB)
  PImage getVideoMultipliedByMatrix(float[][] transformationMatrix, int matrixSize){
    
    float div = 0;
    for(int i = 0; i < matrixSize; ++i){
      for(int j = 0; j < matrixSize; ++j){
        div += transformationMatrix[i][j];
      }
    }
    
    PImage transformedImage = createImage(img.width, img.height, RGB);
    transformedImage.loadPixels();
    int centralPixel = matrixSize/2;
    for(int x = 0; x < img.width;++x){
      for(int y = 0; y < img.height;++y){
        int imgLoc = x + y*img.width;
        float redSum = 0, greenSum = 0, blueSum = 0;
        for(int i = 0; i < matrixSize; ++i){
          for(int j = 0; j < matrixSize; ++j){
            int loc = constrain((x + i - centralPixel) + (y + j - centralPixel)*img.width, 0, img.pixels.length - 1);
            redSum += red(img.pixels[loc])*transformationMatrix[i][j];
            greenSum += green(img.pixels[loc])*transformationMatrix[i][j];
            blueSum += blue(img.pixels[loc])*transformationMatrix[i][j];
          }
        }
        redSum = constrain(redSum/div, 0, 255);
        greenSum = constrain(greenSum/div, 0, 255);
        blueSum = constrain(blueSum/div, 0, 255);
        transformedImage.pixels[imgLoc] = color(redSum, greenSum, blueSum);
      }
    }
    transformedImage.updatePixels();
    return transformedImage;
  }
  

  
  
  //рассматриваем область изображения 3x3
  //z - значение яркости пикселя
  // z1 z2 z3
  // z4 z5 z6
  // z7 z8 z9
  //вычисляем градиент по двум осям
  //Оператор Собеля сглаживает паразитные эффекты на изображении
  //Gx = (z7 + 2*z8 + z9) - (z1 + 2*z2 + z3)
  //Gy = (z3 + 2*z6 + z9) - (z1 + 2*z4 + z7)
  //G = sqrt(Gx*Gx + Gy*Gy)
  
  
  PImage getImageSketch(float lowerLimit, float upperLimit){
    PImage transformedImage = createImage(img.width, img.height, RGB);
    transformedImage.loadPixels();
    for(int x = 1; x < img.width - 1;++x){
      for(int y = 1; y < img.height - 1;++y){
        float z1 = brightness(img.pixels[(x-1) + (y-1)*img.width]);
        float z2 = brightness(img.pixels[(x  ) + (y-1)*img.width]);
        float z3 = brightness(img.pixels[(x+1) + (y-1)*img.width]);
        float z4 = brightness(img.pixels[(x-1) + (y  )*img.width]);
        float z5 = brightness(img.pixels[(x  ) + (y  )*img.width]);
        float z6 = brightness(img.pixels[(x+1) + (y  )*img.width]);
        float z7 = brightness(img.pixels[(x-1) + (y+1)*img.width]);
        float z8 = brightness(img.pixels[(x  ) + (y+1)*img.width]);
        float z9 = brightness(img.pixels[(x+1) + (y+1)*img.width]);
        
        float Gx = (z7 + 2*z8 + z9) - (z1 + 2*z2 + z3);
        float Gy = (z3 + 2*z6 + z9) - (z1 + 2*z4 + z7);
        float G = sqrt(Gx*Gx + Gy*Gy);
        
        int imgLoc = x + y*img.width;
        if(lowerLimit <= G && G <= upperLimit) transformedImage.pixels[imgLoc] = color(0);
        else transformedImage.pixels[imgLoc] = color(255);
      }
    }
    transformedImage.updatePixels();
    return transformedImage;
  } 
  
  */
}
