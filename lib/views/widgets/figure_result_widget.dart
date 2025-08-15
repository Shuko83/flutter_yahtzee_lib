
import 'package:flutter/material.dart';
import 'package:yahtzee_lib/models/yahtzee_figure.dart';
import 'package:yahtzee_lib/controllers/yahtzee_controller.dart';
import 'package:yahtzee_lib/models/yahtzee_listeners.dart';
import 'package:yahtzee_lib/models/yahtzee_state.dart';

/// Widget which allow player to edit the state of [figure] with [controller]
class FigureResultWidget extends StatefulWidget{
  const FigureResultWidget({
    super.key,
    required this.figure,
    required this.controller,
  });
  
  final YahtzeeController controller;
  final YahtzeeFigure figure;

  @override
  State<FigureResultWidget> createState() => _FigureResultWidgetState();
}

class _FigureResultWidgetState extends State<FigureResultWidget> implements FiguresListener{

  String _score = "";
  @override
  void onFigureChanged({required YahtzeeFigure figure, required YahtzeeState? state, int? totalFigureScore}){
    setState(() {
      var score = widget.controller.getScoreForFigure(figure);
      if(score != null){
        _score = score.toString();
      }
    });
  }

@override
  void initState() {
    super.initState();
    widget.controller.registerFiguresListeners(this,figures: [widget.figure],notifyHistory: true);
  }

  @override
  void dispose(){
    widget.controller.unregisterFiguresListeners(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding:  const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(_score) 
    );
  }
}
