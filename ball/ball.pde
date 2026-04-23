Ball ball1;
Ball ball2;

void setup() {
  size(500,400);
  
  ball1 = new Ball(100, 100, 3, 2, 20, color(random(255)));
  ball2 = new Ball(150, 200, 3, 2, 20, color(random(255)));

}

void draw() {
  background(255); 
  
  ball1.update();
  ball1.display();
  
  ball2.update();
  ball2.display();
}

class Ball  {
  
  float x, y;
  float vx, vy;
  float radius;
  color col;
  
  Ball(float x, float y, float vx, float vy, float radius, color col) {
    this.x = x;
    this.y = y;
    this.vx = 2;
    this.vy = 3;
    this.col = col;
    this.radius = radius;
  }
  
  void update() {
 
      x = x + vx;
      y = y + vy;
      
      if (x - radius < 0 || x + radius > width) {
        vx = -vx;
      }
      
      if (y - radius < 0 || y + radius > height) {
        vy = -vy;
      }
  }
  
  void display () {

  fill(col);
  ellipse(x,y, radius * 2, radius * 2);

}
  
}
