void switchtoSettings() {
  noLoop();
  clearGame();
  setupField();

  for (int i = 0; i < 32; i++) // Background asteroids
    actors.add(new Asteroid(random(width), random(height), random(20, 120), 1, random(0, 2*PI)));

  buttons = new ArrayList(); // Adding buttons
  buttons.clear();
  buttons.add(new Button(width/2+28, height/2-128, 64, color(120, 255, 192), ">", 5)); // Graphics
  buttons.add(new Button(width/2-100, height/2-128, 64, color(120, 255, 192), "<", 6));
  buttons.add(new Button(width/2-320, height/2-64, 256, color(120, 255, 192), "Debug:"+(debug ? "ON " : "OFF"), 7)); //Debug mode
  buttons.add(new Button(width/2-320, height/2, 256, color(120, 255, 192), "Cells:"+(showCells ? "ON " : "OFF"), 8)); // Showcells
  buttons.add(new Button(width/2-320, height/2+64, 256, color(120, 255, 192), "Grid :"+(showGrid ? "ON " : "OFF"), 9)); // Show grid
  buttons.add(new Button(width/2-320, height/2+128, 256, color(120, 255, 192), "FPS  :"+(showFPS ? "ON " : "OFF"), 10)); // Show fps
  buttons.add(new Button(width/2+32, height/2, 256, color(120, 255, 192), "Main Menu", 4));
  target = null;

  paused = false;
  loop();
  screen = 2;
}

void settings() {
  renderField(); // background asteroids

  for (Button b : buttons)
    b.render();

  fill(120, 255, 192);
  if (showGrid) { // Cross about the center used to help line up menu elements
    strokeWeight(2*SCALE);
    stroke(120, 255, 255);
    line(width/2, 0, width/2, height);
    line(0, height/2, width, height/2);
  }
  textFont(f48); // Title Text
  text("SETTINGS", width/2-144, height/6);
  
  textFont(f36); //Graphics setting
  text(GRAPHICS, width/2-16, height/2-84);
  text("Graphics", width/2-320, height/2-80);
  
  
  textFont(f12); // Version number
  text("Version: "+version, width-384, height-8);
  
  if(debug)
    text("Stats will not be recorded", width/2-48, height/2-16);
}

