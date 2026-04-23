void setup() {
  size(500,400);
  ball1 = new Ball(5, 6, );

}


class Ball  {
  
  float x, y;
  float vx, vy;
  float radius;
  color col;
  
 
  
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
  
  Ball(int x) {
  
  println("Ball is called " + x);
  
}
}

void display() {

  fill(col);
  ellipse(x,y, radius * 2, radius * 2);

}
