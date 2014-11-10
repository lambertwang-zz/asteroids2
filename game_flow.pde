int score = 0; // Alternatively, number of explosions generated
boolean dead = false;
boolean paused = false;

// Resets the game
void resetGame() {
  setupField();
  setupEffects();
  setupElements();
  if (paused)
    pause();
  dead = false;
  score = 0;

  for (int i = 0; i < INITAST && asteroidNum () < ASTEROIDNUM; i++)
    spawnAst(0, 80, 128); // spawns starting asteroids
}

void clearGame() { // Clears the field
  actors = new ArrayList();
  effects = new ArrayList();
  mercury = null;
}

void play() { // The runtime of the game
  screenShake(); // Shakes the screen
  pushMatrix(); // Matrix for the screen following
  if (mercury != null) {
    origin.set(mercury.last.x-width/2, mercury.last.y-height/2);
    origin.add(mercury.vel.x*32, mercury.vel.y*32, 0);
    translate(-origin.x, -origin.y);
  }
  renderEffects();
  renderField();
  popMatrix(); // Rendering ends here and status text begins
  score();
  if (dead) gameOver(); // Checks if you exploded or not
}

void pause() { // Toggles paused and unpaused states
  if (paused) {
    loop();
    paused = false;
  } else {
    textFont(f24);
    fill(75, 255, 192);
    text("PAUSED", width/2-46, height/2-64);
    text("R restart", width/2-70, height/2);
    text("M to menu", width/2-70, height/2+32);
    noLoop();
    paused = true;
  }
}

void death() { // Big explosion on death
  effects.add(new Explosion(mercury.pos.x, mercury.pos.y, width/8));
  shake.set(shipSize, shipSize);
  removal.add(mercury);
  if (!debug) {
    if (score > stats[0])
      stats[0] = score;
    stats[3]++;
    saveStats();
  }
  dead = true;
}

void gameOver() {
  textFont(f24); // Shows some sad messages when you have let down all of humanity
  fill(75, 255, 192);
  text("GAME OVER", width/2-70, height/2-32); 
  text("R restart", width/2-70, height/2);
  text("M to menu", width/2-70, height/2+32);
}

