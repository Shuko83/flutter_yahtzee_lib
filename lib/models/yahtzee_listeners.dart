import 'yahtzee_figure.dart';
import 'yahtzee_state.dart';
import 'die_face.dart';

/// Interface for a listener which is notify when the difference, the maximum or the minimum changed.
abstract class DifferenceListener{
  void onDifferenceChanged(int? difference);
  void onMinimumChanged(int? minimum);
  void onMaximumChanged(int? maximum);
}

/// Interface for a listener which is notify when the chance changed.
abstract class ChanceListener{
  void onChanceChanged(int? value);
}

/// Interface for a listener which is notify when a figure changed.
abstract class FiguresListener{
  void onFigureChanged({required YahtzeeFigure figure, required YahtzeeState? state});
  void onTotalFigureScoreChanged(int? totalFigureScore);
}

/// Interface for a listener which is notify when a value changed.
abstract class DieFacesListener{
  void onNumberOfDieFaceChanged({required DieFace face, required int? value});
  void onBonusChanged(int? bonusScore);
  void onUpperSectionScoreChanged(int? upperSectionScore);
  void onTotalDieFaceScoreChanged(int? totalDieFaceScore);
}

/// Interface for a listener which is notify when the total score changed.
abstract class TotalScoreListener{
  void onTotalScoreChanged(int value);
}