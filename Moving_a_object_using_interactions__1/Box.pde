class Box {

  float x, y;
  float vx, vy;
  color col;
  
  Box (float startX, float startY){
    
     x = startX;
     y = startY;
     vx = 2;
     vy = 2;
     col = color(random(255), random(255),random(255));
  
  }
  
  void keyPressed(){
    if (key == "w"){
      y += vy;
    }
    
    if (key == "s"){
      y -= vy;
    }
    
    if (key == "d"){
      x += vX;
    }
    
    if (key == "a"){
      x -= vX;
    }
  
  }










}
