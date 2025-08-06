import '../models/yahtzee_model.dart';

/// Controller for the model of Yahtzee.
/// Can control of the variant of Yahtzee 
class YahtzeeController {
  final YahtzeeModel _model;
  YahtzeeController({
    required YahtzeeModel model,
    this.variant = Variant.pauline,
  }) : _model = model;

  YahtzeeModel get model => _model;
  final Variant variant;

  int _scoreForDiceValues = 0;
  int? _difference;

  ///Sets of differents existing listeners
  Set<FiguresListener> _figuresListeners = {};
  Set<ValuesListener> _valuesListeners = {};
  Set<DifferenceListener> _differencesListeners = {};

  static final Map<Variant,Set<YahtzeeFigure>> _figuresForVariant = {
    Variant.pauline : {
      YahtzeeFigure.fourOfAKind,
      YahtzeeFigure.fullHouse,
      YahtzeeFigure.longStraight,
      YahtzeeFigure.yahtzee,},
  };

  /// ----------- Listeners
  
  /// Method that notify all figures listeners
  void _notifyFiguresListeners(){
    for (var listener in _figuresListeners){
      listener.onFigureChanged();
    }
  }

  /// Method that notify all values listeners
  void _notifyValuesListeners(){
    for (var listener in _valuesListeners){
      listener.onValueChanged();
    }
  }
  
  /// Method that notify all difference listeners
  void _notifyDifferenceListeners(){
    for (var listener in _differencesListeners){
      listener.onDifferenceChanged();
    }
  }

  /// Register [listener] if it not yet register.
  /// Return true if the listener is added, false otherwise.
  /// 
  /// If [notifyHistory], if [listener] is added, it's notify like a changed occured. 
  bool registerFiguresListeners(FiguresListener listener, {bool notifyHistory = false}){
    bool listenerAdded = _figuresListeners.add(listener);
    if(listenerAdded && notifyHistory){
      listener.onFigureChanged();
    }
    return listenerAdded;
  }

  /// Unregister [listener] if it's register.
  /// Return true if the listener is removed, false otherwise. 
  bool unregisterFiguresListeners(FiguresListener listener){
    return _figuresListeners.remove(listener);
  }

  /// Register [listener] if it not yet register.
  /// Return true if the listener is added, false otherwise.
  /// 
  /// If [notifyHistory], if [listener] is added, it's notify like a changed occured. 
  bool registerValuesListeners(ValuesListener listener, {bool notifyHistory = false}){
    bool listenerAdded = _valuesListeners.add(listener);
    if(listenerAdded && notifyHistory){
      listener.onValueChanged();
    }
    return listenerAdded;
  }

  /// Unregister [listener] if it's register.
  /// Return true if the listener is removed, false otherwise. 
  bool unregisterValuesListeners(ValuesListener listener){
    return _valuesListeners.remove(listener);
  }
  
  /// Register [listener] if it not yet register.
  /// Return true if the listener is added, false otherwise.
  /// 
  /// If [notifyHistory], if [listener] is added, it's notify like a changed occured. 
  bool registerDifferenceListeners(DifferenceListener listener, {bool notifyHistory = false}){
    bool listenerAdded = _differencesListeners.add(listener);
    if(listenerAdded && notifyHistory){
      listener.onDifferenceChanged();
    }
    return listenerAdded;
  }

  /// Unregister [listener] if it's register.
  /// Return true if the listener is removed, false otherwise. 
  bool unregisterDifferenceListeners(DifferenceListener listener){
    return _differencesListeners.remove(listener);
  }

  /// ----------- Interaction with the model

  /// Set [number] of dice for the [value] if it's possible
  void setDiceNumber({required int number, required DieFace value}){
    if(!_model.numberOfDieFace.containsKey(value)){
      _model.numberOfDieFace[value] = number;
      _updateValueScore();
    }
  }

  /// Return the number of dice for the [value]
  /// Return 0 if the [value] is not yet set.
  /// 
  /// Show [canSetDiceValue] to know if the value is already set.
  int getvalueForDiceValue(DieFace value){
      return _model.numberOfDieFace[value]?? 0;
  }

  /// Return true if the controller can set a [value].
  bool canSetDiceValue(DieFace value){
    return !_model.numberOfDieFace.containsKey(value);
  }

  /// Clean the model for the specific [value]
  void resetValue(DieFace value){
    _model.numberOfDieFace.remove(value);
    _updateValueScore();
  }

  /// Set [value] on the maximum if it's possible
  set maximum(int value){
    switch(variant){
      case Variant.pauline:
        _model.maximum??=value;
        _updateDifference();
        _notifyDifferenceListeners();
        break;
      default:
        throw "not yet defined";
    }
  }

  /// Return the maximum of the model
  /// Return 0 if the value is not yet set.
  /// 
  /// Show [canSetMaximum] to know if the value is already set.
  int get maximum{
    return _model.maximum??0;
  }

  /// Return true if the controller can set the maximum
  bool canSetMaximum(){
        switch(variant){
      case Variant.pauline:
        return _model.maximum == null;
      default:
        throw "not yet defined";
    }
  }

  /// Reset the data save into the maximum
  void resetMaximum(){
    _model.maximum=null;
    _updateDifference();
  }

  /// Set [value] on the minimum if it's possible
  set minimum(int value){
    switch(variant){
      case Variant.pauline:
        _model.minimum??=value;
        _updateDifference();
        _notifyDifferenceListeners();
        break;
      default:
        throw "not yet defined";
    }
  }

  /// Return the minimum of the model
  /// Return 0 if the value is not yet set.
  /// 
  /// Show [canSetMinimum] to know if the value is already set.
  int get minimum{
    return _model.minimum??0;
  }

  /// Return true if the controller can set the minimum
  bool canSetMinimum(){
    switch(variant){
      case Variant.pauline:
        return _model.minimum == null;
      default:
        throw "not yet defined";
    }
  }

  /// Reset the data save into the minimum
  void resetMinimum(){
    _model.minimum=null;
    _updateDifference();
  }

  /// Set the [state] for the [figure] if it's possible
  /// 
  /// Show [figureCanBeSet] to know if it's possible
  void setFigureState(YahtzeeFigure figure, YahtzeeState state){
    /// on ne peut ajout une figure dans le model que si elle existe dans la version du jeu
    var availableFigures = _figuresForVariant[variant] ?? {};
    if(availableFigures.contains(figure)){
      /// On peut modifier une valeur si on est en editMode
      if(!_model.figuresState.containsKey(figure)){
        _model.figuresState[figure] = state;
        _notifyFiguresListeners();
      }        
    }
  }
  
  /// Reset the stat of the [figure]
  void resetFigure(YahtzeeFigure figure){
    _model.figuresState.remove(figure);
    _notifyFiguresListeners();
  }

  ///Return true if [figure] can be set
  bool figureCanBeSet(YahtzeeFigure figure){
    return !_model.figuresState.containsKey(figure);
  }

  /// Return the state of the [figure] if it's possible
  YahtzeeState? getState(YahtzeeFigure figure){
    return _model.figuresState[figure];
  }

  /// Return the score for bonus
  int get scoreForBonus{
    return bonusSuccess? _getScoreForSuccessBonus(variant) : 0;
  }

  /// Return the total score for all available figures
  int get totalScoreForFigures {
    var score = 0;
    for (var figure in availableFigures){
      score += getFigureScore(figure: figure);
    }
    return score;
  }

  /// Return the total score for all dice Value
  int get subTotalScoreForDiceValue {
    var score = 0;
        for (var diceValue in DieFace.values){
      score += getValueScoreForDiceValue(diceValue);
    }
    return score;
  }

  /// Return the total score for all dice Value and bonus
  int get totalScoreForDiceValue {
    var score = bonusSuccess?_getScoreForSuccessBonus(variant):0;
    score += subTotalScoreForDiceValue;
    return score;
  }

  /// Return the total score
  int get totalScore {
    return totalScoreForDiceValue + totalScoreForFigures + (difference??0);
  }

  /// ----------- Internal model

  /// Return the difference if it exist null.
  /// It's the difference between the maximum and the minimum.
  int? get difference{
    return _difference;
  }

  /// This method calculated the score for the different dice.
  /// 
  /// The result is save in a local variable and can be access with the method
  void _updateValueScore(){
    _scoreForDiceValues = 0;
    for(var it in _model.numberOfDieFace.entries){
      _scoreForDiceValues += getvalueForDiceValue(it.key);
    }
    _notifyValuesListeners();
  }
  
  /// Return true if the goal for bonus is reach.
  bool get bonusSuccess{
    return distanceToBonus() <= 0;
  }

  /// Return the score needed to validate the bonus.
  int distanceToBonus(){
    var scoreNeeded = 0;
    switch(variant){
      case Variant.pauline: 
        scoreNeeded = 60;
        break;
      default:

    }
    return scoreNeeded - _scoreForDiceValues;
  }

  // Update the difference in the internal model
  void _updateDifference() {
    var max = _model.maximum;
    var min = _model.minimum;
    if(max != null && min!= null){
      _difference = max-min;
    }
    else {
      _difference = null;
    }
  }

  /// -------------- Rules
   
  /// Return the score for one dice with [diceValue]
  int getValueScoreForDiceValue(DieFace diceValue){
      var sccoreForDiceValue = 0;
      switch(diceValue){
        case DieFace.die1:
        sccoreForDiceValue = 1;
        break;
        case DieFace.die2:
        sccoreForDiceValue = 2;
        break;
        case DieFace.die3:
        sccoreForDiceValue = 3;
        break;
        case DieFace.die4:
        sccoreForDiceValue = 4;
        break;
        case DieFace.die5:
        sccoreForDiceValue = 5;
        break;
        case DieFace.die6:
        sccoreForDiceValue = 6;
        break;
        default:
        break;
      }
      var numberOfDice = _model.numberOfDieFace[diceValue] ?? 0;
    return sccoreForDiceValue * numberOfDice;
  }

  /// Return the score if the [figure] is succeed. 
  int getFigureScore({required YahtzeeFigure figure, Variant ? variant}){
    var success = _model.figuresState[figure]==YahtzeeState.succeed;
    if(!success){
      return 0;
    }
    return _getPointForFigure(figure: figure, variant: variant);
  }

  /// Return a set of figure available for the controller.
  Set<YahtzeeFigure> get availableFigures => getAvailableFigures(variant);

  /// Return a set of figure available for [variant].
  static Set<YahtzeeFigure> getAvailableFigures(Variant variant){
    Set<YahtzeeFigure> figures = _figuresForVariant[variant] ?? {};
    return figures;
  }
  
  /// Return the point
  int _getPointForFigure({required YahtzeeFigure figure,Variant? variant}) {
    var point = 0;
    switch (variant) {
      case Variant.pauline:
        switch (figure) {
          case YahtzeeFigure.fourOfAKind:
            point = 40;
            break;
          case YahtzeeFigure.fullHouse:
            point = 30;
            break;
          case YahtzeeFigure.yahtzee:
            point = 50;
            break;
          case YahtzeeFigure.longStraight:
            point = 20;
            break;
          default:
        }
        break;
      default:
    }
  return point; 
  }

  /// Return the score for success bonus for [variant]
  int _getScoreForSuccessBonus(Variant variant){
    switch (variant) {
      case Variant.pauline:
          return 30;
      default:
      throw "Not yet implemented";
    }
  }

  /// Ajoute ou met à jour le nombre de dés pour une valeur
  /// Notifie les listeners appropriés
  void setDiceCount(DieFace value, int count) {
    _model.numberOfDieFace[value] = count;
    _notifyValuesListeners();
    _notifyDifferenceListeners();
  }

  /// Marque une figure comme réussie et notifie les listeners
  void markFigureAsSucceed(YahtzeeFigure figure) {
    _model.figuresState[figure] = YahtzeeState.succeed;
    _notifyFiguresListeners();
  }

  /// Marque une figure comme échouée et notifie les listeners
  void markFigureAsFailed(YahtzeeFigure figure) {
    _model.figuresState[figure] = YahtzeeState.failed;
    _notifyFiguresListeners();
  }

  /// Vérifie si le modèle est complet (5 dés assignés)
  bool get isModelComplete => _model.isComplete;

  /// Obtient le nombre total de dés assignés
  int get totalDice => _model.totalDice;
}

/// The different variant of Yahtzee implemented
enum Variant{
  pauline,
}

/// Interface for a listener which is notify when the difference changed.
abstract class DifferenceListener{
  void onDifferenceChanged();
}

/// Interface for a listener which is notify when a figure changed.
abstract class FiguresListener{
  void onFigureChanged();
}

/// Interface for a listener which is notify when a value changed.
abstract class ValuesListener{
  void onValueChanged();
}