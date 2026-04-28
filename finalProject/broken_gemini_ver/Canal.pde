class Canal {
  PVector[] waypoints;
  float roadWidth;
  int levelTime;
  ArrayList<PVector> path = new ArrayList<PVector>();

  Canal(int lvl, int step) {
    // මුළු ප්‍රගතිය (1 සිට 100 දක්වා)
    int totalDifficulty = ((lvl - 1) * 5) + step;

    // 1. පාර පටු කිරීම (Narrower): ආරම්භක පළල 45 සිට 12 දක්වා ක්‍රමයෙන් සිහින් වේ
    // (මුල සිටම පාර පටු බැවින් ක්‍රීඩාව වඩාත් අභියෝගාත්මක වේ)
    roadWidth = max(12, 45 - (totalDifficulty * 0.4)); 

    // 2. පාරේ දිග (Length): ආරම්භයේදීම ලක්ෂ්‍ය 5ක් ඇති අතර උපරිම 18 දක්වා වැඩි වේ
    int numPoints = 5 + (totalDifficulty / 6); 
    
    // 3. කාලය සැකසීම (මිලිසෙකන්ඩ් වලින්)
    levelTime = max(4500, 15000 - (totalDifficulty * 110));

    // අහඹු පාර නිර්මාණය
    generateRandomPath(numPoints, totalDifficulty);

    // Collision path සැකසීම
    for (int i = 0; i < waypoints.length - 1; i++) {
      // පාර සිහින් නිසා වඩාත් නිවැරදිව පරීක්ෂා කිරීමට 0.01 පියවර භාවිතා කරයි
      for (float t = 0; t <= 1; t += 0.01) { 
        path.add(PVector.lerp(waypoints[i], waypoints[i+1], t));
      }
    }
  }

  void generateRandomPath(int count, int difficulty) {
    waypoints = new PVector[count];
    
    // ආරම්භක සහ අවසාන ලක්ෂ්‍ය තිරයේ දාරවලට ආසන්නව
    waypoints[0] = new PVector(40, random(150, height-150));
    waypoints[count-1] = new PVector(width - 40, random(150, height-150));
    
    float spacing = (width - 80) / (count - 1);
    
    // වංගු වල තීව්‍රතාවය (Steepness): ආරම්භයේදීම වැඩි බෑවුමක් ලබා දී ඇත
    float verticalFluctuation = 80 + (difficulty * 5.0); 

    for (int i = 1; i < count - 1; i++) {
      float x = i * spacing + random(-25, 25);
      
      // Y පරාසය විශාල කිරීමෙන් පාර "zig-zag" ස්වභාවයක් ගනී
      float yBase = height / 2;
      float yMove = random(-verticalFluctuation, verticalFluctuation);
      float y = constrain(yBase + yMove, 50, height - 50);
      
      waypoints[i] = new PVector(x, y);
    }
  }

  boolean hitsWall(Ship s) {
    float minDist = 5000;
    for (PVector p : path) {
      float d = dist(s.x, s.y, p.x, p.y);
      if (d < minDist) minDist = d;
    }
    // පාර පටු බැවින් collision detection වඩාත් සංවේදී කර ඇත
    return minDist > (roadWidth - s.r * 0.35);
  }

  boolean isDone(Ship s) {
    PVector end = waypoints[waypoints.length-1];
    return dist(s.x, s.y, end.x, end.y) < roadWidth * 1.5;
  }

  void display() {
    noFill(); 
    stroke(#1a5276, 200); 
    strokeWeight(roadWidth * 2);
    strokeJoin(ROUND);
    strokeCap(ROUND);
    
    beginShape();
    for (PVector p : waypoints) vertex(p.x, p.y);
    endShape();
    
    // Start සහ End ලක්ෂ්‍ය පාරේ පළලට අනුව සකස් වේ
    noStroke();
    fill(#27ae60); ellipse(waypoints[0].x, waypoints[0].y, roadWidth * 1.2, roadWidth * 1.2);
    fill(#e74c3c); ellipse(waypoints[waypoints.length-1].x, waypoints[waypoints.length-1].y, roadWidth * 1.2, roadWidth * 1.2);
  }
}
