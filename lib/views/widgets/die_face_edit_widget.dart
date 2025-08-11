import 'package:flutter/material.dart';
import 'die_face_ui_extension.dart';
import 'package:yahtzee_lib/controllers/yahtzee_controller.dart';
import 'package:yahtzee_lib/models/die_face.dart';

/// Widget which allow player to set the number of dice for the [dieFace]
class DieFaceEditWidget extends StatefulWidget{
  const DieFaceEditWidget({
    super.key,
    required this.controller,
    required this.dieFace,
    });

    final YahtzeeController controller;
    final DieFace dieFace;

  @override
  State<DieFaceEditWidget> createState() => _DieFaceEditWidgetState();
}

class _DieFaceEditWidgetState extends State<DieFaceEditWidget> {

  /// Ask the controller to remove the number of dice for dieFace
  void reset(){
    setState(() {
      widget.controller.resetValue(widget.dieFace);
    });
  }

  /// Ask the controller to set the [number] of dice for diceValue
  void onValueClicked(int number){
    setState(() {
      widget.controller.setDiceNumber(number: number, value: widget.dieFace);
    });
  }

  @override
  Widget build(BuildContext context) {
    var controller = widget.controller;
    var dieFace = widget.dieFace;
    var editMode = controller.canSetDieFace(dieFace);
    /// In [editMode] create button to select the number of dice to set
    if(editMode){
      return Row(
        children: [
          Icon(dieFace.toIconData()),
          for(var i = 0 ; i <= 5 ; ++i )
            ElevatedButton(
              onPressed: () => onValueClicked(i),
              child: Text(i.toString()),
            ),
        ],
      );
    } else{ // Else show the number of dice set previously and a button to reset data
      return Row(
        children: [
          Icon(dieFace.toIconData()),
          const Spacer(),
          Text(controller.getvalueForDiceValue(dieFace).toString()),
          ElevatedButton(onPressed: ()=> reset(), child: const Icon(Icons.edit)),
        ],
      );
    }
  }
}
