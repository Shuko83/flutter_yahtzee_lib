
import 'package:flutter/material.dart';
import 'package:yahtzee_lib/controllers/yahtzee_controller.dart';
import 'package:yahtzee_lib/models/yahtzee_listeners.dart';

/// Widget which allow player to edit the state of [figure] with [controller]
class DifferenceResultWidget extends StatefulWidget{
  const DifferenceResultWidget({
    super.key,
    required this.controller,
  });
  
  final YahtzeeController controller;

  @override
  State<DifferenceResultWidget> createState() => _DifferenceResultWidgetState();
}

class _DifferenceResultWidgetState extends State<DifferenceResultWidget> implements DifferenceListener{

  String _maximum = "";
  String _minimum = "";
  String _difference = "";

  @override
  void onDifferenceChanged({int? difference, int? maximum, int? minimum}){
    setState(() {
      if(difference != null){
        _difference = difference.toString();
      }
      if(maximum != null){
        _maximum = maximum.toString();
      }
      if(minimum != null){
        _minimum = minimum.toString();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.registerDifferenceListeners(this,notifyHistory: true);
  }

  @override
  void dispose(){
    widget.controller.unregisterDifferenceListeners(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding:  const EdgeInsets.symmetric(vertical: 1.0),
            child: Text(_maximum) 
        ),
        Padding(padding:  const EdgeInsets.symmetric(vertical: 1.0),
            child: Text(_minimum) 
        ),
        Padding(padding:  const EdgeInsets.symmetric(vertical: 1.0),
            child: Text(_difference) 
        ),
      ]
    );
  }
}
