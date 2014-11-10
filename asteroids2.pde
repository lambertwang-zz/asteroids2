//  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   //////               ___   ___  ___  ___   ___       ___        __                                 ___   ___     ____   ____  //////
//    ////     .'|=|`.   |   |=|_.' `._|=|   |=|_.'  .'|=|_.'   .'|=|  |   .'|=|`.     .'|   .'|=|`.   |   |=|_.'    '.   |=|   .'  ////
//     //    .'  | |  `. `.  |           |   |     .'  |  ___ .'  | |  | .'  | |  `. .'  | .'  | |  `. `.  |           | |' '| |     //
//     //    |   |=|   |   `.|=|`.       |   |     |   |=|_.' |   |=|.'  |   | |   | |   | |   | |   |   `.|=|`.       | |   | |     //
//     //    |   | |   |  ___  |  `.     `.  |     |   |  ___ |   |  |`. `.  | |  .' |   | |   | |  .'  ___  |  `.     | |. .| |     //
//    ////   |___| |___|  `._|=|___|       `.|     |___|=|_.' |___|  |_|   `.|=|.'   |___| |___|=|.'    `._|=|___|   .'___|=|___'.  ////
//   //////                                                                                                                        //////
//  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
  Asteroids 2, 2014
 Author: Lambert Wang
 */

String version = "Beta 1.3";

/*
Version Log: (Small changes omitted and bug fixes omitted)
 Beta 1.3:
 Added Stats
 You can now save and load settings and stats
 Added repulsor asteroids
 
 Balance:
 Reduced spawn rate of special asteroids
 Reduced fire rate of chaos gun
 Increased fire rate of triple, penta, beam gun, and railgun
 
 Beta 1.2:
 Added bonus aseroids (Lasers now obtainable)
 Implemented arsenal UI
 Added CHAOSGUN and Splitter lasers
 
 Beta 1.1:
 Added 5 unique lasers (6 unique, 8 total)
 Added comments
 Added Stats, settings, and exit button (currently only exit and play working)
 New Lasers currently only accessible via debug controls
 Added a instructions sidebar to the menu
 Added settings
 Added two asteroid types (Seekers, ragers)
 
 Beta 1.0:
 Initial beta release
 1 asteroid type
 1 laser type
 1 ship
 1 menu button
 Pause
 */

/*
  to do: 
 
 Sound (minim?)
 
 Game Elements:
 Powerups
 Asteroid Types (4 Done)
 Laser Types (8 Done)
 
 
 Menus (done)
 Buttons (done)
 Statistics (done)
 Options (done)
 
 Scaling text
 
 Comments
 
 */

/*
  Commenting Status: Good/OK/Bad/None
 effects          OK
 field            Good
 field_asteroids  Bad
 field_laser      Bad
 field_objects    Good
 field_ship       Bad
 game_flow        OK
 input            OK
 menu             OK
 menu_button      OK
 options          Good
 other_functions  Good
 */

/*
 known glitches and issues:
 Random frame drops during menu
 Screen shakes will overwrite the previous shake
 Explosion effects generate in a square area (IDGAF)
 showCells draws over effects (IDGAF)
 
 Fixed:
 Data will not be saved if people don't use the quit button from the menu
 Menu asteroids edge teleporting
 Clicking menu buttons in between input frames doesn't activate the button
 MAJOR Concurrent modification exception while changing to menu (Happens when non-runtime modification of actors and effects happens at the same time as the runtime moditication)
 Collisions near edges where one object is near lmax and other object is near lmin (Fixed, could be better)
 Text readability (Redrawing the text in black slightly offset from the original text)
 */

void setup() {
  //size(768, 432);
  size(int(SCALE*SWIDTH), int(SCALE*SHEIGHT));
  smooth();
  colorMode(HSB);
  frameRate(60);

  readOptions();
  readStats();

  setupFont();
  resetGame();
  switchtoMenu(); // Starts game at the menu screen
}

void draw() {
  background(0);
  switch(screen) {
  case 1:
    play();
    break;
  case 0: 
    menu();
    break;
  case 2:
    settings();
    break;
  case 3:
    stats();
    break;
  }
  if (showFPS)
    fps();
}

