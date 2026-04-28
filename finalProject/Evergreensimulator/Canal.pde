// Canal.pde - The winding canal path

class Canal {

  float roadWidth;
  int timeLimit;
  PVector[] waypoints;
  ArrayList<PVector> pathPts = new ArrayList<PVector>();

  Canal(int level) {
    // LEVEL CONFIGURATIONS
    if (level == 1) {
      roadWidth = 60; timeLimit = 20;
      waypoints = new PVector[]{ new PVector(80, 275), new PVector(250, 150), new PVector(500, 400), new PVector(720, 275) };
    } 
    else if (level == 2) {
      roadWidth = 50; timeLimit = 15;
      waypoints = new PVector[]{ new PVector(80, 150), new PVector(350, 150), new PVector(450, 400), new PVector(720, 400) };
    } 
    else if (level == 3) {
      roadWidth = 42; timeLimit = 15;
      waypoints = new PVector[]{ new PVector(80, 100), new PVector(650, 100), new PVector(650, 250), new PVector(150, 250), new PVector(150, 450), new PVector(720, 450) };
    } 
    else if (level == 4) {
      roadWidth = 35; timeLimit = 10;
      waypoints = new PVector[]{ new PVector(80, 450), new PVector(250, 100), new PVector(400, 450), new PVector(550, 100), new PVector(720, 450) };
    } 
    else { // Level 5 (Hardest)
      roadWidth = 28; timeLimit = 10;
      waypoints = new PVector[]{ new PVector(60, 80), new PVector(700, 80), new PVector(700, 220), new PVector(100, 220), new PVector(100, 360), new PVector(550, 360), new PVector(550, 480), new PVector(750, 480) };
    }
    
    buildPath();
  }

  void buildPath() {
    int steps = 30; // Smoother curves
    for (int i = 0; i < waypoints.length - 1; i++) {
      PVector a = waypoints[i], b = waypoints[i + 1];
      for (int t = 0; t < steps; t++) {
        float frac = (float)t / steps;
        pathPts.add(PVector.lerp(a, b, frac));
      }
    }
    pathPts.add(waypoints[waypoints.length - 1]);
  }

  // Returns the closest distance from point p to the canal centerline
  float distFromCenter(float px, float py) {
    float minD = Float.MAX_VALUE;
    for (PVector pt : pathPts) {
      float d = dist(px, py, pt.x, pt.y);
      if (d < minD) minD = d;
    }
    return minD;
  }

  // Index of closest centerline point (for progress)
  int closestIndex(float px, float py) {
    float minD = Float.MAX_VALUE;
    int idx = 0;
    for (int i = 0; i < pathPts.size(); i++) {
      PVector pt = pathPts.get(i);
      float d = dist(px, py, pt.x, pt.y);
      if (d < minD) { minD = d; idx = i; }
    }
    return idx;
  }

  float progressOf(Ship ship) {
    return (float)closestIndex(ship.x, ship.y) / (pathPts.size() - 1);
  }

  boolean collidesWithWall(Ship ship) {
    return distFromCenter(ship.x, ship.y) > roadWidth - ship.r * 0.75;
  }

  boolean reachedEnd(Ship ship) {
    PVector ep = waypoints[waypoints.length - 1];
    return dist(ship.x, ship.y, ep.x, ep.y) < roadWidth * 0.65;
  }

  float startX() { return waypoints[0].x; }
  float startY() { return waypoints[0].y; }

  void display() {
    drawWater();
    drawBanks();
    drawStartEnd();
  }

  void drawWater() {
    int n = pathPts.size();
    PVector[] left  = new PVector[n];
    PVector[] right = new PVector[n];

    for (int i = 0; i < n; i++) {
      PVector p    = pathPts.get(i);
      PVector next = pathPts.get(min(i + 1, n - 1));
      PVector prev = pathPts.get(max(i - 1, 0));
      PVector dir  = PVector.sub(next, prev);
      if (dir.mag() < 0.001) dir.set(1, 0);
      dir.normalize();
      PVector norm = new PVector(-dir.y, dir.x);
      
      left[i]  = PVector.add(p, PVector.mult(norm,  roadWidth));
      right[i] = PVector.add(p, PVector.mult(norm, -roadWidth));
    }

    fill(#2471a3);
    noStroke();
    beginShape();
    for (PVector v : left)  vertex(v.x, v.y);
    for (int i = n - 1; i >= 0; i--) vertex(right[i].x, right[i].y);
    endShape(CLOSE);

    // Subtle wave lines
    stroke(255, 255, 255, 35);
    strokeWeight(1.2);
    noFill();
    for (int i = 5; i < n - 5; i += 18) {
      PVector p = pathPts.get(i);
      beginShape();
      for (int k = -8; k <= 8; k++) {
        float wx = p.x + k * 2.5;
        float wy = p.y + sin(k * 0.5) * 4;
        vertex(wx, wy);
      }
      endShape();
    }
  }

  void drawBanks() {
    int n = pathPts.size();
    strokeWeight(4);
    strokeJoin(ROUND);
    strokeCap(ROUND);
    stroke(#1a5276);
    noFill();

    // Left bank
    beginShape();
    for (int i = 0; i < n; i++) {
      PVector p    = pathPts.get(i);
      PVector next = pathPts.get(min(i + 1, n - 1));
      PVector prev = pathPts.get(max(i - 1, 0));
      PVector dir  = PVector.sub(next, prev);
      if (dir.mag() < 0.001) dir.set(1, 0);
      dir.normalize();
      PVector norm = new PVector(-dir.y, dir.x);
      PVector lp = PVector.add(p, PVector.mult(norm, roadWidth));
      vertex(lp.x, lp.y);
    }
    endShape();

    // Right bank
    beginShape();
    for (int i = 0; i < n; i++) {
      PVector p    = pathPts.get(i);
      PVector next = pathPts.get(min(i + 1, n - 1));
      PVector prev = pathPts.get(max(i - 1, 0));
      PVector dir  = PVector.sub(next, prev);
      if (dir.mag() < 0.001) dir.set(1, 0);
      dir.normalize();
      PVector norm = new PVector(-dir.y, dir.x);
      PVector rp = PVector.add(p, PVector.mult(norm, -roadWidth));
      vertex(rp.x, rp.y);
    }
    endShape();
  }

  void drawStartEnd() {
    PVector sp = waypoints[0];
    PVector ep = waypoints[waypoints.length - 1];

    fill(#27ae60, 200);
    noStroke();
    ellipse(sp.x, sp.y, roadWidth * 1.2, roadWidth * 1.2);
    fill(255); textAlign(CENTER, CENTER); textSize(11);
    text("START", sp.x, sp.y);

    fill(#e74c3c, 200);
    noStroke();
    ellipse(ep.x, ep.y, roadWidth * 1.2, roadWidth * 1.2);
    fill(255); textAlign(CENTER, CENTER); textSize(11);
    text("END", ep.x, ep.y);
  }
}
