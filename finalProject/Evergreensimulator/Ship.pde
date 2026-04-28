// Ship.pde - The player's ball/ship

class Ship {

  float x, y;
  float r = 14; // collision radius
  
  // Physics variables
  float smooth = 0.02; // Lowered to 0.05 for heavy, floaty momentum
  float noiseOffset;   // Used for unpredictable water drift

  Ship(float startX, float startY) {
    x = startX;
    y = startY;
    noiseOffset = random(1000); // Pick a random starting point for the drift
  }

  void follow(float mx, float my) {
    // 1. Calculate unpredictable drift using Perlin noise (simulates water currents)
    float driftX = map(noise(noiseOffset), 0, 1, -3.5, 3.5);
    float driftY = map(noise(noiseOffset + 1000), 0, 1, -3.5, 3.5);
    noiseOffset += 0.06; // How fast the current changes direction

    // 2. Move towards mouse with floaty lag, PLUS the random drift
    x += ((mx - x) * smooth) + driftX;
    y += ((my - y) * smooth) + driftY;

    // Keep within window bounds
    x = constrain(x, r, width  - r);
    y = constrain(y, r, height - r);
  }

  boolean isHovered() {
    return dist(mouseX, mouseY, x, y) < r + 12;
  }

  void display(boolean active) {
    pushMatrix();
    translate(x, y);

    // Clean ball design (Removed the triangle sail and mast!)
    fill(active ? #f39c12 : #f1c40f);
    stroke(#d35400);
    strokeWeight(3);
    ellipse(0, 0, r * 2.2, r * 2.2);

    popMatrix();
  }
}
