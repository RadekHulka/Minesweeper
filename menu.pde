class Menu {
  // variables for time
  int totalTime;
  int previousTime;
  int actualTime;

  // constructor
  Menu() {
    totalTime = 0;
    actualTime = second();
    previousTime = second();
  }

  // display menu
  void display() {
    fill(127);
    rect(0, 0, width - 1, menuHeight);
    drawMine(30, (int) menuHeight / 2);
    textSize(20);
    textAlign(LEFT, CENTER);
    text(minesLeft, 60, (menuHeight / 2 - 2));

    drawDifficulty();

    drawClock(width - 80, menuHeight / 2);
    actualTime = second();

    if (actualTime != previousTime) {
      totalTime++;
      previousTime = actualTime;
    }

    textSize(20);
    text(totalTime, width - 50, (menuHeight / 2 - 2));

    drawBestTime();

    drawNewGame(width / 2, menuHeight / 2);
  }

  // draw mine
  void drawMine(int tmpX, int tmpY) {

    // draw parts of mine
    fill(0);
    stroke(0);
    ellipse (tmpX, tmpY, 12, 12);
    fill(255);
    rect(tmpX - 4, tmpY - 4, 4, 4);
    fill(0);
    triangle(tmpX - 10, tmpY, tmpX - 8, tmpY - 1, tmpX - 8, tmpY + 1);
    triangle(tmpX + 10, tmpY, tmpX + 8, tmpY - 1, tmpX + 8, tmpY + 1);
    triangle(tmpX, tmpY - 10, tmpX - 1, tmpY - 8, tmpX + 1, tmpY - 8);
    triangle(tmpX, tmpY + 10, tmpX - 1, tmpY + 8, tmpX + 1, tmpY + 8);
    triangle(tmpX - 6, tmpY - 6, tmpX - 5, tmpY - 6, tmpX - 6, tmpY - 5);
    triangle(tmpX + 6, tmpY + 6, tmpX + 5, tmpY + 6, tmpX + 6, tmpY + 5);
    triangle(tmpX - 6, tmpY + 6, tmpX - 5, tmpY + 6, tmpX - 6, tmpY + 5);
    triangle(tmpX + 6, tmpY - 6, tmpX + 5, tmpY - 6, tmpX + 6, tmpY - 5);
  }

  // draw clock
  void drawClock(int tmpX, int tmpY) {
    fill(255);
    stroke(0);
    ellipse(tmpX, tmpY, 24, 24);
    fill(0);
    ellipse(tmpX, tmpY, 3, 3);
    line(tmpX, tmpY - 12, tmpX, tmpY - 8);
    line(tmpX, tmpY + 12, tmpX, tmpY + 8);
    line(tmpX - 12, tmpY, tmpX - 8, tmpY);
    line(tmpX + 12, tmpY, tmpX + 8, tmpY);
    line(tmpX, tmpY, tmpX + 3, tmpY - 5);
    line(tmpX, tmpY, tmpX + 4, tmpY + 8);
  }

  // draw New game button
  void drawNewGame(int tmpX, int tmpY) {
    fill(222);
    stroke(0);
    rect(tmpX - 100, tmpY - 20, 200, 40);
    textAlign(CENTER, CENTER);
    fill(0);
    textSize(20);
    text("NEW GAME", tmpX, tmpY - 2);
  }

  // draw difficulty options
  void drawDifficulty() {
    textSize(12);
    textAlign(LEFT, CENTER);

    if (difficulty == 10) {
      fill(0, 255, 0);
      rect(130, (menuHeight / 2 - 2) - 21, 60, 15);
      fill(188);
      rect(130, (menuHeight / 2 - 2) - 6, 60, 15);
      rect(130, (menuHeight / 2 - 2) + 9, 60, 15);
    } else if (difficulty == 20) {
      fill(255, 255, 0);
      rect(130, (menuHeight / 2 - 2) - 6, 60, 15);
      fill(188);
      rect(130, (menuHeight / 2 - 2) - 21, 60, 15);
      rect(130, (menuHeight / 2 - 2) + 9, 60, 15);
    } else {
      fill(255, 0, 0);
      rect(130, (menuHeight / 2 - 2) + 9, 60, 15);
      fill(188);
      rect(130, (menuHeight / 2 - 2) - 21, 60, 15);
      rect(130, (menuHeight / 2 - 2) - 6, 60, 15);
    }

    fill(0);
    text("EASY", 135, (menuHeight / 2 - 2) - 15);
    text("MEDIUM", 135, (menuHeight / 2 - 2));
    text("EXPERT", 135, (menuHeight / 2 - 2) + 15);
  }

  // draw best times
  void drawBestTime() {
    textSize(12);
    text("SESSION BEST:", 415, 10);
    if (bestTimeEasy == 2147483647) {
      text("EASY", 425, 22);
      text("0", 480, 22);
    } else {
      text("EASY", 425, 22);
      text(bestTimeEasy, 480, 22);
    }
    
    if (bestTimeMedium == 2147483647) {
      text("MEDIUM", 425, 34);
      text("0", 480, 34);
    } else {
      text("MEDIUM", 425, 34);
      text(bestTimeMedium, 480, 34);
    }
    
    if (bestTimeExpert == 2147483647) {
      text("EXPERT", 425, 46);
      text("0", 480, 46);
    } else {
      text("EXPERT", 425, 46);
      text(bestTimeExpert, 480, 46);
    }
  }

  // detect new best time
  void newBest() {
    println("tu");
    switch (mineField.mines) {
      case (minesEasy): 
      if (bestTimeEasy > totalTime) {
        bestTimeEasy = totalTime;
      }
      break;
      case (minesMedium):
      if (bestTimeMedium > totalTime) {
        bestTimeMedium = totalTime;
      }
      break;
      case (minesExpert): 
      if (bestTimeExpert > totalTime) {
        bestTimeExpert = totalTime;
      }
      break;
    }
  }
}
