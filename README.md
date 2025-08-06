# yahtzee_lib

**yahtzee_lib** est une librairie Dart qui fournit un modèle de données et des outils pour gérer la logique du jeu de société Yahtzee.  
Elle permet de représenter l’état d’une partie, de manipuler les dés, de suivre les figures réalisées et de calculer les scores.

## Fonctionnalités

- Modélisation des dés et des différentes figures du Yahtzee
- Suivi de l’état de chaque figure (réussie, échouée, non traitée)
- Calcul automatique du nombre total de dés, du score maximum, minimum, et de la différence
- Méthodes utilitaires pour réinitialiser la partie, vérifier la complétion, etc.
- **Contrôleur** pour piloter le modèle et gérer la logique métier

## Prise en main

Ajoute simplement la dépendance à ton projet Dart ou Flutter, puis importe le modèle et/ou le contrôleur :

```dart
import 'package:yahtzee_lib/models/yahtzee_model.dart';
import 'package:yahtzee_lib/controllers/yahtzee_controller.dart';

final model = YahtzeeModel();
final controller = YahtzeeController(model: model);
```

## Exemple d’utilisation

```dart
final model = YahtzeeModel();
final controller = YahtzeeController(model: model);

model.numberOfDieFace[DieFace.die1] = 2;
model.numberOfDieFace[DieFace.die2] = 3;

print(controller.totalDice); // Affiche 5
print(controller.isModelComplete); // Affiche true si 5 dés sont assignés
```

## À propos du contrôleur

Le contrôleur `YahtzeeController` permet de piloter le modèle, d'ajouter des listeners pour réagir aux changements d'état, et d'encapsuler la logique métier du jeu. Il expose des méthodes pour interagir avec le modèle de façon sécurisée et centralisée.

## Informations complémentaires

- Compatible avec Dart et Flutter
- Des tests unitaires sont inclus pour garantir la fiabilité du modèle et du contrôleur
- Idéal pour créer des applications, des jeux ou des outils autour du Yahtzee
