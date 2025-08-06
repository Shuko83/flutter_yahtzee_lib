
/// Represents the model of a Yahtzee game
class YahtzeeModel {
  YahtzeeModel();

  /// Represents the number of dice for each [DieFace]
  Map<DieFace, int> numberOfDieFace = {};

  /// Stores the state of each [YahtzeeFigure].
  /// If the figure is not in the map, it means it hasn't been processed yet.
  Map<YahtzeeFigure, YahtzeeState> figuresState = {};

  /// Sum of all dice stored in the [maximum] value
  ///
  /// Used to calculate the score [difference] => [maximum] - [minimum]
  int? maximum;

  /// Sum of all dice stored in the [minimum] value
  ///
  /// Used to calculate the score [difference] => [maximum] - [minimum]
  int? minimum;

  /// Sum of all dice stored in the [chance] value
  int? chance;

  /// Returns the total number of dice
  int get totalDice => numberOfDieFace.values.fold(0, (sum, count) => sum + count);

  /// Returns the difference between maximum and minimum
  int? get difference => (maximum != null && minimum != null) ? maximum! - minimum! : null;

  /// Checks if a figure is successful.
  /// Returns true if the figure is present in the map and its state is [YahtzeeState.succeed].
  /// Returns false if the figure is not present in the map (i.e., not yet processed) or if it failed.
  bool isFigureSucceed(YahtzeeFigure figure) => figuresState[figure] == YahtzeeState.succeed;

  /// Checks if a figure has been processed (succeeded or failed)
  bool isFigureProcessed(YahtzeeFigure figure) => figuresState.containsKey(figure);

  /// Gets the number of dice for a given face
  int getDiceCount(DieFace face) => numberOfDieFace[face] ?? 0;

  /// Resets the model for a new game
  void reset() {
    numberOfDieFace.clear();
    figuresState.clear();
    maximum = null;
    minimum = null;
    chance = null;
  }

  /// Checks if all dice have been assigned
  bool get isComplete => totalDice == 5;
}

/// Represents the different faces of a die
enum DieFace {
  die1,
  die2,
  die3,
  die4,
  die5,
  die6,
}

/// Represents the success or failure of a figure
enum YahtzeeState {
  succeed,
  failed
}

/// Represents the different figures existing in the Yahtzee game
enum YahtzeeFigure {
  /// 3 identical dice and 2 more identical dice
  fullHouse,
  /// 4 identical dice
  fourOfAKind,
  /// 5 consecutive dice (1,2,3,4,5 or 2,3,4,5,6)
  longStraight,
  /// 4 consecutive dice (1,2,3,4,5 or 2,3,4,5,6)
  smallStraight,
  /// 3 identical dice
  threeOfAKind,
  /// 5 identical dice
  yahtzee,
}