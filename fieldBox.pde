class FieldBox {
  // variables for detection - was revealed?, is there mine?, is flagged?
  boolean revealed;
  boolean mine;
  boolean flagged;

  // how many mines is nearby
  int numberOfNearbyMines;

  // constructor
  FieldBox() {
    revealed = false;
    mine = false;
    numberOfNearbyMines = 0;
    flagged = false;
  }
}
