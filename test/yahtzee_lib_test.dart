import 'package:flutter_test/flutter_test.dart';
import 'package:yahtzee_lib/models/yahtzee_model.dart';

void main() {
  group('YahtzeeModel', () {
    late YahtzeeModel model;

    setUp(() {
      model = YahtzeeModel();
    });

    // Vérifie que l'état initial du modèle est vide et non initialisé
    test('initial state is empty', () {
      expect(model.numberOfDieFace, isEmpty);
      expect(model.figuresState, isEmpty);
      expect(model.maximum, isNull);
      expect(model.minimum, isNull);
      expect(model.chance, isNull);
      expect(model.totalDice, equals(0));
      expect(model.difference, isNull);
      expect(model.isComplete, isFalse);
    });

    // Vérifie que getDiceCount retourne 0 pour une face non définie
    test('getDiceCount returns 0 for unset face', () {
      expect(model.getDiceCount(DieFace.die1), equals(0));
    });

    // Vérifie que totalDice additionne correctement tous les dés
    test('totalDice sums all dice', () {
      model.numberOfDieFace[DieFace.die1] = 2;
      model.numberOfDieFace[DieFace.die2] = 3;
      expect(model.totalDice, equals(5));
    });

    // Vérifie que difference retourne la bonne valeur lorsque maximum et minimum sont définis
    test('difference returns correct value', () {
      model.maximum = 20;
      model.minimum = 10;
      expect(model.difference, equals(10));
    });

    // Vérifie le comportement de isFigureSucceed et isFigureProcessed
    test('isFigureSucceed and isFigureProcessed', () {
      // Cas où la figure n'est pas encore traitée
      expect(model.isFigureProcessed(YahtzeeFigure.fullHouse), isFalse);
      expect(model.isFigureSucceed(YahtzeeFigure.fullHouse), isFalse);

      // Cas où la figure a réussi
      model.figuresState[YahtzeeFigure.fullHouse] = YahtzeeState.succeed;
      expect(model.isFigureProcessed(YahtzeeFigure.fullHouse), isTrue);
      expect(model.isFigureSucceed(YahtzeeFigure.fullHouse), isTrue);

      // Cas où la figure a échoué
      model.figuresState[YahtzeeFigure.fourOfAKind] = YahtzeeState.failed;
      expect(model.isFigureSucceed(YahtzeeFigure.fourOfAKind), isFalse);
    });

    // Vérifie que reset réinitialise bien tous les états du modèle
    test('reset clears all state', () {
      model.numberOfDieFace[DieFace.die1] = 2;
      model.figuresState[YahtzeeFigure.fullHouse] = YahtzeeState.succeed;
      model.maximum = 10;
      model.minimum = 5;
      model.chance = 12;

      model.reset();

      expect(model.numberOfDieFace, isEmpty);
      expect(model.figuresState, isEmpty);
      expect(model.maximum, isNull);
      expect(model.minimum, isNull);
      expect(model.chance, isNull);
    });

    // Vérifie que isComplete retourne true lorsque le nombre total de dés est 5
    test('isComplete returns true when totalDice is 5', () {
      model.numberOfDieFace[DieFace.die1] = 2;
      model.numberOfDieFace[DieFace.die2] = 3;
      expect(model.isComplete, isTrue);
    });
  });
}
