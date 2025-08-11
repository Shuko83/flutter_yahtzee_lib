
import 'package:flutter/material.dart';
import '../../controllers/yahtzee_controller.dart';

/// Widget which allow player to select a number from a slideBar
/// [type] represents the data to store 
class YahtzeeSliderWidget extends StatefulWidget{

  const YahtzeeSliderWidget({
    super.key,
    required this.controller,
    required this.type,
  });

  final YahtzeeController controller;
  final SliderType type;
  
  @override
  State<YahtzeeSliderWidget> createState() => _YahtzeeSliderWidgetState();
}

class _YahtzeeSliderWidgetState extends State<YahtzeeSliderWidget> {

  /// By default the min value.
  double _currentSliderValue = 5;

  /// Ask the controller to set the value for the type 
  void onValidClicked(double value){
    setState(() {
      switch(widget.type){
        case SliderType.maximum:
          widget.controller.maximum = value.toInt();
          break;
        case SliderType.minimum:
          widget.controller.minimum = value.toInt();
          break;
        default:
          throw "Not yet implemented";
      }
    });
  }

  /// Ask the controller to reset data for the type.
  void onResetClicked(){
    setState(() {
      switch(widget.type){
        case SliderType.maximum:
          widget.controller.resetMaximum();
          break;
        case SliderType.minimum:
          widget.controller.resetMinimum();
          break;
        default:
          throw "Not yet implemented";
      }
    });
  }

  /// Ask the controller to have the correct value to show
  int valueToShow(){
    switch(widget.type){
        case SliderType.maximum:
          return widget.controller.maximum;
        case SliderType.minimum:
          return widget.controller.minimum;
        default:
          throw "Not yet implemented";
      }
  }

  /// Ask the controller if the mode of the widget is editable   
  bool getEditMode(){
    switch(widget.type){
      case SliderType.maximum:
        return widget.controller.canSetMaximum();
      case SliderType.minimum:
        return widget.controller.canSetMinimum();
      default:
        throw "Not yet implemented";
    }
  }

  @override
  Widget build(BuildContext context){
    var type = widget.type;
    var text = type.name;
    var editMode = getEditMode();
    
    /// In [editMode] the widget show a slideBar and a button to validate the value select in the bar
    if(editMode){
      return Row(
        children: [
          Text(text),
          Slider(
          value: _currentSliderValue,
          max: 30,
          divisions: 25,
          min: 5,
          label: _currentSliderValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
            });
          },
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () => onValidClicked(_currentSliderValue), 
          child: const Icon(Icons.check_circle_outline)),
        ],
      );
    } else{ /// Ele provide a widget to reset the data and show the current value.
      return Row(
        children: [  
          Text(text),
          const Spacer(),
          Text(valueToShow().toString()),
          ElevatedButton(onPressed:() => onResetClicked(), child: const Icon(Icons.edit)),
        ],
      );
    }
  }
}

enum SliderType{
  maximum,
  minimum,
  chance,
}