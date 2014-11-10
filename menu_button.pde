// Square buttons for the menu
class Button {
  float posx, posy, size; // Size is width
  color col; // Color
  String text;
  int button; // The index for what to do when the button is clicked
  boolean hover; // Whether or not the button is hovered over

    Button(float tx, float ty, float ts, color tcol, String tt, int tb) { // Large constructor caller because why not
    posx = tx; 
    posy = ty; 
    size = ts; 
    col = tcol;
    text = tt;
    button = tb;
    hover = false;
  }

  void render() {
    pushMatrix();
    translate(posx, posy);
    if (mouseX > posx && mouseX < posx+size && mouseY > posy && mouseY < posy+64) // Check hover
      hover = true;
    else {
      hover = false;
      if (target == this)
        target = null;
    }

    if (hover)
      if (mousePressed) { // This really shouldn't be done here
        fill(128);
        target = this; // On click
      } else
        fill(64);
    else
      fill(0, 0); // Transparent

    strokeWeight(3.5);
    stroke(col);
    rect(0, 0, size, 56);

    fill(col);
    textFont(f36);
    text(text, size/2 - text.length()*13.3, 44);

    popMatrix();
  }

  void click() {
    switch(button) {
    case 0: // Begin game
      clearGame();
      resetGame();
      screen = 1;
      break;
    case 1: // Stats
      break;
    case 2: // Settings
      switchtoSettings();
      break;
    case 3: // exit game
      saveOptions();
      saveStats();
      exit();
    case 4: // Main Menu
      switchtoMenu();
      break;
    case 5: // Increase graphics
      GRAPHICS = GRAPHICS% 5 + 1;
      switchtoSettings();
      break;
    case 6: // Decrease graphics
      noLoop();
      clearGame();
      GRAPHICS = (GRAPHICS+3)% 5 +1;
      switchtoSettings();
      break;
    case 7:
      debug = !debug;
      text = "Debug:"+(debug ? "ON " : "OFF");
      break;
    case 8:
      showCells = !showCells;
      text = "Cells:"+(showCells ? "ON " : "OFF");
      break;
    case 9:
      showGrid = !showGrid;
      text = "Grid :"+(showGrid ? "ON " : "OFF");
      break;
    case 10:
      showFPS = !showFPS;
      text = "FPS  :"+(showFPS ? "ON " : "OFF");
      break;
    case 11: // Statistics
      switchtoStats();
      break;
    case 12: // Reset Statistics
      text = "Really?";
      button = 13;
      break;
    case 13: // Confirmation for resetting stats
      text = "Done!";
      button = 12;
      for (int i = 0; i < 4; i++)
        stats[i] = 0;
      break;
    }
  }
}

