import 'package:flutter/material.dart';
import 'package:yahtzee_lib/models/yahtzee_model.dart';
import 'package:yahtzee_lib/models/yahtzee_player.dart';
import 'package:yahtzee_lib/views/widgets/player_result_widget.dart';
import 'package:yahtzee_lib/views/widgets/title_widget.dart';

class ResultPageWidget extends StatelessWidget{
  const ResultPageWidget({
    super.key,
    required this.players
    });
  final List<YahtzeePlayer> players;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TitleWidget(variant: YahtzeeVariant.pauline,),
        for(var player in players)
          PlayerResultWidget(player: player),
      ],
    );
  }
}
