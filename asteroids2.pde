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

