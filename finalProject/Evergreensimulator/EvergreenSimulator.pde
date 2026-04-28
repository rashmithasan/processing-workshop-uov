// EvergreenSimulator - Main Sketch
// Group: 2024/ICTS/140, 141, 028

Game game;

void setup() {
  size(800, 550);
  smooth();
  noCursor();
  game = new Game();
}

void draw() {
  game.update();
  game.display();
}

void mousePressed() {
  game.handleClick();
}
