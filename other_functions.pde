// FixedSys
/* @pjs font="data/fixed.ttf"; */
PFont f12, f24, f36, f48;

void setupFont() {
  // fonts are different in javascript mode
  // Font used is fixedsys
  f12 = loadFont("Fixed_12.vlw");
  f24 = loadFont("Fixed_24.vlw");
  f36 = loadFont("Fixed_36.vlw");
  f48 = loadFont("Fixed_48.vlw");
  // font = createFont("fixed_v01", 48);
}

// Shows FPS
void fps() {
  if (SCALE > 1.5) { // Font scaling (needs more testing)
    textFont(f24);
  } else textFont(f12);
  fill(0); // Improve readability by drawing the text offset 1 pixel in black behind the actual text
  text("FPS: "+int(frameRate*100)/100.0, width-195, height-7);
  text("FPS: "+int(frameRate*100)/100.0, width-197, height-9);
  fill(75, 255, 192);
  text("FPS: "+int(frameRate*100)/100.0, width-196, height-8);
}

// Shows Score and lasers
void score() {
  if (SCALE > 1.5) {
    textFont(f24);
  } else textFont(f12);
  fill(0);
  text("Score: "+score, 17, 32*SCALE+1);
  text("Score: "+score, 15, 32*SCALE-1);
  fill(75, 255, 192);
  text("Score: "+score, 16, 32*SCALE);

  fill(0);
  text("Lasers:", 17, 16*SCALE+49);
  text("Lasers:", 15, 16*SCALE+47);
  fill(75, 255, 192);
  text("Lasers:", 16, 16*SCALE+48);
  for (int i = 0; i < 8; i++) 
    if (arsenal[i]) {
      fill(0);
      text(names[i], 17, 65+(16*(i+1))*SCALE);
      text(names[i], 15, 63+(16*(i+1))*SCALE);
      fill(75, 255, 192);
      text(names[i], 16, 64+(16*(i+1))*SCALE);
    }
}

// Returns the sign of a number
float signum(float n) {
  return n > 0 ? 1 : n < 0 ? -1 : 0;
} // Currently only used in shake

// Returns the number of asteroids
int asteroidNum() {
  int ret = 0;
  for (Object o : actors)
    if (o instanceof Asteroid)
      ret++;
  return ret;
}

void screenShot() {
  background(0);

  pushMatrix(); // Matrix for the screen following
  translate(-origin.x, -origin.y);
  for (Particle p : effects)
    p.render();
  for (Object o : actors)
    o.render();
  popMatrix();

  save("screenshots/screenshot-"+day()+month()+year()+"-"+hour()+minute()+second()+".png");
}

