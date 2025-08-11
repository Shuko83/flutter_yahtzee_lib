import '../models/yahtzee_model.dart';
import '../models/die_face.dart';
import '../../models/yahtzee_figure.dart';
import '../../models/yahtzee_state.dart';

/// Controller for the model of Yahtzee.
/// Can control of the variant of Yahtzee 
class YahtzeeController {
  YahtzeeController({
    required YahtzeeModel model,
  }) : _model = model;

  final YahtzeeModel _model;

  /// ----------- Listeners

  /// Register [listener] if it not yet register.
  /// Return true if the listener is added, false otherwise.
  /// 
  /// If [notifyHistory], if [listener] is added, it's notify like a changed occured. 
  void registerFiguresListeners(FiguresListener listener, {List<YahtzeeFigure> figures = YahtzeeFigure.values, bool notifyHistory = false}){
    _model.registerFiguresListeners(listener, figures: figures, notifyHistory: notifyHistory);
  }

  /// Unregister [listener] if it's register.
  /// Return true if the listener is removed, false otherwise. 
  void unregisterFiguresListeners(FiguresListener listener){
    _model.unregisterFiguresListeners(listener);
  }

  /// Register [listener] if it not yet register.
  /// Return true if the listener is added, false otherwise.
  /// 
  /// If [notifyHistory], if [listener] is added, it's notify like a changed occured. 
  void registerValuesListeners(ValuesListener listener, {List<DieFace> faces = DieFace.values, bool notifyHistory = false}){
    _model.registerValuesListeners(listener,notifyHistory: notifyHistory, faces:faces );
  }

  /// Unregister [listener] if it's register.
  /// Return true if the listener is removed, false otherwise. 
  void unregisterValuesListeners(ValuesListener listener, {List<DieFace> faces = DieFace.values}){
    _model.unregisterValuesListeners(listener, faces: faces);
  }
  
  /// Register [listener] if it not yet register.
  /// Return true if the listener is added, false otherwise.
  /// 
  /// If [notifyHistory], if [listener] is added, it's notify like a changed occured. 
  bool registerDifferenceListeners(DifferenceListener listener, {bool notifyHistory = false}){
    return _model.registerDifferenceListeners(listener);
  }

  /// Unregister [listener] if it's register.
  /// Return true if the listener is removed, false otherwise. 
  bool unregisterDifferenceListeners(DifferenceListener listener){
    return _model.unregisterDifferenceListeners(listener);
  }

  /// ----------- Interaction with the model

  /// Set [number] of dice for the [value] if it's possible
  void setDiceNumber({required int number, required DieFace value}){
    if(canSetDieFace(value)){
      _model.setNumberOfDiceForDieFace(dieFace: value, number: number);
    }
  }

  /// Return the number of dice for the [value]
  /// Return 0 if the [value] is not yet set.
  /// 
  /// Show [canSetDieFace] to know if the value is already set.
  int getvalueForDiceValue(DieFace value){
      return _model.getDiceCount(value)?? 0;
  }

  /// Return true if the controller can set a [value].
  bool canSetDieFace(DieFace value){
    return _model.getDiceCount(value) == null;
  }

  /// Clean the model for the specific [value]
  void resetValue(DieFace value){
    _model.resetNumberOfDiceForDieFace(value);
  }

  /// Set [value] on the maximum if it's possible
  set maximum(int value){
    if(canSetMaximum()){
      _model.maximum = value;
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
    return _model.variant == YahtzeeVariant.pauline && _model.maximum == null;
  }

  /// Reset the data save into the maximum
  void resetMaximum(){
    _model.maximum=null;
  }

  /// Set [value] on the minimum if it's possible
  set minimum(int value){
    if(canSetMinimum()){
      _model.minimum = value;
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
    return _model.variant == YahtzeeVariant.pauline && _model.minimum == null;
  }

  /// Reset the data save into the minimum
  void resetMinimum(){
    _model.minimum=null;
  }

  /// Set the [state] for the [figure] if it's possible
  /// 
  /// Show [figureCanBeSet] to know if it's possible
  void setFigureState(YahtzeeFigure figure, YahtzeeState state){
    /// on ne peut ajout une figure dans le model que si elle existe dans la version du jeu
    if(figureCanBeSet(figure)){
      _model.markFigure(figure: figure, state: state);
    }        
  }
  
  /// Reset the stat of the [figure]
  void resetFigure(YahtzeeFigure figure){
    _model.resetFigure(figure);
  }

  ///Return true if [figure] can be set
  bool figureCanBeSet(YahtzeeFigure figure){
    return !_model.isFigureProcessed(figure);
  }

  /// Return the state of the [figure] if it's possible
  YahtzeeState? getState(YahtzeeFigure figure){
    return _model.getFigureState(figure);
  }

  /// Return the total score for all available figures
  int get totalFigureScore {
    return _model.totalFigureScore;
  }

  /// Return the total score for all dice Value
  int get diceScore {
    return _model.diceScore;
  }

  /// Return the total score for all dice Value and bonus
  int get upperSectionScore {
    return _model.upperSectionScore;
  }

  /// Return the total score
  int get totalScore {
    return _model.totalScore;
  }

  /// Return the difference if it exist null.
  /// It's the difference between the maximum and the minimum.
  int? get difference{
    return _model.difference;
  }

  /// Ajoute ou met à jour le nombre de dés pour une valeur
  /// Notifie les listeners appropriés
  void setDiceCount(DieFace value, int count) {
    _model.setNumberOfDiceForDieFace(dieFace: value, number: count);
  }

  /// Marque une figure comme réussie et notifie les listeners
  void markFigureAsSucceed(YahtzeeFigure figure) {
    _model.markFigureAsSucceed(figure);
  }

  /// Marque une figure comme échouée et notifie les listeners
  void markFigureAsFailed(YahtzeeFigure figure) {
    _model.markFigureAsFailed(figure);
  }

  /// Vérifie si le modèle est complet (5 dés assignés)
  bool get isModelComplete => _model.isCompleted;
}