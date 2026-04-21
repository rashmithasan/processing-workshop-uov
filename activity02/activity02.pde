float randomNumber;

void setup(){
  size(200, 200);
  fill(0);
  textSize(48);
  textAlign(CENTER);
  
  randomNumber = random(2.0);
  
}

void draw(){

  background(230, 255, 230);
  
  String message;
  
  if (randomNumber < 1.0) {
    message = "TAILS";
  }
  else{
    message = "HEADS";
  }
  
  text(message, width/2, height/2);
  
}
