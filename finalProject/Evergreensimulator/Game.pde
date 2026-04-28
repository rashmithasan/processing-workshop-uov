// Game.pde - Core game manager

class Game {

  // States
  static final int IDLE        = 0;
  static final int WAITING     = 1;  // waiting for player to hover ship
  static final int PLAYING     = 2;
  static final int LEVEL_CLEAR = 3;
  static final int GAME_CLEAR  = 4;
  static final int LOSE        = 5;

  int state = IDLE;
  int currentLevel = 1;
  final int MAX_LEVEL = 5;

  Canal canal;
  Ship  ship;
  Timer timer;
  HUD   hud;

  Game() {
    loadLevel();
    state = IDLE; 
  }

  void loadLevel() {
    canal = new Canal(currentLevel);
    ship  = new Ship(canal.startX(), canal.startY());
    timer = new Timer(canal.timeLimit);
    hud   = new HUD(timer);
    state = WAITING;
  }

  void update() {
    if (state == WAITING) {
      if (ship.isHovered()) {
        state = PLAYING;
        timer.start();
      }
    }

    if (state == PLAYING) {
      ship.follow(mouseX, mouseY);
      timer.update();

      if (timer.expired() || canal.collidesWithWall(ship)) {
        state = LOSE;
      } else if (canal.reachedEnd(ship)) {
        if (currentLevel < MAX_LEVEL) {
          state = LEVEL_CLEAR;
        } else {
          state = GAME_CLEAR;
        }
      }
    }
  }

  void display() {
    background(#a8d8ea); 

    canal.display();
    ship.display(state == PLAYING || state == WAITING);
    hud.display(state, canal.progressOf(ship), currentLevel);

    if (state == IDLE || state == LEVEL_CLEAR || state == GAME_CLEAR || state == LOSE) {
      drawOverlay();
    }
    if (state == WAITING) {
      drawWaitPrompt();
    }
    
    // Note: The custom cursor dot code that was here has been completely removed!
  }

  void handleClick() {
    if (state == IDLE) {
      state = WAITING;
    } else if (state == LEVEL_CLEAR) {
      currentLevel++;
      loadLevel();
    } else if (state == GAME_CLEAR) {
      currentLevel = 1;
      loadLevel();
    } else if (state == LOSE) {
      loadLevel(); 
    }
  }

  void drawWaitPrompt() {
    fill(0, 0, 0, 120);
    noStroke();
    rect(0, 0, width, height);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(20);
    text("Hover over the ball to begin Level " + currentLevel + "!", width/2, height/2 - 16);
    textSize(14);
    fill(255, 255, 255, 180);
    text("Keep it inside the canal", width/2, height/2 + 16);
  }

  void drawOverlay() {
    fill(0, 0, 0, 150);
    noStroke();
    rect(0, 0, width, height);

    textAlign(CENTER, CENTER);

    if (state == IDLE) {
      fill(255);
      textSize(30);
      text("Evergreen Simulator", width/2, height/2 - 40);
      textSize(16);
      fill(255, 255, 255, 200);
      text("Navigate through the canal without hitting the banks.", width/2, height/2);
      textSize(14);
      text("Click anywhere to start", width/2, height/2 + 36);

    } else if (state == LEVEL_CLEAR) {
      fill(#2ecc71);
      textSize(34);
      text("Level " + currentLevel + " Cleared!", width/2, height/2 - 30);
      fill(255);
      textSize(16);
      text("Time remaining: " + timer.secondsLeft() + "s", width/2, height/2 + 10);
      textSize(14);
      fill(255, 255, 255, 200);
      text("Click to proceed to the next level", width/2, height/2 + 46);

    } else if (state == GAME_CLEAR) {
      fill(#f1c40f);
      textSize(34);
      text("You Beat the Game!", width/2, height/2 - 30);
      fill(255);
      textSize(16);
      text("Master Navigator Status Achieved. All 5 Levels complete.", width/2, height/2 + 10);
      textSize(14);
      fill(255, 255, 255, 200);
      text("Click to play again", width/2, height/2 + 46);

    } else if (state == LOSE) {
      fill(#e74c3c);
      textSize(34);
      text("Shipwreck!", width/2, height/2 - 30);
      fill(255);
      textSize(16);
      text("You hit the wall or ran out of time. Better luck next time.", width/2, height/2 + 10);
      textSize(14);
      fill(255, 255, 255, 200);
      text("Click to try this level again", width/2, height/2 + 46);
    }
  }
}
