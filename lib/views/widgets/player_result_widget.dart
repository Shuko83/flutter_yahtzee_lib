import 'package:flutter/material.dart';
import 'package:yahtzee_lib/models/yahtzee_player.dart';
import 'package:yahtzee_lib/views/widgets/figures_result_widget.dart';
import 'package:yahtzee_lib/views/widgets/upper_section_result_widget.dart';
import 'package:yahtzee_lib/views/widgets/difference_result_widget.dart';
import 'package:yahtzee_lib/views/widgets/total_score_result_widget.dart';

class PlayerResultWidget extends StatelessWidget{
  const PlayerResultWidget({
    super.key,
    required this.player
    });
  final YahtzeePlayer player;

  @override
  Widget build(BuildContext context) {
    var controller = player.controller;
    return Column(
      children: [
        //Name of player
        Padding(padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Text(
            player.name,
            style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
          ),
        ),
        UpperSectionResultWidget(controller: controller),
        DifferenceResultWidget(controller: controller),
        FiguresResultWidget(controller: controller),
        TotalScoreResultWidget(controller: controller,),
      ]      
    );
  }
}
