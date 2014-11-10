/*
 High Score
 Shots fired
 Asteroids destroyed
 Deaths
 */
int[] stats;

void switchtoStats() {
  noLoop();
  clearGame();
  setupField();

  for (int i = 0; i < 32; i++) // Background asteroids
    actors.add(new Asteroid(random(width), random(height), random(20, 120), 2, random(0, 2*PI)));

  buttons = new ArrayList(); // Adding buttons
  buttons.clear();

  buttons.add(new Button(width/2-128, height/2+128, 256, color(210, 255, 192), "Main Menu", 4));
  buttons.add(new Button(width/2-128, height/2+64, 256, color(210, 255, 192), "Reset", 12));
  target = null;

  paused = false;
  loop();
  screen = 3;
}

void stats() {
  renderField(); // background asteroids

  for (Button b : buttons)
    b.render();

  fill(210, 255, 192);
  if (showGrid) { // Cross about the center used to help line up menu elements
    strokeWeight(2*SCALE);
    stroke(210, 255, 255);
    line(width/2, 0, width/2, height);
    line(0, height/2, width, height/2);
  }
  textFont(f48); // Title Text
  text("STATISTICS", width/2-160, height/6);

  textFont(f36);
  text("HIGH SCORE", width/2-200, height/2-80);
  text(stats[0], width/2+160, height/2-80);

  text("SHOTS FIRED", width/2-200, height/2-40);
  text(stats[1], width/2+160, height/2-40);

  text("ROCKS KILLED", width/2-200, height/2);
  text(stats[2], width/2+160, height/2);

  text("TOTAL DEATHS", width/2-200, height/2+40);
  text(stats[3], width/2+160, height/2+40);

  textFont(f12); // Version number
  text("Version: "+version, width-384, height-8);
}


void saveStats() {
  String temp[] = {
    join(nf(stats, 0), ',')
    };
    saveStrings("data/stats.txt", temp);
}

void readStats() {
  stats = int(split(loadStrings("stats.txt")[0], ','));
}

