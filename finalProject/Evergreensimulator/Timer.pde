// Timer.pde - Countdown timer

class Timer {

  int totalSeconds;
  int startMillis;
  boolean running = false;

  Timer(int seconds) {
    totalSeconds = seconds;
  }

  void start() {
    startMillis = millis();
    running = true;
  }

  void update() {}

  int secondsLeft() {
    if (!running) return totalSeconds;
    int elapsed = (millis() - startMillis) / 1000;
    return max(0, totalSeconds - elapsed);
  }

  boolean expired() {
    return running && secondsLeft() <= 0;
  }
}
