class Canal {
  PVector[] waypoints;
  float roadWidth;
  int levelTime = 10;
  ArrayList<PVector> path = new ArrayList<PVector>();

  Canal(int lvl) { // Sets path points and road width based on current level
    switch(lvl) {
      case 1: roadWidth = 60; waypoints = new PVector[]{ new PVector(80,275), new PVector(720,275) }; break;
      case 2: roadWidth = 50; waypoints = new PVector[]{ new PVector(80,150), new PVector(400,400), new PVector(720,400) }; break;
      case 3: roadWidth = 35; waypoints = new PVector[]{ new PVector(80,100), new PVector(650,100), new PVector(150,450), new PVector(720,450) }; break;
      case 4: roadWidth = 35; waypoints = new PVector[]{ new PVector(80,450), new PVector(250,100), new PVector(400,450), new PVector(550,100), new PVector(720,450) }; break;
      default: roadWidth = 28; waypoints = new PVector[]{ new PVector(60,80), new PVector(700,80), new PVector(700,220), new PVector(100,220), new PVector(100,360), new PVector(550,360), new PVector(550,480), new PVector(750,480) };
    }

    for (int i = 0; i < waypoints.length - 1; i++) {
      for (float t = 0; t <= 1; t += 0.05) path.add(PVector.lerp(waypoints[i], waypoints[i+1], t));
    }
  }

  boolean hitsWall(Ship s) { // Checks if ship is outside the allowed road width
    float minDist = Float.MAX_VALUE;
    for (PVector p : path) minDist = min(minDist, dist(s.x, s.y, p.x, p.y));
    return minDist > roadWidth - s.r * 0.5;
  }

  boolean isDone(Ship s) { // Checks if ship reached the final destination point
    PVector end = waypoints[waypoints.length-1];
    return dist(s.x, s.y, end.x, end.y) < roadWidth;
  }

  void display() { // Draws the canal path and start/finish markers
    noFill(); stroke(#1a5276); strokeWeight(roadWidth * 2);
    beginShape();
    for (PVector p : waypoints) vertex(p.x, p.y);
    endShape();
    
    drawMarker(waypoints[0], #27ae60);                    
    drawMarker(waypoints[waypoints.length-1], #e74c3c);
  }

  private void drawMarker(PVector p, int c) { // Helper to draw colored circles for start/end
    fill(c); noStroke(); ellipse(p.x, p.y, 40, 40);
  }
}
