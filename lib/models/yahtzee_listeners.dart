import 'yahtzee_figure.dart';
import 'yahtzee_state.dart';
import 'die_face.dart';

/// Interface for a listener which is notify when the difference changed.
abstract class DifferenceListener{
  void onDifferenceChanged({int? difference, int? maximum, int? minimum});
}

/// Interface for a listener which is notify when the chance changed.
abstract class ChanceListener{
  void onChanceChanged(int? value);
}

/// Interface for a listener which is notify when a figure changed.
abstract class FiguresListener{
  void onFigureChanged({required YahtzeeFigure figure, required YahtzeeState? state, int? totalFigureScore});
}

/// Interface for a listener which is notify when a value changed.
abstract class ValuesListener{
  void onValueChanged({required DieFace face, required int? value, int? bonusScore, int? upperSectionScore, int? totalDieFaceScore});
}