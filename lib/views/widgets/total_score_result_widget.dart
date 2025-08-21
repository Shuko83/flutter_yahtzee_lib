
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

class _TotalScoreResultWidgetState extends State<TotalScoreResultWidget> implements TotalScoreListener{

  String _totalScore = "";
  
  @override
  void initState() {
    super.initState();
    var controller = widget.controller;
    controller.registerTotalScoreListener(this,notifyHistory: true);
  }

  @override
  void dispose(){
    var controller = widget.controller;
    controller.unregisterTotalScoreListener(this,notifyHistory: true);
    super.dispose();
  }
  @override
  void onTotalScoreChanged(int value) {
    // TODO: implement onTotalScoreChanged
  }
    setState(() {
      _totalScore = value.toString();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(padding:  const EdgeInsets.symmetric(vertical: 1.0),
      child: Text(_totalScore) 
    );
  }
  

}
