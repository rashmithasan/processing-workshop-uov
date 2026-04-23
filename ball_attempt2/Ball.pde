class Ball {       //Creating a ball class.

  //Fields - data
  float x, y;    //Ball position
  float radius;  //Ball radius
  float vx, vy;  //Ball velocity (x & y)
  color col = color(random(255), random(255), random(255));     //Ball colour


  //Constructor
  Ball (float startX, float startY, float r) {
    x         = startX;
    y         = startY;
    radius    = r;
    vx        = random(-3, 3);
    vy        = random(-3, 3);
  }

  void display() {
    fill(col);
    ellipse(x, y, radius, radius);
  }

  void update() {
    x = x+vx;
    y = y+vy;

    if (x + radius/2 > width || x - radius/2 < 0) {
      vx = -vx;
    }

    if (y + radius/2 > height || y - radius/2 < 0) {
      vy = -vy;
    }
  }
}
