
import 'package:flutter/material.dart';
import '../../controllers/yahtzee_controller.dart';
import '../../models/yahtzee_listeners.dart';
import '../../models/die_face.dart';

class YahtzeeBonusWidget extends StatefulWidget{
  const YahtzeeBonusWidget({
    super.key,
    required this.controller,
  }
  );

  final YahtzeeController controller;

  @override
  State<YahtzeeBonusWidget> createState() => _YahtzeeBonusWidgetState();
  
}

class _YahtzeeBonusWidgetState extends State<YahtzeeBonusWidget> implements DieFacesListener{
  late String pointNeeded;


  @override
  void onNumberOfDieFaceChanged({required DieFace face, required int? value, int? bonusScore, int? upperSectionScore, int? totalDieFaceScore}){
  /// Need to rebuild widget with correct value.
   setState(() {
    pointNeeded = widget.controller.getDistanceToBonus().toString();
   }); 
  }
  
  @override
  void initState() {
    /// Called at init.
    widget.controller.registerValuesListeners(this);
    pointNeeded = widget.controller.getDistanceToBonus().toString();
    super.initState();
  }

  @override
  void dispose(){
    /// Called at the destruction of widget.
    widget.controller.unregisterValuesListeners(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(widget.controller.bonusSuccess){
      return const Row(
        children: [
          Text("Bonus achieve."),
          Spacer(),
          Icon(Icons.check_circle,
            color: Colors.green, 
          ),
        ],
      );
    }else {   
    return Text('You need $pointNeeded more points to have bonus.'
    );
    }
  }
}
