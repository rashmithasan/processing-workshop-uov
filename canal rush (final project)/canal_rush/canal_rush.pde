Game game;

void setup() { // Initializes display size and the main Game object
  size(800, 550);
  game = new Game();
}

void draw() { // Continuous loop to update game logic and render visuals
  game.update();
  game.display();
}

void mousePressed() { // Captures mouse clicks to advance levels or retry
  game.handleClick();
}

class Game {
  Canal canal;
  Ship ship;
  // States: 0:WAIT, 1:PLAY, 2:CLEAR, 3:LOSE, 4:FINISH
  int state = 0, level = 1;
  int startTime, timeLimit;

  Game() { loadLevel(); }

  void loadLevel() { // Resets canal, ship, and timer for the current level
    canal = new Canal(level);
    ship = new Ship(canal.waypoints[0].x, canal.waypoints[0].y);
    timeLimit = canal.levelTime;
    state = 0; 
  }

  void update() { // Manages game flow, start triggers, and win/loss conditions
    if (state == 0 && ship.isHovered()) {
      state = 1;
      startTime = millis();
    }
    if (state == 1) {
      ship.update();
      if (timeLeft() <= 0 || canal.hitsWall(ship)) state = 3;
      else if (canal.isDone(ship)) state = (level < 5) ? 2 : 4;
    }
  }

  int timeLeft() { // Calculates remaining time in seconds
    return max(0, timeLimit - (millis() - startTime) / 1000);
  }

  void display() { // Renders the game world, HUD, and status overlays
    background(#a8d8ea);
    canal.display();
    ship.display();
    
    fill(255); textSize(18);
    textAlign(LEFT);
    text("Level " + level, 20, 30);
    textAlign(RIGHT);
    fill(timeLeft() < 6 ? #e74c3c : 255);
    text("Time: " + timeLeft() + "s", width - 20, 30);

    if (state != 1) drawOverlay();
  }

  void drawOverlay() { // Shows text messages based on current game state
    fill(0, 150); rect(0, 0, width, height);
    fill(255); textAlign(CENTER);
    if (state == 0) text("Hover over the ship to start Level " + level, width/2, height/2);
    if (state == 2) text("Level Cleared! Click to continue.", width/2, height/2);
    if (state == 3) { fill(#e74c3c); text("Shipwreck! Click to retry.", width/2, height/2); }
    if (state == 4) { fill(#f1c40f); text("You Beat the Game! Click to reset.", width/2, height/2); }
  }

  void handleClick() { // Logic for restarting or moving to the next level
    if (state == 2) { level++; loadLevel(); }
    else if (state == 3) loadLevel();
    else if (state == 4) { level = 1; loadLevel(); }
  }
}
