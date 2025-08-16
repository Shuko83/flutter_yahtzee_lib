import 'die_face.dart';
import 'yahtzee_figure.dart';
import 'yahtzee_state.dart';
import 'yahtzee_listeners.dart';

/// Represents the model of a Yahtzee game
class YahtzeeModel {
  YahtzeeModel({this.variant = YahtzeeVariant.classic});

  final YahtzeeVariant variant;

  /// Listeners for each YathzeeFigure
  final Map<YahtzeeFigure, List<FiguresListener>> _figuresListeners = {};
  /// Listeners for each DieFace
  final Map<DieFace, List<DieFacesListener>> _dieFacesListeners = {};
  /// Differences Listener
  final Set<DifferenceListener> _differenceListeners = {};
  /// Chance Listener
  final Set<ChanceListener> _chanceListeners = {};
  /// Total Score Listener
  final Set<TotalScoreListener> _totalScoreListeners = {};
  /// Listeners for total figure score
  final Set<FiguresListener> _scoreFiguresListeners = {};

  /// Represents the number of dice for each [DieFace]
  final Map<DieFace, int> _numberOfDieFace = {};

  /// Sum of all dice stored in the [chance] value
  int? _chance;

  /// Sum of all dice stored in the [_maximum] value
  ///
  /// Used to calculate the score [difference] => [_maximum] - [_minimum]
  int? _maximum;

  /// Sum of all dice stored in the [_minimum] value
  ///
  /// Used to calculate the score [difference] => [_maximum] - [_minimum]
  int? _minimum;

  /// Stores the state of each [YahtzeeFigure].
  /// If the figure is not in the map, it means it hasn't been marked yet.
  final Map<YahtzeeFigure, YahtzeeState> _figuresState = {};

  /// Returns the score of dice faces only (without bonus)
  int get diceScore => _numberOfDieFace.entries.fold(0, (sum, entry) => sum + (entry.value * entry.key.toInt()));

  /// Returns the bonus threshold for the current [variant].
  int get upperSectionThreshold => switch(variant) {
    YahtzeeVariant.classic => 63,
    YahtzeeVariant.pauline => 60,
  };

  /// Returns the bonus amount for the current [variant].
  int get upperSectionBonus => switch(variant) {
    YahtzeeVariant.classic => 35,
    YahtzeeVariant.pauline => 30,
  };

  /// Return the [upperSectionBonus] if [upperSectionThreshold] is reach for the current [variant].
  /// Return 0 otherwise.
  int get bonusScore {
    return diceScore >= upperSectionThreshold ? upperSectionBonus : 0;
  }

  /// Return the missing score for [bonus]
  /// It returns the difference between [upperSectionThreshold] and [diceScore].
  int getMissingScoreForBonus(){
    return upperSectionThreshold - diceScore;
  }

  /// Return the upper section score [diceScore] + [bonusScore] for the current [variant].
  int get upperSectionScore { 
    return diceScore + bonusScore;
  }
  
  /// Return the number of dice for [face].
  /// If the face is not yet played, it returns null.
  int? getDiceCount(DieFace face) => _numberOfDieFace[face];

  /// Sets the number of dice for a given face and notifies the listeners.
  void setNumberOfDiceForDieFace({ required DieFace dieFace, required int? number }){
    bool needNotify = number == getDiceCount(dieFace);
    if(number != null){
      _numberOfDieFace[dieFace] = number;
    }
    else{
      _numberOfDieFace.remove(dieFace);
    }
    if(needNotify){
      _onNumberOfDieFaceChanged(face: dieFace, value: number);
    }
  }

  /// Method called when the number of dice for a face changes.
  /// It notifies the [DieFacesListener] for that [face] and all registered [TotalScoreListener].
  void _onNumberOfDieFaceChanged({required DieFace face, required int? value}) {
    _notifyDieFacesListeners(face: face);
    _notifyTotalScoreListeners();
  }

  /// Resets the number of dice for all faces and notifies the listeners.
  void resetNumberOfDieFace(){
    for(var face in DieFace.values){
      setNumberOfDiceForDieFace(dieFace: face, number: null);
    }
  }

  /// Return the [maximum]
  /// Return null if the [maximum] is not yet played.
  int? get maximum  => _maximum;
  
  /// Return the [minimum]
  /// Return null if the [minimum] is not yet played.
  int? get minimum  => _minimum;

  /// Return the [chance].
  /// Return null if the [chance] is not yet played.
  int? get chance => _chance;

  /// Returns the difference between [_maximum] and [_minimum]
  /// 
  /// If [minimum] or [maximum] is null return null
  /// Return [maximum] - [minimum] otherwise
  int? get difference => (_maximum != null && _minimum != null) ? _maximum! - _minimum! : null;
 
  /// Set the value for the [maximum] and notify [DifferenceListener] if the value changed.
  /// Can set the value to null to reset value since is not played.
  set maximum(int? value){
    if(_maximum != value){
      _maximum = value;  
      _onMaximumChanged();
    }
  }

  /// Set the value for the [minimum] and notify [DifferenceListener] if the value changed.
  /// Can set the value to null to reset value since is not played.
  set minimum(int? value){
    _minimum = value;  
    _onMinimumChanged();
  }

  /// Set the value for the [chance] and notify [ChanceListener] if the value changed.
  /// Can set the value to null to reset value since is not played.
  set chance(int? value){
    _chance = value;  
    _onChanceChanged();
    if(variant == YahtzeeVariant.classic){
      _notifyTotalScoreListeners();
    }
  }

  /// Checks if a figure is successful.
  /// Returns true if the figure as been marked and its state is [YahtzeeState.succeed].
  /// Returns false if the figure is not present in the map (i.e., not yet marked) or if it failed.
  bool isFigureSucceed(YahtzeeFigure figure) => getFigureState(figure) == YahtzeeState.succeed;

  /// Checks if a figure has been marked (succeeded or failed)
  bool isFigureMarked(YahtzeeFigure figure) => getFigureState(figure) != null;

  /// Returns the state of a figure.
  /// Returns null if the figure has not been marked yet.
  YahtzeeState? getFigureState(YahtzeeFigure figure) => _figuresState[figure];

  /// Returns the total score for the figures.
  /// It sums the scores of all figures that have been successfully marked.
  int get totalFigureScore{
    int score = 0;
    for(var entry in _figuresState.entries){
      if(entry.value == YahtzeeState.succeed){
        score += entry.key.getScore(variant);
      }
    }
    return score;
  } 

  /// Returns the score for a specific figure.
  /// Returns the score if the figure is successfully marked, otherwise returns null.
  int? getScoreForFigure(YahtzeeFigure figure){
    var state = getFigureState(figure);
    if(state == YahtzeeState.succeed){
      return figure.getScore(variant); 
    }
    return null;
  }

  /// Marks a figure with the given [state].
  /// If the figure is already marked with the same state, it does nothing.
  void markFigure({required YahtzeeFigure figure, required YahtzeeState? state})
  {
    bool needNotify = _figuresState[figure] == state;
    if(state == null){
      _figuresState.remove(figure);
    }
    else{
      _figuresState[figure] = state;
    }
    if(needNotify){
      _onFigureChanged(figure: figure);
    }
  }

  /// Mark a figure as succeeded if it is available in the variant.
  void markFigureAsSucceed(YahtzeeFigure figure) {
    markFigure(figure: figure, state: YahtzeeState.succeed);
  }

  /// Mark a figure as failed if it is available in the variant.
  void markFigureAsFailed(YahtzeeFigure figure) {
    markFigure(figure: figure, state: YahtzeeState.failed);
  }

  /// Returns true if the figure is available in the current variant.
  /// Returns false otherwise.
  bool isFigureAvailable(YahtzeeFigure figure) {
     return availableFigures.contains(figure);
  }

  /// Returns the list of available figures for the current variant.
  Set<YahtzeeFigure> get availableFigures {
    switch (variant) {
      case YahtzeeVariant.pauline:
        return {
          YahtzeeFigure.longStraight,
          YahtzeeFigure.fullHouse,
          YahtzeeFigure.fourOfAKind,
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

  /// Resets the state of all figures and notifies the listeners.
  void resetFigureStates(){
    for(var figure in availableFigures){
      markFigure(figure: figure, state: null);
    }
  }

  /// Returns the total score for the game.
  /// It sums the upper section score, total figure score, and chance or difference score based on the [variant].
  int get totalScore => switch(variant){
    YahtzeeVariant.classic => upperSectionScore + totalFigureScore + (chance??0),
    YahtzeeVariant.pauline => upperSectionScore + totalFigureScore + (difference??0),
  }; 
  
  /// Return true if the game is completed.
  /// Returns false otherwise.
  /// Depends on the [variant]:
  /// - For [YahtzeeVariant.classic], it checks if the upper section is completed, all figures are marked, and chance is played.
  /// - For [YahtzeeVariant.pauline], it checks if the upper section is completed, all figures are marked, and the difference is played.
  bool get isCompleted => switch(variant){
    YahtzeeVariant.classic => _upperSectionCompleted && _figuresCompleted && chance != null,
    YahtzeeVariant.pauline => _upperSectionCompleted && _figuresCompleted && _differenceCompleted,
  };

  /// Resets the model
  /// It resets the number of dice for each face, the figures states, the [maximum], [minimum], [chance].
  void reset() {
    resetNumberOfDieFace();
    resetFigureStates();
    maximum = null;
    minimum = null;
    chance = null;
  }

  /// Reset all ValueListeners
  void resetValueListeners(){
    _dieFacesListeners.clear();
  } 

  /// Reset all figureListeners
  void resetfigureListeners(){
    _figuresListeners.clear();
  }

  /// Reset all differenceListeners
  void resetDifferenceListeners(){
    _differenceListeners.clear();
  }

  /// Reset all totalScoreListeners
  void resetTotalScoreListeners(){
    _totalScoreListeners.clear();
  }

  /// Reset all chanceListeners
  void resetChanceListeners(){
    _chanceListeners.clear();
  }

  /// Reset all listeners
  void resetListeners(){
    resetValueListeners();
    resetfigureListeners();
    resetDifferenceListeners();
    resetTotalScoreListeners();
    resetChanceListeners();
  } 

  /// Method called when maximum changed
  void _onMaximumChanged(){
    _notifyDifferenceListeners(notifyMaximum: true);
    if(variant == YahtzeeVariant.pauline){
      _notifyTotalScoreListeners();
    }
  }

  /// Method called when minimum changed
  void _onMinimumChanged(){
    _notifyDifferenceListeners(notifyMinimum: true);
    if(variant == YahtzeeVariant.pauline){
      _notifyTotalScoreListeners();
    }
  }
 
  /// Method called when the chance changed
  void _onChanceChanged(){
    _notifyChanceListeners();
    if(variant == YahtzeeVariant.classic){
      _notifyTotalScoreListeners();
    }
  }

  /// Method called when a figure changed
  void _onFigureChanged({required YahtzeeFigure figure}) {
    _notifyFiguresListeners(figure: figure);
    _notifyTotalScoreListeners();
  }

  /// Method that notify all [DifferenceListener]
  /// If [notifyMaximum] is true, it notifies the maximum value.
  /// If [notifyMinimum] is true, it notifies the minimum value.
  void _notifyDifferenceListeners({bool notifyMaximum = false, bool notifyMinimum = false}){
    for (var listener in _differenceListeners){
      if(notifyMaximum){
        listener.onMaximumChanged(maximum);
      }
      if(notifyMinimum){
        listener.onMinimumChanged(minimum);
      }
      listener.onDifferenceChanged(difference);
    }
  }

  /// Method that notify all [ChanceListener]
  void _notifyChanceListeners(){
    for (var listener in _chanceListeners){
      listener.onChanceChanged(chance);
    }
  }

  /// Method that notify all [TotalScoreListener]
  void _notifyTotalScoreListeners(){
    for (var listener in _totalScoreListeners){
      listener.onTotalScoreChanged(totalScore);
    }
  }

  /// Method that notify all figures listeners
  void _notifyFiguresListeners({required YahtzeeFigure figure}){
    if(_figuresListeners.containsKey(figure)){
      for (var listener in _figuresListeners[figure]!){
        listener.onFigureChanged(figure: figure, state: getFigureState(figure));
      }
      for (var listener in _scoreFiguresListeners){
        listener.onTotalFigureScoreChanged(totalFigureScore);
      }
    }
  }

  /// Method that notify all values listeners
  void _notifyDieFacesListeners({required DieFace face}){
    if(_dieFacesListeners.containsKey(face)){
      for (var listener in _dieFacesListeners[face]!){
        listener.onBonusChanged(bonusScore);
        listener.onUpperSectionScoreChanged(upperSectionScore);
        listener.onTotalDieFaceScoreChanged(diceScore);
        listener.onNumberOfDieFaceChanged(face: face, value: getDiceCount(face));
      }
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

  /// Register [listener] if it not yet register.
  /// 
  /// If [notifyHistory], it's notify like a changed occured. 
  bool registerScoreFiguresListener({required FiguresListener listener, bool notifyHistory = false}){
    var registered = _scoreFiguresListeners.add(listener);
    if(notifyHistory){
      listener.onTotalFigureScoreChanged(totalFigureScore);
    }
    return registered;
  }

  /// Unregister [listener]
  /// Return true if the listener is removed, false otherwise.
  bool unregisterScoreFiguresListener(FiguresListener listener){
    return _scoreFiguresListeners.remove(listener);
  }

  /// Register [listener] if it not yet register.
  /// 
  /// If [notifyHistory],it's notify like a changed occured. 
  bool registerTotalScoreListeners({required TotalScoreListener listener, bool notifyHistory = false}){
    var registered = _totalScoreListeners.add(listener);
    if(notifyHistory){
      listener.onTotalScoreChanged(totalScore);
    }
    return registered;
  }

  /// Unregister [listener]
  /// Return true if the listener is removed, false otherwise.
  bool unregisterTotalScoreListeners(TotalScoreListener listener){
    return _totalScoreListeners.remove(listener);
  }

  /// Register [listener] if it not yet register. 
  /// Return the number of listener added.
  /// If [notifyHistory], if [listener] is added, it's notify like a changed occured. 
  int registerFiguresListeners(FiguresListener listener, {List<YahtzeeFigure> figures = YahtzeeFigure.values, bool notifyHistory = false}){
    int registerted = 0;
    for(var figure in figures){
      if(_registerFigureListeners(listener: listener, figure: figure)){
        registerted++;
        if(notifyHistory){
          listener.onFigureChanged(figure: figure, state: getFigureState(figure));
        }
      }
    }
    return registerted;
  }

  /// Register [listener] for a specific [figure] if it not yet register.
  /// Return true if the listener is added, false otherwise.
  /// If [notifyHistory], if [listener] is added, it's notify like a changed occured.
  bool _registerFigureListeners({required FiguresListener listener, required YahtzeeFigure figure, bool notifyHistory = false}){
    bool registered = false;
    if(_figuresListeners[figure] == null){
      _figuresListeners[figure] = [];
    }
    if(!_figuresListeners.containsKey(figure)){
      _figuresListeners[figure]!.add(listener);
      registered = true;
      if(notifyHistory){
        listener.onFigureChanged(figure: figure, state: getFigureState(figure));
      }
    }
    return registered;
  }

  /// Unregister [listener] if it's register.
  /// Return the number of listener removed.
  int unregisterFiguresListeners(FiguresListener listener, {List<YahtzeeFigure> figures = YahtzeeFigure.values}){
    int unregistered = 0;
    for(var figure in figures){
      if(_figuresListeners.containsKey(figure)){
        if(_figuresListeners[figure]!.remove(listener)){
          unregistered++;
        }
      }
    }
    return unregistered;
  }

  /// Register [listener] if it not yet register.
  /// Return true if the listener is added, false otherwise.
  /// 
  /// If [notifyHistory], if [listener] is added, it's notify like a changed occured. 
  void registerValuesListeners(DieFacesListener listener, {List<DieFace> faces = DieFace.values, bool notifyHistory = false}){
    for(var face in faces){
      _dieFacesListeners.putIfAbsent(face, () => []).add(listener);
      if(notifyHistory){
        _notifyDieFacesListeners(face: face);
      }
    }
  }

  /// Unregister [listener] if it's register. 
  /// Return the number of listener removed.
  int unregisterValuesListeners(DieFacesListener listener, {List<DieFace> faces = DieFace.values}){
    int unregistered = 0;
    for(var face in faces){
      if(_dieFacesListeners.containsKey(face)){
        _dieFacesListeners[face]!.remove(listener);
        unregistered++;
      }
    }
    return unregistered;
  }
  
  /// Register [listener] if it not yet register.
  /// Return true if the listener is added, false otherwise.
  /// 
  /// If [notifyHistory], if [listener] is added, it's notify like a changed occured. 
  bool registerDifferenceListeners(DifferenceListener listener, {bool notifyHistory = false}){
    bool listenerAdded = _differenceListeners.add(listener);
    if(listenerAdded && notifyHistory){
      listener.onDifferenceChanged(difference);
      listener.onMaximumChanged(maximum);
      listener.onMinimumChanged(minimum);
    }
    return listenerAdded;
  }

  /// Unregister [listener] if it's register.
  /// Return true if the listener is removed, false otherwise. 
  bool unregisterDifferenceListeners(DifferenceListener listener){
    return _differenceListeners.remove(listener);
  }
}

/// Represents the different variants of Yahtzee
enum YahtzeeVariant {
  classic,  // Yahtzee classique
  pauline,  // Variante Pauline
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
