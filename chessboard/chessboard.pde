void setup() {
  size(500, 500);
}

void draw() {
  for (int i = 1; i <= 8; i++) {
    for (int j = 1; j <= 8; j++) {

      if ((i+j) % 2 == 0) {
        fill(0);
      } 
      else {
        fill(255);
      }
      rect(50*i, 50*j, 50, 50);
    }
  }
}
