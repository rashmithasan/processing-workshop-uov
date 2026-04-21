void setup(){
  size(1280,720);
  
}

void draw(){
  
  float x = random(255);
  float y = random(255);
  float z = random(255);
  
  if(mouseX > width/2 && mouseY > height/2) {
    fill(x,y,z);
  }
  
  else if (mouseX < width/2 && mouseY > height/2){
    fill(x,y,z);
  }

  else if (mouseX > width/2 && mouseY < height/2){
    fill(x,y,z);
  }
  else{
    fill(x,y,z);
  }
  
  ellipse(width/2, height/2, 400, 400);
  




}
