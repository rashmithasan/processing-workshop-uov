# Canal Navigator — Complete Code Explanation
> Every line, explained in plain English. Use this to answer judge questions confidently.

---

## How the files fit together

```
evgs.pde   ← main sketch: setup(), draw(), mousePressed(), and the Game class
Ship.pde   ← Ship class: the orange circle the player steers
Canal.pde  ← Canal class: the blue path, walls, and level layouts
```

Processing runs `setup()` once and `draw()` 60 times per second. Everything else is triggered from those two entry points.

---

## evgs.pde — The main sketch

### Global state

```java
Game game;
```
A **global variable** — `game` lives at sketch level, outside any method, so every function can see it. Only one Game object exists at a time.

---

### setup()

```java
void setup() {
  size(800, 550);
  game = new Game();
}
```

| Line | What it does |
|------|--------------|
| `size(800, 550)` | Sets the canvas to 800 × 550 pixels |
| `game = new Game()` | Creates one Game object using `new`. The `Game()` constructor runs immediately, which calls `loadLevel()` to prepare Level 1 |

---

### draw()

```java
void draw() {
  game.update();
  game.display();
}
```

Called automatically 60× per second by Processing. We split every frame into two **sub-programs** (methods):
- `update()` — changes state (moves the ship, checks collisions, ticks the timer)
- `display()` — draws everything to screen

This separation (update vs display) is a classic game-programming pattern. It keeps logic and visuals completely separate.

---

### mousePressed()

```java
void mousePressed() {
  game.handleClick();
}
```

Processing calls this automatically whenever the mouse button is pressed. We **pass the event** to the game by calling `game.handleClick()`. The Game class decides what to do based on the current state.

---

## The Game class (inside evgs.pde)

### Fields (global variables inside the class)

```java
Canal canal;
Ship ship;
int state = 0, level = 1;
int startTime, timeLimit;
```

| Variable | Type | Purpose |
|----------|------|---------|
| `canal` | Canal | The current level's path and walls |
| `ship` | Ship | The player's ship object |
| `state` | int | Which phase the game is in (see below) |
| `level` | int | Current level number (1–5) |
| `startTime` | int | Time in milliseconds when the level started |
| `timeLimit` | int | Seconds allowed for this level |

**State machine — the 5 states:**

| Value | Name | Meaning |
|-------|------|---------|
| 0 | WAIT | Waiting for player to hover over ship |
| 1 | PLAY | Active gameplay |
| 2 | CLEAR | Level finished successfully |
| 3 | LOSE | Player crashed or ran out of time |
| 4 | FINISH | All 5 levels completed |

A state machine is the cleanest way to manage a game loop — each state has its own rules and only one state is active at a time.

---

### loadLevel()

```java
void loadLevel() {
  canal = new Canal(level);
  ship = new Ship(canal.waypoints[0].x, canal.waypoints[0].y);
  timeLimit = canal.levelTime;
  state = 0;
}
```

Called when starting or restarting a level. It:
1. Creates a brand-new Canal for the current level number
2. Creates a Ship at the canal's **first waypoint** (the start dot) — **parameter passing** in action: the x/y position is passed directly into the Ship constructor
3. Copies the level's time limit from the canal
4. Resets state to WAIT (0)

---

### update()

```java
void update() {
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
```

This runs every frame. The **selection** (`if / else if`) structure:

1. **State 0 → 1:** If we're waiting AND the player hovers the ship, start the clock (`millis()` returns milliseconds since the sketch started)
2. **State 1:** During active play:
   - Move the ship by calling `ship.update()`
   - If time ran out OR ship hit a wall → **LOSE** (state 3)
   - Else if ship reached the end → either **CLEAR** (state 2) or **FINISH** (state 4), depending on whether more levels remain
   
The ternary `(level < 5) ? 2 : 4` is a compact if-else: "if level is less than 5, use 2, otherwise use 4."

---

### timeLeft()

```java
int timeLeft() { return max(0, timeLimit - (millis() - startTime) / 1000); }
```

`millis()` always counts up from zero. `millis() - startTime` gives the elapsed milliseconds since the level began. Dividing by 1000 converts to seconds. Subtracting from `timeLimit` gives seconds remaining. `max(0, ...)` stops it going negative.

---

### display()

```java
void display() {
  background(#a8d8ea);   // sky-blue wash every frame (clears previous drawing)
  canal.display();
  ship.display();

  fill(255); textSize(18); textAlign(LEFT);
  text("Level " + level, 20, 30);

  textAlign(RIGHT);
  fill(timeLeft() < 6 ? #e74c3c : 255);   // red when under 6 seconds
  text("Time: " + timeLeft() + "s", width - 20, 30);

  if (state != 1) drawOverlay();
}
```

`background(#a8d8ea)` is called first — it repaints the whole canvas, which is how Processing animates things (paint over the old frame). Everything drawn after that appears on top.

The timer text turns red (`#e74c3c`) when under 6 seconds — another ternary if-else for the fill colour.

`drawOverlay()` is only called when NOT playing (state ≠ 1).

---

### drawOverlay()

```java
void drawOverlay() {
  fill(0, 150); rect(0, 0, width, height);   // semi-transparent black cover
  fill(255); textAlign(CENTER);
  if (state == 0) text("Hover over the ship to start Level " + level, width/2, height/2);
  if (state == 2) text("Level Cleared! Click to continue.", width/2, height/2);
  if (state == 3) { fill(#e74c3c); text("Shipwreck! Click to retry.", width/2, height/2); }
  if (state == 4) { fill(#f1c40f); text("You Beat the Game! Click to reset.", width/2, height/2); }
}
```

`fill(0, 150)` uses the two-argument version of `fill()` — first arg is greyscale (0 = black), second is alpha (0–255). 150 gives a semi-transparent dim.

Each `if` is **independent** — Processing checks all four. Only one will match at a time because the states are mutually exclusive.

---

### handleClick()

```java
void handleClick() {
  if (state == 2) { level++; loadLevel(); }
  else if (state == 3) loadLevel();
  else if (state == 4) { level = 1; loadLevel(); }
}
```

Responds to mouse clicks depending on state:
- CLEAR (2): Advance to next level, reload
- LOSE (3): Retry same level (level number stays the same)
- FINISH (4): Reset to level 1

Clicking during WAIT (0) or PLAY (1) does nothing — those states are simply not handled.

---

## Ship.pde — The Ship class

### Fields

```java
float x, y, r = 14, noiseOff;
float smooth = 0.06;
```

| Variable | Purpose |
|----------|---------|
| `x, y` | Position on screen |
| `r` | Radius (14px) — used for drawing and collision |
| `noiseOff` | The "noise offset" — a moving input into the Perlin noise function |
| `smooth` | How quickly the ship catches up to the mouse (lower = more lag) |

These are **instance variables** (fields) — every Ship object has its own copy.

---

### Constructor

```java
Ship(float x, float y) {
  this.x = x; this.y = y;
  noiseOff = random(1000);
}
```

`this.x` refers to the field; the plain `x` is the **parameter**. Using `this.` distinguishes them. `random(1000)` gives each ship a unique starting point in Perlin noise space, so drift looks different each run.

---

### update()

```java
void update() {
  float dx = map(noise(noiseOff), 0, 1, -3, 3);
  float dy = map(noise(noiseOff + 500), 0, 1, -3, 3);
  noiseOff += 0.05;

  x += (mouseX - x) * smooth + dx;
  y += (mouseY - y) * smooth + dy;
}
```

**Step 1 — Drift noise:**
- `noise(noiseOff)` returns a smooth random value between 0 and 1 (Perlin noise — unlike `random()`, adjacent calls return nearby values, not wild jumps)
- `map(value, 0, 1, -3, 3)` rescales that 0–1 range to –3 to +3, giving a drift speed in pixels
- `noiseOff + 500` uses a different position in noise space for y, so x and y drift independently
- `noiseOff += 0.05` advances through noise space each frame, making the drift smoothly evolve

**Step 2 — Smooth follow:**
- `(mouseX - x) * smooth` is the key formula: it moves the ship *smooth fraction* of the remaining distance to the mouse each frame. With smooth = 0.06, it covers 6% of the gap every frame — producing an easing effect, not instant snapping
- `+ dx` adds the Perlin drift on top

---

### isHovered()

```java
boolean isHovered() { return dist(mouseX, mouseY, x, y) < r + 15; }
```

`dist()` calculates the straight-line distance between the mouse and ship centre. Returns `true` if the mouse is within `r + 15 = 29` pixels — a slightly larger hit area than the visual radius for usability.

---

### display()

```java
void display() {
  fill(#f39c12); stroke(#d35400); strokeWeight(3);
  ellipse(x, y, r*2, r*2);
}
```

Draws an orange circle centred at (x, y) with diameter `r*2 = 28px` and a darker orange border (strokeWeight 3). Processing's `ellipse()` takes x, y, **width, height** — so we double the radius.

---

## Canal.pde — The Canal class

### Fields

```java
PVector[] waypoints;
float roadWidth;
int levelTime = 10;
ArrayList<PVector> path = new ArrayList<PVector>();
```

| Variable | Purpose |
|----------|---------|
| `waypoints` | Array of corner points defining the canal route |
| `roadWidth` | Half-width of the canal (narrower = harder) |
| `levelTime` | Time limit in seconds (same for all levels currently) |
| `path` | Dense list of sampled points along the canal, used for collision |

`PVector` is Processing's built-in 2D/3D point class — it holds x and y together.

---

### Constructor — level layouts

```java
Canal(int lvl) {
  switch(lvl) {
    case 1: roadWidth = 60; waypoints = new PVector[]{ new PVector(80,275), new PVector(720,275) }; break;
    case 2: roadWidth = 50; waypoints = new PVector[]{ new PVector(80,150), new PVector(400,400), new PVector(720,400) }; break;
    case 3: roadWidth = 35; waypoints = new PVector[]{ ... }; break;
    case 4: roadWidth = 35; waypoints = new PVector[]{ ... }; break;
    default: roadWidth = 28; waypoints = new PVector[]{ ... };   // Level 5
  }
  ...
}
```

A `switch` on the level number selects the layout. Each level:
- Defines corner `waypoints` (the route the canal follows)
- Sets `roadWidth` (narrower = harder)

`new PVector(80, 275)` creates a point at x=80, y=275. The `new PVector[]{ ... }` syntax creates an **array** of PVectors in one line.

---

### Path sampling (the for loop)

```java
for (int i = 0; i < waypoints.length - 1; i++) {
  for (float t = 0; t <= 1; t += 0.05)
    path.add(PVector.lerp(waypoints[i], waypoints[i+1], t));
}
```

**The problem:** Checking if the ship is inside the canal by only looking at the 2–8 corner waypoints wouldn't work for diagonal segments. We need points along the entire path.

**The solution — linear interpolation (lerp):**
- The outer `for` loop steps through each pair of adjacent waypoints (i → i+1)
- The inner `for` loop samples `t` from 0 to 1 in steps of 0.05 (21 samples per segment)
- `PVector.lerp(A, B, t)` computes the point that is `t` fraction of the way from A to B:
  - t=0 → point A
  - t=0.5 → midpoint
  - t=1 → point B
- All those sampled points go into `path` (an ArrayList)

Result: `path` contains dozens of evenly-spaced points tracing every canal segment.

---

### hitsWall()

```java
boolean hitsWall(Ship s) {
  float minDist = Float.MAX_VALUE;
  for (PVector p : path) minDist = min(minDist, dist(s.x, s.y, p.x, p.y));
  return minDist > roadWidth - s.r * 0.5;
}
```

**Algorithm:**
1. Start `minDist` at the largest possible float value (so any real distance is smaller)
2. Loop through every sampled path point using a **for-each** loop — `for (PVector p : path)` reads "for each PVector p in path"
3. Keep updating `minDist` to be the smallest distance found
4. After the loop, `minDist` = distance from ship centre to the nearest canal centre-line point
5. If that distance exceeds `roadWidth - ship.r * 0.5`, the ship's edge has crossed the canal wall → return true (wall hit)

The `- s.r * 0.5` gives the ship a slight grace margin so the orange circle has to actually overlap the wall before dying.

---

### isDone()

```java
boolean isDone(Ship s) {
  PVector end = waypoints[waypoints.length-1];
  return dist(s.x, s.y, end.x, end.y) < roadWidth;
}
```

Gets the last waypoint (the red end marker) using `waypoints.length - 1` (arrays are zero-indexed, so the last item is at index length-1). Returns true if the ship is within `roadWidth` pixels of the end.

---

### display()

```java
void display() {
  noFill(); stroke(#1a5276); strokeWeight(roadWidth * 2);
  beginShape();
  for (PVector p : waypoints) vertex(p.x, p.y);
  endShape();

  drawMarker(waypoints[0], #27ae60);
  drawMarker(waypoints[waypoints.length-1], #e74c3c);
}
```

`strokeWeight(roadWidth * 2)` is the trick: Processing draws a line with thickness equal to the stroke weight. By setting it to `roadWidth * 2`, the line is exactly the visual canal width. `beginShape()` / `endShape()` with `vertex()` draws a connected polyline through all waypoints.

`drawMarker()` is called twice — once with the first waypoint (green start) and once with the last (red end). This is **parameter passing** — the same method works for both markers by accepting the position and colour as parameters.

---

### drawMarker() — private sub-program

```java
private void drawMarker(PVector p, int c) {
  fill(c); noStroke(); ellipse(p.x, p.y, 40, 40);
}
```

A small, well-named method that does exactly one thing: draws a coloured 40px dot at point `p`. The `private` keyword means it can only be called from inside the Canal class — it's an internal helper, not part of the public interface.

---

## Key concepts demonstrated — quick reference

| Concept | Where |
|---------|-------|
| **Classes & Objects** | `Ship`, `Canal`, `Game` — each has fields + methods; created with `new` |
| **Iteration** | `for` in Canal constructor (path sampling), `for-each` in hitsWall(), `for` in display() |
| **Selection** | `if/else if` in Game.update(), switch in Canal constructor, ternary `? :` in update() and display() |
| **Global variables** | `Game game` in main sketch; `state`, `level`, `canal`, `ship` in Game class |
| **Local variables** | `dx`, `dy`, `minDist`, `t`, `i`, `end` — live only inside their method |
| **Parameter passing** | `new Ship(x, y)`, `new Canal(level)`, `drawMarker(p, colour)` |
| **Sub-programs** | `update()`, `display()`, `loadLevel()`, `handleClick()`, `hitsWall()`, `isDone()`, `drawMarker()` |
