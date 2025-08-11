import 'package:yahtzee_lib/models/die_face.dart';
import 'package:dice_icons/dice_icons.dart';
import 'package:flutter/material.dart';

/// Extension pour ajouter des méthodes utilitaires à DieFace
extension DieFaceUiExtension on DieFace {
  /// Converts a DieFace enum to its corresponding icon.
  /// 
  /// This utility function maps each die face to its icon:
  /// - DieFace.die1 → dice1
  /// - DieFace.die2 → dice2
  /// - DieFace.die3 → dice3
  /// - DieFace.die4 → dice4
  /// - DieFace.die5 → dice5
  /// - DieFace.die6 → dice6
  IconData toIconData() => switch(this) {
    DieFace.die1 => DiceIcons.dice1,
    DieFace.die2 => DiceIcons.dice2,
    DieFace.die3 => DiceIcons.dice3,
    DieFace.die4 => DiceIcons.dice4,
    DieFace.die5 => DiceIcons.dice5,
    DieFace.die6 => DiceIcons.dice6,
  };
}
