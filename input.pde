// All keypresses and keyreleased are stored in booleans because key ghosting is a thing
boolean upkey = false;
boolean downkey = false;
boolean leftkey = false;
boolean rightkey = false;

boolean firekey = false;

void keyPressed() {
  if (screen == 1) { // Input during game play
    if (key == CODED) // Non-ascii keys are coded (arrow keys, alt, ctrl, enter)
      switch(keyCode) {
      case UP:
        upkey = true;
        break;
      case DOWN:
        downkey = true;
        break;
      case LEFT: // Null movement (one key will overwrite the other direction when pressed)
        leftkey = true;
        rightkey = false;
        break;
      case RIGHT:
        rightkey = true;
        leftkey = false;
        break;
      } else if (key == 'w' || key == 'W')
      upkey = true;
    else if (key == 's' || key == 'S')
      downkey = true;
    else if (key == 'a' || key == 'A') {
      leftkey = true;
      rightkey = false;
    } else if (key == 'd' || key == 'D') {
      rightkey = true;
      leftkey = false;
    } else if (key == 'c' || key == 'C') {
      if (debug) { // Debug command
        //for (int i = 0; i < 16 && asteroidNum () < ASTEROIDNUM; i++)
        spawnAst(3, 80, 128);
        //Asteroid temp = new Asteroid(width/2, 20, 128, 0, 0);
        //temp.last.set(temp.pos.x, temp.pos.y);
        //actors.add(temp);
      }
    } else if (key == 'f' || key == 'F')
      firekey = true;
    else if (key == ' ')
      firekey = true;
    else if (key == 'p' || key == 'P')
      pause();
    else if (key == 'r' || key == 'R')
      resetGame();
    else if (key == 'm' || key == 'M') {
      if (paused || dead)
        switchtoMenu();
    } else if (key >= 49 && key <= 56) // Pressing 1-8 will change weapons
      if (arsenal[key-49] || debug) // Gives all weapons in debug mode
        mercury.type = key-49;
  }
}

void keyReleased() {
  if (screen == 1) {
    if (key == CODED)
      switch(keyCode) {
      case UP:
        upkey = false;
        break;
      case DOWN:
        downkey = false;
        break;
      case LEFT:
        leftkey = false;
        break;
      case RIGHT:
        rightkey = false;
        break;
      } else if (key == 'w' || key == 'W')
      upkey = false;
    else if (key == 's' || key == 'S')
      downkey = false;
    else if (key == 'a' || key == 'A') 
      leftkey = false;
    else if (key == 'd' || key == 'D')
      rightkey = false;
    else if (key == 'f' || key == 'F')
      firekey = false;
    else if (key == ' ')
      firekey = false;
  }
}

void mouseReleased() {
  if (screen != 1)
    if (target != null)
      target.click();
}

