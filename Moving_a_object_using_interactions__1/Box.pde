class Box {

  float x, y;
  float vx, vy;
  color col;

  Box (float startX, float startY) {
    x = startX;
    y = startY;
    vx = 5;
    vy = 5;
    col = color(random(255), random(255), random(255));
  }

  void moveUp() {
    y -= vy;
  }
  void moveRight() {
    x += vx;
  }
  void moveLeft() {
    x -= vx;
  }
  void moveDown() {
    y += vy;
  }

  void display() {
    fill(col);
    rect(x, y, 35, 35);
  }
}
