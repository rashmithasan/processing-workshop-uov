class Ship {
  float x, y, r = 14, noiseOff;
  float smooth = 0.06;

  Ship(float x, float y) { // Sets initial ship position and movement noise
    this.x = x; this.y = y;
    noiseOff = random(1000);
  }

  void update() { // Smoothly moves ship toward mouse with a random wobble 
    float dx = map(noise(noiseOff), 0, 1, -3, 3);
    float dy = map(noise(noiseOff + 500), 0, 1, -3, 3);
    noiseOff += 0.05;
    x += (mouseX - x) * smooth + dx;
    y += (mouseY - y) * smooth + dy;
  }

  boolean isHovered() { // Checks if mouse cursor is within ship's radius 
    return dist(mouseX, mouseY, x, y) < r + 15;
  }

  void display() { // Renders the ship as an ellipse on the screen 
    fill(#f39c12); stroke(#d35400); strokeWeight(3);
    ellipse(x, y, r*2, r*2);
  }
}
