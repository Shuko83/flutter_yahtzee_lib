
import 'package:flutter/material.dart';
import 'package:yahtzee_lib/models/die_face.dart';
import 'package:yahtzee_lib/controllers/yahtzee_controller.dart';
import 'package:yahtzee_lib/models/yahtzee_listeners.dart';

/// Widget which allow player to edit the state of [figure] with [controller]
class DieFaceResultWidget extends StatefulWidget{
  const DieFaceResultWidget({
    super.key,
    required this.face,
    required this.controller,
  });
  
  final YahtzeeController controller;
  final DieFace face;

  @override
  State<DieFaceResultWidget> createState() => _DieFaceResultWidgetState();
}

class _DieFaceResultWidgetState extends State<DieFaceResultWidget> implements DieFacesListener{

  String _score = "";
  @override
  void onNumberOfDieFaceChanged({required DieFace face, required int? value, int? bonusScore, int? upperSectionScore, int? totalDieFaceScore}){
    setState(() {
      if(value != null){
        _score = value.toString();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.registerValuesListeners(this,faces: [widget.face],notifyHistory: true);
  }

 
  @override
  void dispose(){
    widget.controller.unregisterValuesListeners(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_score);
  }
  
  @override
  void onBonusChanged(int? bonusScore) {
    // Nothing to do here
  }
  
  @override
  void onTotalDieFaceScoreChanged(int? totalDieFaceScore) {
    // Nothing to do here
  }
  
  @override
  void onUpperSectionScoreChanged(int? upperSectionScore) {
    // Nothing to do here
  }
}
