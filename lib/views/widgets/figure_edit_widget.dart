
import 'package:flutter/material.dart';
import '../../controllers/yahtzee_controller.dart';
import '../../models/yahtzee_figure.dart';
import '../../models/yahtzee_state.dart';

/// Widget which allow player to edit the state of [figure] with [controller]
class FigureEditWidget extends StatefulWidget{
  const FigureEditWidget({
    super.key,
    required this.controller,
    required this.figure,
  });
  
  final YahtzeeController controller;
  final YahtzeeFigure figure;

  @override
  State<FigureEditWidget> createState() => _FigureEditWidgetState();
}

class _FigureEditWidgetState extends State<FigureEditWidget> {

  /// Ask controller to reset figure
  void resetFigure(){
    setState(() {
      widget.controller.resetFigure(widget.figure);
    });
  }

  /// Ask controller to change [state] for figure
  void changeState(YahtzeeState state){
    setState(() {
      widget.controller.setFigureState(widget.figure,state);
    });
  }

  @override
  Widget build(BuildContext context) {
    var editMode = widget.controller.figureCanBeSet(widget.figure);
    var figureState = widget.controller.getState(widget.figure);

    var icon = (figureState!=null && figureState == YahtzeeState.succeed)?Icons.check_circle_outline:Icons.cancel_outlined;
    var iconColor = (figureState!=null && figureState == YahtzeeState.succeed)? Colors.green:Colors.red;

    ///In [editMode] provides 2 buttons, 1 for each state and allow player to select them
    if(editMode){
      return Row(
        children: [
          Text(widget.figure.name),
          const Spacer(),
          ElevatedButton(
            onPressed: () => {changeState(YahtzeeState.succeed)},
            child: Text(YahtzeeState.succeed.name,
            ),
          ),
          ElevatedButton(
            onPressed: () => {changeState(YahtzeeState.failed)},
            child: Text(YahtzeeState.failed.name,
            ),
          ),
        ]
      );
    } else{ // Else provide an icon that represents the state of the figure and provide a button to reset it.
      return Row(
          children: [
          Text(widget.figure.name),
          const Spacer(),
            Icon(icon,
            color: iconColor,),
            ElevatedButton(
              onPressed: resetFigure,
              child: const Icon(Icons.edit),
              ),
          ]
      );
    }
  }
}
