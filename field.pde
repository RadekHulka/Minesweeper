import java.util.concurrent.TimeUnit;

class Field {
  // number of mines, collumns, rows
  int mines, cols, rows;

  // array for fieldes
  FieldBox[] fieldBoxes;

  // variable for mine hit detection and win detection
  boolean mineHit, win;

  // constructor
  Field() {
    cols = difficulty;
    rows = difficulty;
    boxSize = 600 / difficulty;
    switch (difficulty) {
      case (10): 
      mines = minesEasy; 
      break;
      case (20): 
      mines = minesMedium; 
      break;
      case (30): 
      mines = minesExpert; 
      break;
    }
    minesLeft = mines;
    gameover = false;
    firstClick = false;
    win = false;
    mineHit = false;
    initializeFieldBoxes();
  }

  // initialize all fields of mine field
  void initializeFieldBoxes() {
    fieldBoxes = new FieldBox[cols * rows];

    for (int i = 0; i < (cols * rows); i++) {
      fieldBoxes[i] = new FieldBox();
    }
  }

  // generate mine fieldes
  void generateMines() {

    // coorditnates of the field, where is mouse cursor
    int mouseCol = (int) mouseX / boxSize;
    int mouseRow = (int) (mouseY - menuHeight) / boxSize;
    int fieldIndex = cols * mouseRow + mouseCol;

    // cycle for placing all mines
    for (int i = 0; i < mines; i++) {
      boolean placed = false;

      // until a mine is not placed
      while  (!placed) {

        // chose random field
        int randomCol = (int)random(0, cols);
        int randomRow = (int)random(0, rows);

        // if the field is empy, mine is placed and we can continue to next mine
        if (!fieldBoxes[cols * randomRow + randomCol].mine && fieldIndex != (cols * randomRow + randomCol)) {
          fieldBoxes[cols * randomRow + randomCol].mine = true;
          placed = true;
        }
      }
    }
  }

  // generate number fieldes
  void generateNumbers() {

    // go through all field, if there is no mine, nearby mines are counted and the number is assigned to this field
    for (int i = 0; i < (rows * cols); i++) {
      if (!fieldBoxes[i].mine) {
        int nearbyMines = 0;

        // upper neighbor
        if (i - cols >= 0) {
          if (fieldBoxes[i - cols].mine) {
            nearbyMines++;
          }
        } 

        // lower neighbor
        if (i + cols < rows * cols) {
          if (fieldBoxes[i + cols].mine) {
            nearbyMines++;
          }
        } 

        // right neighbor
        if (i + 1 < rows * cols  && i % cols != cols - 1) {
          if (fieldBoxes[i + 1].mine) {
            nearbyMines++;
          }
        } 

        // left neighbor
        if (i - 1 >= 0 && i % cols != 0) {
          if (fieldBoxes[i - 1].mine) {
            nearbyMines++;
          }
        } 

        // left lower neighbor
        if (i - 1 + cols >= 0 && i - 1 + cols < rows * cols && i % cols != 0) {
          if (fieldBoxes[i - 1 + cols].mine) {
            nearbyMines++;
          }
        } 

        // left upper neighbor
        if (i - 1 - cols >= 0 && i % cols != 0) {
          if (fieldBoxes[i - 1 - cols].mine) {
            nearbyMines++;
          }
        } 

        // right lower neighbor
        if (i + 1 + cols < rows * cols  && i % cols != cols - 1) {
          if (fieldBoxes[i + 1 + cols].mine) {
            nearbyMines++;
          }
        } 

        // right upper neighbor
        if (i + 1 - cols >= 0 && i + 1 - cols < rows * cols  && i % cols != cols - 1) {
          if (fieldBoxes[i + 1 - cols].mine) {
            nearbyMines++;
          }
        }

        fieldBoxes[i].numberOfNearbyMines = nearbyMines;
      }
    }
  }

  // display game field
  void display() {

    // if mine was hit
    if (mineHit) {
      gameover = true;
      displayGameOver();

      // if mine was not yet hit
    } else {
      displayProgress();
    }
  }

  // display game field, when mine was hit
  void displayGameOver() {

    // go through all fields
    for (int i = 0; i < (rows * cols); i++) {

      // coordinates of the upper left corner of the field
      int fieldBoxX = (i * boxSize) % (width - 1);
      int fieldBoxY = (i * boxSize) / (width - 1) * boxSize;

      // if field is field with mine
      if (fieldBoxes[i].mine) {
        drawMineField(fieldBoxX, fieldBoxY + menuHeight);
        if (fieldBoxes[i].flagged) {
          drawFlag(fieldBoxX, fieldBoxY + menuHeight);
        }

        // if field is flagged field
      } else  if (fieldBoxes[i].flagged) {
        fill(200 + (fieldBoxX + fieldBoxY + menuHeight) / 55 * (400 / 55), 220, 150);
        stroke(0);
        rect(fieldBoxX, fieldBoxY + menuHeight, boxSize, boxSize);
        drawFlag(fieldBoxX, fieldBoxY + menuHeight);
        stroke(255, 0, 0);
        line(fieldBoxX + boxSize / 2 - 10, fieldBoxY + menuHeight + boxSize / 2 - 10, fieldBoxX + boxSize / 2 + 10, fieldBoxY + menuHeight + boxSize / 2 + 10);
        line(fieldBoxX + boxSize / 2 - 10, fieldBoxY + menuHeight + boxSize / 2 + 10, fieldBoxX + boxSize / 2 + 10, fieldBoxY + menuHeight + boxSize / 2 - 10);

        // if field is field with number
      } else {
        drawNumberField(fieldBoxX, fieldBoxY + menuHeight, fieldBoxes[i].numberOfNearbyMines);
      }
    }

    // print win of lost..
    if (win) {
      menu.newBest();
      firework = new Firework();
      firework.display();
    }
  }

  // display game field, when mine was not hit
  void displayProgress() {

    // go through all fields
    for (int i = 0; i < (rows*cols); i++) {

      // coordinates of the upper left corner of the field
      int fieldBoxX = (i * boxSize) % (width - 1);
      int fieldBoxY = (i * boxSize) / (width - 1) * boxSize;

      // if field is revealed or flagged
      if (fieldBoxes[i].revealed || fieldBoxes[i].flagged) {
        if (fieldBoxes[i].flagged) {
          drawFlaggedField(fieldBoxX, fieldBoxY + menuHeight);
        } else {
          drawNumberField(fieldBoxX, fieldBoxY + menuHeight, fieldBoxes[i].numberOfNearbyMines);
        }

        // if field is not flagged or revealed
      } else {
        fill(255, 160, 160 + ((95 * i) / (rows * cols)));
        stroke(0);
        rect(fieldBoxX, fieldBoxY + menuHeight, boxSize, boxSize);
      }
    }
  }

  // draw field with mine, tmpX and tmpY are coordinates of the left upper corner of the field
  void drawMineField(int tmpX, int tmpY) {
    int mouseCol = (int) mouseX / boxSize;
    int mouseRow = (int) (mouseY - menuHeight) / boxSize;

    // background color hit mine
    if (mouseRow == (tmpY - menuHeight)/boxSize && mouseCol == tmpX/boxSize) {
      fill(255, 0, 0);
      stroke(0);
      rect(tmpX, tmpY, boxSize, boxSize);

      //background color of other mines
    } else {
      fill(255, 180, 180);
      stroke(0);
      rect(tmpX, tmpY, boxSize, boxSize);
    }

    drawMine(tmpX, tmpY);
  }

  // draw mine, tmpX and tmpY are coordinates of the left upper corner of the field
  void drawMine(int tmpX, int tmpY) {
    int alfa = 255;

    // if mine was flagged, mine will be transparent - alfa = 127
    if (fieldBoxes[(tmpY - menuHeight)/boxSize * cols + tmpX/boxSize].flagged) {
      alfa = 127;
    }

    // set center of the mine
    tmpX += boxSize / 2;
    tmpY += boxSize / 2;

    // draw parts of mine
    fill(0, alfa);
    stroke(0, alfa);
    ellipse (tmpX, tmpY, 12, 12);
    fill(255, alfa);
    rect(tmpX - 4, tmpY - 4, 4, 4);
    fill(0, alfa);
    triangle(tmpX - 10, tmpY, tmpX - 8, tmpY - 1, tmpX - 8, tmpY + 1);
    triangle(tmpX + 10, tmpY, tmpX + 8, tmpY - 1, tmpX + 8, tmpY + 1);
    triangle(tmpX, tmpY - 10, tmpX - 1, tmpY - 8, tmpX + 1, tmpY - 8);
    triangle(tmpX, tmpY + 10, tmpX - 1, tmpY + 8, tmpX + 1, tmpY + 8);
    triangle(tmpX - 6, tmpY - 6, tmpX - 5, tmpY - 6, tmpX - 6, tmpY - 5);
    triangle(tmpX + 6, tmpY + 6, tmpX + 5, tmpY + 6, tmpX + 6, tmpY + 5);
    triangle(tmpX - 6, tmpY + 6, tmpX - 5, tmpY + 6, tmpX - 6, tmpY + 5);
    triangle(tmpX + 6, tmpY - 6, tmpX + 5, tmpY - 6, tmpX + 6, tmpY - 5);
  }

  // draw flagged field, tmpX and tmpY are coordinates of the left upper corner of the field
  void drawFlaggedField(int tmpX, int tmpY) {
    //stroke(0);
    //fill(0, 200, 0);
    //rect(tmpX, tmpY, boxSize, boxSize);
    drawFlag(tmpX, tmpY);
  }

  // fraw flag, tmpX and tmpY are coordinates of the left upper corner of the field
  void drawFlag(int tmpX, int tmpY) {

    // set center of the flag
    tmpX += boxSize / 2;
    tmpY += boxSize / 2;

    // draw parts of flag
    fill(0);
    stroke(0);
    line (tmpX - 3, tmpY - 10, tmpX - 3, tmpY + 5);
    rect(tmpX - 6, tmpY + 6, 12, 1);
    rect(tmpX - 10, tmpY + 8, 20, 2);
    fill(255, 0, 0);
    triangle(tmpX - 2, tmpY - 10, tmpX - 2, tmpY - 2, tmpX + 7, tmpY - 6);
  }

  // draw numbered field, tmpX and tmpY are coordinates of the left upper corner of the field, tmpNumber is Number of the field
  void drawNumberField(int tmpX, int tmpY, int tmpNumber) {

    // draw background
    fill(55 + ((95 * (tmpX / boxSize + tmpY / boxSize * cols)) / (rows * cols)), 160, 255);
    stroke(0);
    rect(tmpX, tmpY, boxSize, boxSize);

    // text setting
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(20);

    // draw number
    switch (tmpNumber) {
    case 0: 
      break;
    case 1: 
      fill(20, 20, 255);
      text("1", tmpX + boxSize / 2, tmpY + boxSize / 2 - 2);
      break;
    case 2:
      fill(20, 100, 20);
      text("2", tmpX + boxSize / 2, tmpY + boxSize / 2 - 2);
      break;
    case 3:
      fill(255, 20, 20);
      text("3", tmpX + boxSize / 2, tmpY + boxSize / 2 - 2);
      break;
    case 4:
      fill(245, 245, 0);
      text("4", tmpX + boxSize / 2, tmpY + boxSize / 2 - 2);
      break;
    case 5:
      fill(50, 255, 50);
      text("5", tmpX + boxSize / 2, tmpY + boxSize / 2 - 2);
      break;
    case 6:
      fill(150, 80, 255);
      text("6", tmpX + boxSize / 2, tmpY + boxSize / 2 - 2);
      break;
    case 7:
      fill(100, 255, 255);
      text("7", tmpX + boxSize / 2, tmpY + boxSize / 2 - 2);
      break;
    case 8:
      fill(255, 255, 200);
      text("8", tmpX + boxSize / 2, tmpY + boxSize / 2 - 2);
      break;
    }
  }

  // flag the field, where is mouse cursor
  void flag() {

    // coorditnates of the field, where is mouse cursor
    int mouseCol = (int) mouseX / boxSize;
    int mouseRow = (int) (mouseY - menuHeight) / boxSize;
    int fieldIndex = cols * mouseRow + mouseCol;

    // when it is first click --> generate mines
    if (!firstClick) {
      generateMines();
      generateNumbers();
      firstClick = true;
    }

    // if the field is not revealed, than set if is flagged
    if (!mineField.fieldBoxes[fieldIndex].revealed) {

      // count left mines
      if (mineField.fieldBoxes[fieldIndex].flagged) {
        minesLeft++;
      } else {
        minesLeft--;
      }

      mineField.fieldBoxes[fieldIndex].flagged = !mineField.fieldBoxes[fieldIndex].flagged;
    }
  }

  // reveal field/group of fields
  void reveal() {

    // coorditnates of the field, where is mouse cursor
    int mouseCol = (int) mouseX / boxSize;
    int mouseRow = (int) (mouseY - menuHeight) / boxSize;
    int fieldIndex = cols * mouseRow + mouseCol;

    // when it is first click --> generate mines
    if (!firstClick) {
      generateMines();
      generateNumbers();
      firstClick = true;
    }

    // reveal field, where is mouse cursor, if is not flagged
    if (!mineField.fieldBoxes[fieldIndex].flagged) {
      mineField.fieldBoxes[fieldIndex].revealed = true;

      // if revealed field has mine, detect mine hit
      if (mineField.fieldBoxes[fieldIndex].mine) {
        mineField.mineHit = true;
      }

      // check if it is possile to reveal any neighbor
      if (mineField.fieldBoxes[fieldIndex].numberOfNearbyMines == 0) {
        reveal(mouseCol + 1, mouseRow);
        reveal(mouseCol - 1, mouseRow);
        reveal(mouseCol, mouseRow + 1);
        reveal(mouseCol + 1, mouseRow + 1);
        reveal(mouseCol - 1, mouseRow + 1);
        reveal(mouseCol, mouseRow - 1);
        reveal(mouseCol + 1, mouseRow - 1);
        reveal(mouseCol - 1, mouseRow - 1);
      }
    }
  }

  // recursive test if this field and his neighbors is possible to reveal
  void reveal(int tmpCol, int tmpRow) {
    int fieldIndex  = cols * tmpRow + tmpCol;

    // if this field exists
    if (tmpCol < cols && tmpCol >=0 && tmpRow < rows && tmpRow >= 0) {

      // reveal this field
      mineField.fieldBoxes[fieldIndex].revealed = true;

      // if this field has 0 minue nearby, call this function for each of his neighbors
      if (mineField.fieldBoxes[fieldIndex].numberOfNearbyMines == 0) {

        // right neighbor
        if (tmpCol + 1 <cols) {
          if (!mineField.fieldBoxes[fieldIndex + 1].revealed) {
            reveal(tmpCol + 1, tmpRow);
          }
        }

        // left neighbor
        if (tmpCol - 1 >= 0) {
          if (!mineField.fieldBoxes[fieldIndex - 1].revealed) {
            reveal(tmpCol - 1, tmpRow);
          }
        }

        // lower neighbor
        if (tmpRow + 1<rows) {
          if (!mineField.fieldBoxes[fieldIndex + cols].revealed) {
            reveal(tmpCol, tmpRow + 1);
          }
        }

        // right lower neighbor
        if (tmpRow + 1 <rows && tmpCol + 1 <cols) {
          if (!mineField.fieldBoxes[fieldIndex + cols + 1].revealed) {
            reveal(tmpCol + 1, tmpRow + 1);
          }
        }

        // left lower neighbor
        if (tmpRow + 1 <rows && tmpCol - 1 >= 0) {
          if (!mineField.fieldBoxes[fieldIndex + cols - 1].revealed) {
            reveal(tmpCol - 1, tmpRow + 1);
          }
        }

        // upper neighbor
        if (tmpRow - 1 >= 0) {
          if (!mineField.fieldBoxes[fieldIndex - cols ].revealed) {
            reveal(tmpCol, tmpRow - 1);
          }
        }

        // right upper neighbor
        if (tmpRow - 1 >= 0 && tmpCol + 1 < cols) {
          if (!mineField.fieldBoxes[fieldIndex - cols + 1].revealed) {
            reveal(tmpCol + 1, tmpRow - 1);
          }
        }

        // left upper neighbor
        if (tmpRow - 1 >= 0 && tmpCol - 1 >= 0) { 
          if (!mineField.fieldBoxes[fieldIndex - cols - 1].revealed) {
            reveal(tmpCol - 1, tmpRow - 1);
          }
        }
      }
    }
  }

  // check if player already win
  void checkWin() {
    win = true;

    for (int i = 0; i < cols * rows; i++) {
      if (mineField.fieldBoxes[i].revealed == false && mineField.fieldBoxes[i].mine == false) {
        win = false;
      }
    }
    if (win) {
      displayGameOver();
    }
  }
}
