
import 'package:flutter/material.dart';
import 'package:yahtzee_lib/models/yahtzee_figure.dart';
import 'package:yahtzee_lib/controllers/yahtzee_controller.dart';
import 'package:yahtzee_lib/models/yahtzee_listeners.dart';
import 'package:yahtzee_lib/models/yahtzee_state.dart';
import 'package:yahtzee_lib/views/widgets/figure_result_widget.dart';

/// Widget which allow player to edit the state of [figure] with [controller]
class FiguresResultWidget extends StatefulWidget{
  const FiguresResultWidget({
    super.key,
    required this.controller,
  });
  
  final YahtzeeController controller;

  @override
  State<FiguresResultWidget> createState() => _FiguresResultWidgetState();
}

class _FiguresResultWidgetState extends State<FiguresResultWidget> implements FiguresListener{

  String _totalFigureScore = "";
  @override
  void onFigureChanged({required YahtzeeFigure figure, required YahtzeeState? state, int? totalFigureScore}){
    setState(() {
      if(totalFigureScore != null){
        _totalFigureScore = totalFigureScore.toString();
      }
    });
  }

@override
  void initState() {
    super.initState();
    widget.controller.registerFiguresListeners(this, notifyHistory: true);
  }

  @override
  void dispose(){
    widget.controller.unregisterFiguresListeners(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for(var figure in YahtzeeFigure.values)
          Padding(padding:  const EdgeInsets.symmetric(vertical: 1.0),
            child: FigureResultWidget(controller: widget.controller, figure: figure),
          ),
        Padding(padding:  const EdgeInsets.symmetric(vertical: 1.0),
            child: Text(_totalFigureScore) 
        ),
      ]
    );
  }
}
