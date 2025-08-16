
import 'package:flutter/material.dart';
import 'package:yahtzee_lib/models/die_face.dart';
import 'package:yahtzee_lib/models/yahtzee_figure.dart';
import 'package:yahtzee_lib/controllers/yahtzee_controller.dart';
import 'package:yahtzee_lib/models/yahtzee_listeners.dart';
import 'package:yahtzee_lib/models/yahtzee_state.dart';

/// Widget which allow player to edit the state of [figure] with [controller]
class TotalScoreResultWidget extends StatefulWidget{
  const TotalScoreResultWidget({
    super.key,
    required this.controller,
  });
  
  final YahtzeeController controller;

  @override
  State<TotalScoreResultWidget> createState() => _TotalScoreResultWidgetState();
}

class _TotalScoreResultWidgetState extends State<TotalScoreResultWidget> implements FiguresListener, ValuesListener, DifferenceListener{

  String _totalScore = "";
  @override
  void onFigureChanged({required YahtzeeFigure figure, required YahtzeeState? state, int? totalFigureScore}){
    _updateState();
  }

  @override
  void onDifferenceChanged({int? difference, int? maximum, int? minimum}) {
    _updateState();
  }

  @override
  void onValueChanged({required DieFace face, required int? value, int? bonusScore, int? upperSectionScore, int? totalDieFaceScore}) {
    _updateState();
  }

  @override
  void initState() {
    super.initState();
    var controller = widget.controller;
    controller.registerFiguresListeners(this,notifyHistory: true);
    controller.registerDifferenceListeners(this);
    controller.registerDifferenceListeners(this);
  }

  @override
  void dispose(){
    var controller = widget.controller;
    controller.unregisterFiguresListeners(this);
    controller.unregisterDifferenceListeners(this);
    controller.unregisterDifferenceListeners(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding:  const EdgeInsets.symmetric(vertical: 1.0),
      child: Text(_totalScore) 
    );
  }

  void _updateState(){
    setState(() {
      _totalScore = widget.controller.getTotalScore().toString();
    });
  }
}
