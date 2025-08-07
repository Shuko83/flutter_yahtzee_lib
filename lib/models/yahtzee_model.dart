
/// Represents the model of a Yahtzee game
class YahtzeeModel {
  YahtzeeModel({this.variant = YahtzeeVariant.classic});

  final YahtzeeVariant variant;

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

  /// Returns the score of dice faces only (without bonus)
  int get diceScore => numberOfDieFace.entries.fold(0, (sum, entry) => sum + (entry.value * entry.key.toInt()));

  /// Returns the bonus threshold for the current variant
  int get upperSectionThreshold => switch(variant) {
    YahtzeeVariant.classic => 63,
    YahtzeeVariant.pauline => 60,
  };

  /// Returns the bonus amount for the current variant
  int get upperSectionBonus => switch(variant) {
    YahtzeeVariant.classic => 35,
    YahtzeeVariant.pauline => 30,
  };

  /// Returns the upper section score (dice score + bonus if dice score >= threshold)
  int get upperSectionScore {
    // Bonus selon la variante si le score des dés atteint le seuil
    int bonus = diceScore >= upperSectionThreshold ? upperSectionBonus : 0;
    return diceScore + bonus;
  }

  /// Returns the difference between maximum and minimum
  int? get difference => (maximum != null && minimum != null) ? maximum! - minimum! : null;

  /// Checks if a figure is successful.
  /// Returns true if the figure is present in the map and its state is [YahtzeeState.succeed].
  /// Returns false if the figure is not present in the map (i.e., not yet processed) or if it failed.
  bool isFigureSucceed(YahtzeeFigure figure) => figuresState[figure] == YahtzeeState.succeed;

  /// Checks if a figure has been processed (succeeded or failed)
  bool isFigureProcessed(YahtzeeFigure figure) => figuresState.containsKey(figure);

  /// Vérifie si une figure est disponible dans la variante actuelle
  bool isFigureAvailable(YahtzeeFigure figure) {
    switch (variant) {
      case YahtzeeVariant.pauline:
        return {
          YahtzeeFigure.fourOfAKind,
          YahtzeeFigure.fullHouse,
          YahtzeeFigure.longStraight,
          YahtzeeFigure.yahtzee,
        }.contains(figure);
      case YahtzeeVariant.classic:
        return {
          YahtzeeFigure.fourOfAKind,
          YahtzeeFigure.fullHouse,
          YahtzeeFigure.longStraight,
          YahtzeeFigure.smallStraight,
          YahtzeeFigure.threeOfAKind,
          YahtzeeFigure.yahtzee,
        }.contains(figure);
    }
  }

  /// Marque une figure comme réussie si elle est disponible dans la variante
  void markFigureAsSucceed(YahtzeeFigure figure) {
    if (isFigureAvailable(figure)) {
      figuresState[figure] = YahtzeeState.succeed;
    }
  }

  /// Marque une figure comme échouée si elle est disponible dans la variante
  void markFigureAsFailed(YahtzeeFigure figure) {
    if (isFigureAvailable(figure)) {
      figuresState[figure] = YahtzeeState.failed;
    }
  }

  /// Retourne l'ensemble des figures disponibles pour la variante actuelle
  Set<YahtzeeFigure> get availableFigures {
    switch (variant) {
      case YahtzeeVariant.pauline:
        return {
          YahtzeeFigure.fourOfAKind,
          YahtzeeFigure.fullHouse,
          YahtzeeFigure.longStraight,
          YahtzeeFigure.yahtzee,
        };
      case YahtzeeVariant.classic:
        return {
          YahtzeeFigure.fourOfAKind,
          YahtzeeFigure.fullHouse,
          YahtzeeFigure.longStraight,
          YahtzeeFigure.smallStraight,
          YahtzeeFigure.threeOfAKind,
          YahtzeeFigure.yahtzee,
        };
    }
  }

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
}

/// Represents the different variants of Yahtzee
enum YahtzeeVariant {
  classic,  // Yahtzee classique
  pauline,  // Variante Pauline
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

/// Extension pour ajouter des méthodes utilitaires à DieFace
extension DieFaceExtension on DieFace {
  /// Converts a DieFace enum to its corresponding integer value.
  /// 
  /// This utility function maps each die face to its numerical value:
  /// - DieFace.die1 → 1
  /// - DieFace.die2 → 2
  /// - DieFace.die3 → 3
  /// - DieFace.die4 → 4
  /// - DieFace.die5 → 5
  /// - DieFace.die6 → 6
  int toInt() => switch(this) {
    DieFace.die1 => 1,
    DieFace.die2 => 2,
    DieFace.die3 => 3,
    DieFace.die4 => 4,
    DieFace.die5 => 5,
    DieFace.die6 => 6,
  };
}

/// Extension pour ajouter des méthodes utilitaires à YahtzeeFigure
extension YahtzeeFigureExtension on YahtzeeFigure {
  /// Returns the score value for this figure in the specified variant
  int getScore(YahtzeeVariant variant) => switch(variant) {
    YahtzeeVariant.classic => _getClassicScore(),
    YahtzeeVariant.pauline => _getPaulineScore(),
  };

  /// Returns the score value for this figure in the Pauline variant
  int get score => getScore(YahtzeeVariant.pauline);
  
  /// Returns a human-readable description of the figure
  String get description => switch(this) {
    YahtzeeFigure.fourOfAKind => "4 dés identiques",
    YahtzeeFigure.fullHouse => "3 dés identiques + 2 dés identiques",
    YahtzeeFigure.yahtzee => "5 dés identiques",
    YahtzeeFigure.longStraight => "5 dés consécutifs",
    YahtzeeFigure.smallStraight => "4 dés consécutifs",
    YahtzeeFigure.threeOfAKind => "3 dés identiques",
  };

  /// Returns the classic Yahtzee score for this figure
  int _getClassicScore() => switch(this) {
    YahtzeeFigure.fourOfAKind => 40,
    YahtzeeFigure.fullHouse => 25,
    YahtzeeFigure.yahtzee => 50,
    YahtzeeFigure.longStraight => 40,
    YahtzeeFigure.smallStraight => 30,
    YahtzeeFigure.threeOfAKind => 30,
  };

  /// Returns the Pauline variant score for this figure
  int _getPaulineScore() => switch(this) {
    YahtzeeFigure.fourOfAKind => 40,
    YahtzeeFigure.fullHouse => 30,
    YahtzeeFigure.yahtzee => 50,
    YahtzeeFigure.longStraight => 20,
    YahtzeeFigure.smallStraight => 15,
    YahtzeeFigure.threeOfAKind => 25,
  };
}