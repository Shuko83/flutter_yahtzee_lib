import 'package:flutter_test/flutter_test.dart';
import 'package:yahtzee_lib/models/yahtzee_model.dart';
import 'package:yahtzee_lib/models/die_face.dart';
import 'package:yahtzee_lib/models/yahtzee_figure.dart';
import 'package:yahtzee_lib/models/yahtzee_state.dart';

void main() {
  group('YahtzeeModelPauline', () {
    late YahtzeeModel modelPauline;
    late YahtzeeModel modelClassic;

    setUp(() {
      modelPauline = YahtzeeModel(variant: YahtzeeVariant.pauline);
      modelClassic = YahtzeeModel();
    });

    // Vérifie que l'état initial du modèle est vide et non initialisé
    test('initial state is empty', () {
      /// test sur le modèle classic

      expect(modelClassic.maximum, isNull);
      expect(modelClassic.minimum, isNull);
      expect(modelClassic.chance, isNull);
      expect(modelClassic.upperSectionScore, equals(0));
      expect(modelClassic.difference, isNull);
      expect(modelClassic.isCompleted, isFalse);

      /// test sur le modèle de pauline
      expect(modelPauline.maximum, isNull);
      expect(modelPauline.minimum, isNull);
      expect(modelPauline.chance, isNull);
      expect(modelPauline.upperSectionScore, equals(0));
      expect(modelPauline.difference, isNull);
      expect(modelPauline.isCompleted, isFalse);
    });

    // Vérifie que getDiceCount retourne 0 pour une face non définie
    test('getDiceCount returns 0 for unset face', () {
      expect(modelPauline.getDiceCount(DieFace.die1), isNull);
    });

    // Vérifie que totalDice additionne correctement tous les dés
    test('totalDice sums all dice', () {
      modelPauline.setNumberOfDiceForDieFace(dieFace: DieFace.die1, number: 2); // 2 * 1 point pour la face 1 = 2
      modelPauline.setNumberOfDiceForDieFace(dieFace: DieFace.die2, number: 3); // 3 * 2 point pour la face 2 = 6
      expect(modelPauline.diceScore, equals(8)); // 6 + 2 = 8
    });

    // Vérifie que difference retourne la bonne valeur lorsque maximum et minimum sont définis
    test('difference returns correct value', () {
      modelPauline.maximum = 20;
      modelPauline.minimum = 10;
      expect(modelPauline.difference, equals(10));
    });

    // Vérifie le comportement de isFigureSucceed et isFigureProcessed
    test('isFigureSucceed and isFigureProcessed', () {
      // Cas où la figure n'est pas encore traitée
      expect(modelClassic.isFigureProcessed(YahtzeeFigure.fullHouse), isFalse);
      expect(modelClassic.isFigureSucceed(YahtzeeFigure.fullHouse), isFalse);

      // Cas où la figure a réussi
      modelClassic.markFigureAsSucceed(YahtzeeFigure.fullHouse);
      expect(modelClassic.isFigureProcessed(YahtzeeFigure.fullHouse), isTrue);
      expect(modelClassic.isFigureSucceed(YahtzeeFigure.fullHouse), isTrue);

      // Cas où la figure a échoué
      modelClassic.markFigureAsFailed(YahtzeeFigure.fourOfAKind);
      expect(modelClassic.isFigureSucceed(YahtzeeFigure.fourOfAKind), isFalse);
      expect(modelClassic.isFigureProcessed(YahtzeeFigure.fourOfAKind), isTrue);

    });

    // Vérifie que reset réinitialise bien tous les états du modèle
    test('reset clears all state', () {
      modelClassic.setNumberOfDiceForDieFace(dieFace: DieFace.die1, number: 1);
      modelClassic.markFigureAsSucceed(YahtzeeFigure.fullHouse);
      modelClassic.maximum = 10;
      modelClassic.minimum = 5;
      modelClassic.chance = 12;

      modelClassic.reset();

      expect(modelClassic.maximum, isNull);
      expect(modelClassic.minimum, isNull);
      expect(modelClassic.chance, isNull);
    });

    // Vérifie que isCompleted retourne true lorsque la feuille de jeu est complétée
    // Dépend du variant.
    test(' returns true when totalDice is 5', () {
      modelClassic.reset();
      modelPauline.reset();
      for(var model in {modelClassic,modelPauline}){
        model.setNumberOfDiceForDieFace(dieFace: DieFace.die1, number: 2);
        model.setNumberOfDiceForDieFace(dieFace: DieFace.die2, number: 2);
        model.setNumberOfDiceForDieFace(dieFace: DieFace.die3, number: 2);
        model.setNumberOfDiceForDieFace(dieFace: DieFace.die4, number: 2);
        model.setNumberOfDiceForDieFace(dieFace: DieFace.die5, number: 2);
        model.setNumberOfDiceForDieFace(dieFace: DieFace.die6, number: 2);
        expect(model.isCompleted, isFalse);
      }
      modelClassic.chance = 3;
      expect(modelClassic.isCompleted, isFalse);
      modelPauline.minimum = 12;
      modelPauline.maximum = 13;
      expect(modelPauline.isCompleted, isFalse);
      for(var model in {modelClassic,modelPauline}){
        for(var figure in {YahtzeeFigure.yahtzee,YahtzeeFigure.fourOfAKind,YahtzeeFigure.fullHouse,YahtzeeFigure.longStraight}){
          model.markFigureAsFailed(figure);
        }
      }
      expect(modelPauline.isCompleted, isTrue);
      expect(modelClassic.isCompleted, isFalse);
      modelClassic.markFigureAsSucceed(YahtzeeFigure.threeOfAKind);
      modelClassic.markFigureAsSucceed(YahtzeeFigure.smallStraight);
      expect(modelClassic.isCompleted, isTrue);
    });

    test(' test get dice count', () {
      modelClassic.reset();
      // On vérifie qu'une face non set retourne bien 0 
      expect(modelClassic.getDiceCount(DieFace.die2), isNull);
      
      modelClassic.setNumberOfDiceForDieFace(dieFace: DieFace.die1, number: 3);
      expect(modelClassic.getDiceCount(DieFace.die1), equals(3));
    });
  });
}
