/*
 * Created by Radek Hulka
 * Description: Minesweeper game. 
 *              You can reveal field using LEFT mouse button. But if you reveal mine, you lose...
 *              You have to flagg all mines using RIGHT mouse button and reveal all other fields.     
 */

//TODO - firework if win
//TODO - flood fill
//TODO - comment + optimalization

int boxSize;
int menuHeight;
int minesLeft;
Field mineField;
Menu menu;
int difficulty;
int bestTimeEasy, bestTimeMedium, bestTimeExpert;
final int minesEasy = 12;
final int minesMedium = 60;
final int minesExpert = 150;
boolean firstClick;
Firework firework;
boolean gameover;

// setup for window size, number of mines, collumns, rows and fieldes size
void setup() {
  size(601, 661);
  difficulty = 20;
  gameover = false;
  menuHeight = 60;
  bestTimeEasy = 2147483647;
  bestTimeMedium = bestTimeEasy;
  bestTimeExpert = bestTimeMedium;
  mineField = new Field();
  menu = new Menu();
  frameRate(30);
}

// function for drawing game field and statistics
void draw() {
  if (!gameover) {
    mineField.display();
  }
  menu.display();
}

// function for players actions
void mousePressed() {
  if (mouseY < 60) {
    if (mouseY > 10 && mouseY < 50 && mouseX > 230 && mouseX < 430) {
      mineField = new Field();
      menu = new Menu();
    } else if (mouseY > 7 && mouseY < 22 && mouseX > 130 && mouseX < 190) {
      difficulty = 10;
      menu.display();
    } else if (mouseY > 22 && mouseY < 31 && mouseX > 130 && mouseX < 190) {
      difficulty = 20;
      menu.display();
    } else if (mouseY > 31 && mouseY < 46 && mouseX > 130 && mouseX < 190) {
      difficulty = 30;
      menu.display();
    }
  } else if (mouseX < width - 1 && mouseY < height -1) {
    if (mouseButton == LEFT) {
      mineField.reveal();
      mineField.checkWin();
    } else if (mouseButton == RIGHT) {
      mineField.flag();
      mineField.checkWin();
    }
  }
}
