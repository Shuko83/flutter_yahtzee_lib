
import 'package:flutter/material.dart';
import 'package:yahtzee_lib/models/die_face.dart';
import 'package:yahtzee_lib/controllers/yahtzee_controller.dart';
import 'package:yahtzee_lib/models/yahtzee_listeners.dart';
import 'die_face_result_widget.dart';

/// Widget which allow player to edit the state of [figure] with [controller]
class UpperSectionResultWidget extends StatefulWidget{
  const UpperSectionResultWidget({
    super.key,
    required this.controller,
  });
  
  final YahtzeeController controller;

  @override
  State<UpperSectionResultWidget> createState() => _UpperSectionResultWidgetState();
}

class _UpperSectionResultWidgetState extends State<UpperSectionResultWidget> implements ValuesListener{

  String _totalDieFaceScore = "";
  String _bonusScore = "";
  String _totalUpperSectionScore = "";

  @override
  void onValueChanged({required DieFace face, required int? value, int? bonusScore, int? upperSectionScore, int? totalDieFaceScore}){
    setState(() {
      if(totalDieFaceScore != null){
        _totalDieFaceScore = totalDieFaceScore.toString();
      }
      if(bonusScore != null){
        _bonusScore = bonusScore.toString();
      }
      if(upperSectionScore != null){
        _totalUpperSectionScore = upperSectionScore.toString();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.registerValuesListeners(this,notifyHistory: true);
  }

  @override
  void dispose(){
    widget.controller.unregisterValuesListeners(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for(var dieFace in DieFace.values)
          Padding(padding:  const EdgeInsets.symmetric(vertical: 4.0),
            child: DieFaceResultWidget(controller: widget.controller, face: dieFace),
          ),
        Padding(padding:  const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(_totalDieFaceScore) 
        ),
        Padding(padding:  const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(_bonusScore) 
        ),
        Padding(padding:  const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(_totalUpperSectionScore) 
        ),
      ]
    );
  }
}
