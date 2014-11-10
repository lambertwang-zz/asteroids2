int screen = 0; // Screen state
/* 
 0 = menu
 1 = game
 2 = settings
 */
ArrayList<Button> buttons;
Button target; // Button currently being clicked
SideBar instructions;

void switchtoMenu() {
  noLoop();
  clearGame();
  setupField();

  for (int i = 0; i < 32; i++) // Background asteroids
    actors.add(new Asteroid(random(width), random(height), random(20, 120), 0, random(0, 2*PI)));

  buttons = new ArrayList(); // Adding buttons
  buttons.clear();
  buttons.add(new Button(width/2-288, height/2-64, 256, color(75, 255, 192), "Play", 0));
  buttons.add(new Button(width/2-288, height/2, 256, color(75, 255, 192), "Stats", 11));
  buttons.add(new Button(width/2+32, height/2-64, 256, color(75, 255, 192), "Settings", 2));
  buttons.add(new Button(width/2+32, height/2, 256, color(75, 255, 192), "Quit", 3));
  target = null;

  instructions = new SideBar(width-320, width-32, 0); // Instructions sidebar

  paused = false;
  loop();
  screen = 0;
}

void menu() {
  renderField(); // background asteroids

  for (Button b : buttons)
    b.render();

  fill(75, 255, 192);
  if (showGrid) { // Cross about the center used to help line up menu elements
    strokeWeight(2*SCALE);
    stroke(75, 255, 255);
    line(width/2, 0, width/2, height);
    line(0, height/2, width, height/2);
  }
  textFont(f48); // Title Text
  text("ASTEROIDS 2", width/2-195, height/4);
  textFont(f24); // Credit Text
  text("Coded by Lambert Wang", width/2-195, height/4+24);

  textFont(f12); // Version number
  text("Version: "+version, width-384, height-8);
  instructions.render();
}

