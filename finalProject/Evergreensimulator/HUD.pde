// HUD.pde - Heads-up display

class HUD {

  Timer timer;

  HUD(Timer t) {
    timer = t;
  }

  void display(int gameState, float progress, int level) {
    drawLevelBox(level);
    drawTimerBox();
    drawProgressBar(progress);
    
    if (gameState == Game.PLAYING || gameState == Game.WAITING) {
      drawHint();
    }
  }

  void drawLevelBox(int level) {
    fill(0, 0, 0, 130);
    noStroke();
    rect(14, 14, 80, 44, 10);
    
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(16);
    text("Level " + level, 14 + 40, 36);
  }

  void drawTimerBox() {
    int secs = timer.secondsLeft();
    
    // Background pill
    fill(0, 0, 0, 130);
    noStroke();
    rect(width - 160, 14, 142, 44, 10);
    
    // Label
    fill(255, 255, 255, 160);
    textAlign(LEFT, CENTER);
    textSize(12);
    text("TIME LEFT", width - 148, 36);
    
    // Time value (color shifts red when low)
    if (secs <= 10) fill(#e74c3c);
    else fill(#f1c40f);
    textAlign(RIGHT, CENTER);
    textSize(22);
    text(secs + "s", width - 20, 36);
  }

  void drawProgressBar(float progress) {
    float bw = 220, bh = 14;
    float bx = 14, by = height - 34;

    // Background
    fill(0, 0, 0, 100);
    noStroke();
    rect(bx, by, bw, bh, 6);

    // Fill
    fill(#27ae60);
    rect(bx, by, bw * progress, bh, 6);
    
    // Label
    fill(255);
    textAlign(LEFT, CENTER);
    textSize(11);
    text("Progress  " + int(progress * 100) + "%", bx + 6, by + bh / 2);
  }

  void drawHint() {
    fill(255, 255, 255, 130);
    textAlign(CENTER, CENTER);
    textSize(12);
    text("Stay inside the canal!", width / 2, height - 22);
  }
}
