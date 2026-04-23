Ball[] balls;
int numBalls = 100;

void setup() {
  size(500, 500);
  balls = new Ball[numBalls];

  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(20, 480), random(20, 480), 50);
  }
}


void draw() {
  background(0);
  noStroke();

  for (int i = 0; i < numBalls; i++) {
    balls[i].display();
    balls[i].update();
  }
}
