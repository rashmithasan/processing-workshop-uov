Box box;

void setup() {
  size(600, 600);
  box = new Box(20, 20);
}

void draw() {
  background(255);
  box.display();
}

void keyPressed() {

  if (key == 'w') {
    box.moveUp();
  }

  if (key == 's') {
    box.moveDown();
  }

  if (key == 'd') {
    box.moveRight();
  }

  if (key == 'a') {
    box.moveLeft();
  }
}
