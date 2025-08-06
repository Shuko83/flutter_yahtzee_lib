import 'package:flutter_test/flutter_test.dart';
import 'package:yahtzee_lib/models/yahtzee_model.dart';
import 'package:yahtzee_lib/controllers/yahtzee_controller.dart';

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

  group('YahtzeeController', () {
    late YahtzeeModel model;
    late YahtzeeController controller;

    setUp(() {
      model = YahtzeeModel();
      controller = YahtzeeController(model: model);
    });

    // Vérifie que les listeners peuvent être ajoutés et retirés
    test('can register and unregister figures listeners', () {
      final testListener = _TestFiguresListener();
      expect(controller.registerFiguresListeners(testListener), isTrue);
      expect(controller.unregisterFiguresListeners(testListener), isTrue);
    });

    // Vérifie qu'ajouter un listener déjà existant retourne false
    test('registering an existing figures listener returns false', () {
      final testListener = _TestFiguresListener();
      expect(controller.registerFiguresListeners(testListener), isTrue);
      expect(controller.registerFiguresListeners(testListener), isFalse);
    });

    // Vérifie que supprimer un listener non existant retourne false
    test('unregistering a non-existing figures listener returns false', () {
      final testListener = _TestFiguresListener();
      expect(controller.unregisterFiguresListeners(testListener), isFalse);
    });

    // Vérifie l'accès à la propriété totalDice via le contrôleur
    test('totalDice returns correct value', () {
      model.numberOfDieFace[DieFace.die1] = 2;
      model.numberOfDieFace[DieFace.die2] = 3;
      expect(controller.totalDice, equals(5));
    });

    // Vérifie l'accès à la complétion du modèle via le contrôleur
    test('isModelComplete returns true when model is complete', () {
      model.numberOfDieFace[DieFace.die1] = 2;
      model.numberOfDieFace[DieFace.die2] = 3;
      expect(controller.isModelComplete, isTrue);
    });

    // Vérifie que le listener est notifié lors d'une modification d'état d'une figure
    test('figures listener is notified when figure state changes', () {
      final notified = <bool>[false];
      final listener = _TestFiguresListener(onChanged: () => notified[0] = true);
      controller.registerFiguresListeners(listener);
      // On modifie l'état d'une figure via le controller
      controller.markFigureAsSucceed(YahtzeeFigure.fullHouse);
      expect(notified[0], isTrue);
      final notified1 = <bool>[false];
      final listener1 = _TestFiguresListener(onChanged: () => notified1[0] = true);
      controller.registerFiguresListeners(listener1,notifyHistory: true);
      expect(notified1[0], isTrue);
      final notified2 = <bool>[false];
      final listener2 = _TestFiguresListener(onChanged: () => notified2[0] = true);
      controller.registerFiguresListeners(listener2,notifyHistory: false);
      controller.unregisterFiguresListeners(listener2);
      controller.markFigureAsSucceed(YahtzeeFigure.fourOfAKind);
      expect(notified2[0], isFalse);
    });

    // Vérifie qu'une figure n'est plus disponible une fois marquée comme succeed
    test("a figure isn't available after being marked as succeed", () {
      final figure = YahtzeeFigure.fullHouse;
      // On marque la figure comme réussie
      controller.markFigureAsSucceed(figure);
      // Supposons que le contrôleur a une méthode ou une logique pour vérifier la disponibilité
      // Ici, on vérifie que la figure est bien marquée comme succeed dans le modèle
      expect(controller.figureCanBeSet(figure), isFalse);
      expect(model.figuresState.containsKey(figure), isTrue);
      expect(model.figuresState[figure], equals(YahtzeeState.succeed));
      // Si tu as une méthode comme isFigureAvailable, tu peux la tester ici
      // expect(controller.isFigureAvailable(figure), isFalse);
    });

    // Vérifie qu'après un reset, toutes les figures sont à nouveau valides/disponibles
    test('all figures are valid/available after model reset', () {
      // On marque plusieurs figures comme succeed
      controller.markFigureAsSucceed(YahtzeeFigure.fullHouse);
      controller.markFigureAsSucceed(YahtzeeFigure.fourOfAKind);
      // On reset le modèle
      controller.resetFigure(YahtzeeFigure.fullHouse);
      controller.resetFigure(YahtzeeFigure.fourOfAKind);
      // Toutes les figures doivent être absentes de figuresState (donc disponibles/non traitées)
      for (final figure in YahtzeeFigure.values) {
        expect(model.figuresState.containsKey(figure), isFalse);
        expect(controller.figureCanBeSet(YahtzeeFigure.fullHouse), isTrue);
      }
    });
  });

}

// Classe de test pour les listeners
class _TestFiguresListener implements FiguresListener {
  final void Function()? onChanged;
  _TestFiguresListener({this.onChanged});
  @override
  void onFigureChanged() {
    if (onChanged != null) onChanged!();
  }
}
