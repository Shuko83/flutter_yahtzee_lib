import 'die_face.dart';

/// Represents the model of a Yahtzee game
class YahtzeeModel {
  YahtzeeModel({this.variant = YahtzeeVariant.classic});

  final YahtzeeVariant variant;

  /// Represents the number of dice for each [DieFace]
  final Map<DieFace, int> _numberOfDieFace = {};

  /// Stores the state of each [YahtzeeFigure].
  /// If the figure is not in the map, it means it hasn't been processed yet.
  final Map<YahtzeeFigure, YahtzeeState> _figuresState = {};

  ///Sets of differents existing listeners
  final Map<YahtzeeFigure, List<FiguresListener>> _figuresListeners = {};
  final Map<DieFace, List<ValuesListener>> _valuesListeners = {};
  final Set<DifferenceListener> _differenceListeners = {};
  final Set<ChanceListener> _chanceListeners = {};

  /// Sum of all dice stored in the [_maximum] value
  ///
  /// Used to calculate the score [difference] => [_maximum] - [_minimum]
  int? _maximum;

  /// Sum of all dice stored in the [_minimum] value
  ///
  /// Used to calculate the score [difference] => [_maximum] - [_minimum]
  int? _minimum;

  /// Sum of all dice stored in the [chance] value
  int? _chance;

  /// Returns the score of dice faces only (without bonus)
  int get diceScore => _numberOfDieFace.entries.fold(0, (sum, entry) => sum + (entry.value * entry.key.toInt()));

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

  /// Returns the difference between _maximum and _minimum
  int? get difference => (_maximum != null && _minimum != null) ? _maximum! - _minimum! : null;

  /// Return the maximum
  int? get maximum  => _maximum;
  
  /// Return the minimum
  int? get minimum  => _minimum;

  int? get chance => _chance;

  set maximum(int? value){
    _maximum = value;  
    _notifyDifferenceListeners(difference);
  }

  set minimum(int? value){
    _minimum = value;  
    _notifyDifferenceListeners(difference);
  }

  set chance(int? value){
    _chance = value;  
    _notifyChanceListeners(value);
  }

  int get totalFigureScore{
    int score = 0;
    for(var entry in _figuresState.entries){
      if(entry.value == YahtzeeState.succeed){
        score += entry.key.score;
      }
    }
    return score;
  }  

  int get totalScore => switch(variant){
    YahtzeeVariant.classic => upperSectionScore + totalFigureScore + (chance??0),
    YahtzeeVariant.pauline => upperSectionScore + totalFigureScore + (difference??0),
  }; 
  YahtzeeState? getFigureState(YahtzeeFigure figure) => _figuresState[figure];
  /// Checks if a figure is successful.
  /// Returns true if the figure is present in the map and its state is [YahtzeeState.succeed].
  /// Returns false if the figure is not present in the map (i.e., not yet processed) or if it failed.
  bool isFigureSucceed(YahtzeeFigure figure) => getFigureState(figure) == YahtzeeState.succeed;

  /// Checks if a figure has been processed (succeeded or failed)
  bool isFigureProcessed(YahtzeeFigure figure) => getFigureState(figure) != null;

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

 void resetFigure(YahtzeeFigure figure){
    _figuresState.remove(figure);
    _notifyFiguresListeners(figure: figure, state: null);
 }
  /// Add a played figure
  void markFigure({required YahtzeeFigure figure, required YahtzeeState state})
  {
    _figuresState[figure] = state;
    _notifyFiguresListeners(figure: figure, state: state);
  }

  /// Marque une figure comme réussie
  void markFigureAsSucceed(YahtzeeFigure figure) {
    markFigure(figure: figure, state: YahtzeeState.succeed);
  }

  /// Marque une figure comme échouée si elle est disponible dans la variante
  void markFigureAsFailed(YahtzeeFigure figure) {
    markFigure(figure: figure, state: YahtzeeState.failed);
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
  /// Return true if all dieFace has been set
  /// False optherwise
  bool get _upperSectionCompleted => _numberOfDieFace.length == DieFace.values.length;

  /// Retun true if the difference has been played
  /// False Otherwise.
  /// Depends of _maximum and _minimum played
  bool get _differenceCompleted => difference != null;

  /// Return true if all figures has been played.
  /// False otherwise.
  bool get _figuresCompleted=> availableFigures.every((figure)=> _figuresState.containsKey(figure));


  /// Return true if the game is completed.
  bool get isCompleted => switch(variant){
    YahtzeeVariant.classic => _upperSectionCompleted && _figuresCompleted && chance != null,
    YahtzeeVariant.pauline => _upperSectionCompleted && _figuresCompleted && _differenceCompleted,
  };

  /// Gets the number of dice for a given face
  int? getDiceCount(DieFace face) => _numberOfDieFace[face];

  void setNumberOfDiceForDieFace({ required DieFace dieFace, required int number }){
    _numberOfDieFace[dieFace] = number;
    _notifyValuesListeners(face: dieFace, value: number);
  }

  void resetNumberOfDiceForDieFace(DieFace dieFace){
    _numberOfDieFace.remove(dieFace);
    _notifyValuesListeners(face: dieFace, value: null);
  }

  /// Resets the model for a new game
  void reset() {
    resetNumberOfDieFace();
    resetFigureStates();
    maximum = null;
    minimum = null;
    chance = null;
  }
  
  void resetFigureStates(){
    var figureToBeCleared = _figuresState.keys;
    _figuresState.clear();
    for(var figure in figureToBeCleared){
      _notifyFiguresListeners(figure: figure, state: null);
    }
  }

  void resetNumberOfDieFace(){
    var faceToBeCleared = _numberOfDieFace.keys;
    _numberOfDieFace.clear();
    for(var face in faceToBeCleared){
      _notifyValuesListeners(face: face, value: null);
    }
  }

  /// Reset all ValueListeners
  void resetValueListeners(){
    _valuesListeners.clear();
  } 

    /// Reset all figureListeners
  void resetfigureListeners(){
    _figuresListeners.clear();
  }

    /// Reset all differenceListeners
  void resetDifferenceListeners(){
    _differenceListeners.clear();
  }

  /// Reset all listeners
  void resetListeners(){
    resetValueListeners();
    resetfigureListeners();
    resetDifferenceListeners();
  } 

  /// Register [listener] if it not yet register.
  /// 
  /// If [notifyHistory], if [listener] is added, it's notify like a changed occured. 
  void registerFiguresListeners(FiguresListener listener, {List<YahtzeeFigure> figures = YahtzeeFigure.values, bool notifyHistory = false}){
    for(var figure in figures){
      _figuresListeners.putIfAbsent(figure, () => []).add(listener);
      if(notifyHistory){
        listener.onFigureChanged(figure: figure, state: getFigureState(figure));
      }
    }
  }

  /// Unregister [listener] if it's register.
 
  void unregisterFiguresListeners(FiguresListener listener, {List<YahtzeeFigure> figures = YahtzeeFigure.values}){
    for(var figure in figures){
      if(_figuresListeners.containsKey(figure)){
        _figuresListeners[figure]!.remove(listener);
      }
    }
  }

  /// Register [listener] if it not yet register.
  /// Return true if the listener is added, false otherwise.
  /// 
  /// If [notifyHistory], if [listener] is added, it's notify like a changed occured. 
  void registerValuesListeners(ValuesListener listener, {List<DieFace> faces = DieFace.values, bool notifyHistory = false}){
    for(var face in faces){
      _valuesListeners.putIfAbsent(face, () => []).add(listener);
      if(notifyHistory){
        listener.onValueChanged(face: face, value: getDiceCount(face));
      }
    }
  }

  /// Unregister [listener] if it's register. 
  /// Return the number of listener removed.
  void unregisterValuesListeners(ValuesListener listener, {List<DieFace> faces = DieFace.values}){
    for(var face in faces){
      if(_valuesListeners.containsKey(face)){
        _valuesListeners[face]!.remove(listener);
      }
    }
  }
  
  /// Register [listener] if it not yet register.
  /// Return true if the listener is added, false otherwise.
  /// 
  /// If [notifyHistory], if [listener] is added, it's notify like a changed occured. 
  bool registerDifferenceListeners(DifferenceListener listener, {bool notifyHistory = false}){
    bool listenerAdded = _differenceListeners.add(listener);
    if(listenerAdded && notifyHistory){
      listener.onDifferenceChanged(difference);
    }
    return listenerAdded;
  }

  /// Unregister [listener] if it's register.
  /// Return true if the listener is removed, false otherwise. 
  bool unregisterDifferenceListeners(DifferenceListener listener){
    return _differenceListeners.remove(listener);
  }

  /// Method that notify all figures listeners
  void _notifyFiguresListeners({required YahtzeeFigure figure, required YahtzeeState? state}){
    if(_figuresListeners.containsKey(figure)){
      for (var listener in _figuresListeners[figure]!){
        listener.onFigureChanged(figure: figure, state: state);
      }
    }
  }

  /// Method that notify all values listeners
  void _notifyValuesListeners({required DieFace face, required int? value}){
    if(_valuesListeners.containsKey(face)){
      for (var listener in _valuesListeners[face]!){
        listener.onValueChanged(face: face, value: getDiceCount(face));
      }
    }
  }
  
  /// Method that notify all difference listeners
  void _notifyDifferenceListeners(int? value){
    for (var listener in _differenceListeners){
      listener.onDifferenceChanged(value);
    }
  }

  /// Method that notify all chance listeners
  void _notifyChanceListeners(int? value){
    for (var listener in _chanceListeners){
      listener.onChanceChanged(value);
    }
  }
}

/// Represents the different variants of Yahtzee
enum YahtzeeVariant {
  classic,  // Yahtzee classique
  pauline,  // Variante Pauline
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

/// Interface for a listener which is notify when the difference changed.
abstract class DifferenceListener{
  void onDifferenceChanged(int? value);
}

/// Interface for a listener which is notify when the chance changed.
abstract class ChanceListener{
  void onChanceChanged(int? value);
}

/// Interface for a listener which is notify when a figure changed.
abstract class FiguresListener{
  void onFigureChanged({required YahtzeeFigure figure, required YahtzeeState? state});
}

/// Interface for a listener which is notify when a value changed.
abstract class ValuesListener{
  void onValueChanged({required DieFace face, required int? value});
}