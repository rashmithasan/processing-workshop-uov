// Simplified Evergreen Simulator
Game game;

void setup() {
  size(800, 550);
  game = new Game();
}

void draw() {
  game.update();
  game.display();
}

void mousePressed() {
  game.handleClick();
}

class Game {
  
  Canal canal;
  Ship ship;
  // States: 0:WAIT, 1:PLAY, 2:CLEAR, 3:LOSE, 4:FINISH
  int state = 0, level = 1;
  int step = 1; // Used to manage 20 levels with 5 steps each
  int startTime, timeLimit;

  Game() { loadLevel(); }

  void loadLevel() {
    // Passes both level and step to generate the canal path
    canal = new Canal(level, step); 
    ship = new Ship(canal.waypoints[0].x, canal.waypoints[0].y);
    timeLimit = canal.levelTime;
    state = 0; 
  }

  void update() {
    // Start the game when user hovers over the ship
    if (state == 0 && ship.isHovered()) {
      state = 1;
      startTime = millis();
    }
    
    if (state == 1) {
      ship.update();
      
      // Check for lose conditions: Time out or hitting a wall
      if (timeLeft() <= 0 || canal.hitsWall(ship)) {
        state = 3;
      } 
      // Check if ship reached the end
      else if (canal.isDone(ship)) {
        // Check if final level (20) and final step (5) are completed
        if (level >= 20 && step >= 5) {
          state = 4;
        } else {
          state = 2;
        }
      }
    }
  }

  // Calculate remaining time in seconds
  int timeLeft() { 
    return max(0, (timeLimit - (millis() - startTime)) / 1000); 
  }

  void display() {
    background(#a8d8ea); // Light water blue
    canal.display();
    ship.display();
    
    // UI - Level and Step info
    fill(255); 
    textSize(18); 
    textAlign(LEFT);
    text("Level " + level + " - Step " + step, 20, 30);
    
    // UI - Countdown timer
    textAlign(RIGHT);
    fill(timeLeft() < 6 ? #e74c3c : 255); // Turns red when time is low
    text("Time: " + timeLeft() + "s", width - 20, 30);

    if (state != 1) drawOverlay();
  }

  void drawOverlay() {
    fill(0, 150); // Semi-transparent background
    rect(0, 0, width, height);
    fill(255); 
    textAlign(CENTER);
    
    if (state == 0) 
      text("Hover over the ship to start Level " + level + " Step " + step, width/2, height/2);
    
    if (state == 2) 
      text("Step Cleared! Click to continue.", width/2, height/2);
    
    if (state == 3) { 
      fill(#e74c3c); 
      text("Shipwreck! Click to retry.", width/2, height/2); 
    }
    
    if (state == 4) { 
      fill(#f1c40f); 
      text("You Beat the Game! Click to reset.", width/2, height/2); 
    }
  }

  void handleClick() {
    if (state == 2) { 
      // Advance step; if step 5 is reached, advance level
      step++;
      if (step > 5) {
        step = 1;
        level++;
      }
      loadLevel(); 
    }
    else if (state ==
