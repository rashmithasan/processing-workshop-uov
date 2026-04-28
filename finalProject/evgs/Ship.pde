class Ship {
  float x, y, r = 14, noiseOff;
  float smooth = 0.99; // Controls handling lag

  Ship(float x, float y) {
    this.x = x; this.y = y;
    noiseOff = random(1000);
  }

  void update() {
    // Current-based drift
    float dx = map(noise(noiseOff), 0, 1, -3, 3);
    float dy = map(noise(noiseOff + 500), 0, 1, -3, 3);
    noiseOff += 0.05;

    // Smooth movement towards mouse
    x += (mouseX - x) * smooth + dx;
    y += (mouseY - y) * smooth + dy;
  }

  boolean isHovered() { return dist(mouseX, mouseY, x, y) < r + 15; }

  void display() {
    fill(#f39c12); stroke(#d35400); strokeWeight(3);
    ellipse(x, y, r*2, r*2);
  }
}
