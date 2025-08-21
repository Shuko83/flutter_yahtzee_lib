import 'package:flutter/material.dart';
import 'package:yahtzee_lib/models/die_face.dart';
import 'package:yahtzee_lib/models/yahtzee_figure.dart';
import 'package:yahtzee_lib/models/yahtzee_model.dart';

class TitleWidget extends StatelessWidget{
  const TitleWidget({
    super.key,
    required this.variant
    });
  final YahtzeeVariant variant;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(padding:  const EdgeInsets.symmetric(vertical: 1.0),
            child: Text("Player"), 
        ),
        for(var dieFace in DieFace.values)
          Padding(padding:  const EdgeInsets.symmetric(vertical: 1.0),
            child: Text(dieFace.name),
          ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 1.0),
            child: Text("Total die Face"), 
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 1.0),
            child: Text("Bonus"), 
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 1.0),
            child: Text("Total upper section"), 
        ),
        if(variant == YahtzeeVariant.pauline)
          const Row(
           children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 1.0),
            child: Text("Maximum"),  
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 1.0),
            child: Text("Minimum"), 
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 1.0),
            child: Text("Difference"), 
            ),
          ],),
        if(variant == YahtzeeVariant.classic)
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0),
            child: Text("Chance"), 
          ),
        if(variant == YahtzeeVariant.pauline)
          for(var figure in [YahtzeeFigure.longStraight,YahtzeeFigure.fullHouse,YahtzeeFigure.fourOfAKind,YahtzeeFigure.yahtzee])
          Padding(padding:  const EdgeInsets.symmetric(vertical: 1.0),
            child: Text(figure.name),
          ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 1.0),
            child: Text("Total figures")
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 1.0),
            child: Text("Total score")
        ),
      ],
    );
  }
}