boolean buttonState;

void setup() {
  size(640, 360);
  buttonState = false;
}

void draw() {
  noStroke();
  background(255);
  rect(width/2, height/2, 100, 70);
}

void mouseClicked()
{
  
  if (buttonState == false) {
    fill(155, 0, 0);
    text("OFF", (width-50), (height-35));
    buttonState = true;
  } 
  
  else {
    fill(0, 155, 0);
    text("ON", (width-50), (height-35));
    buttonState = false;
  }
}
