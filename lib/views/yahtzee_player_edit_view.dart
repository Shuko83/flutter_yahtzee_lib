import 'package:flutter/material.dart';
import '../controllers/yahtzee_controller.dart';
import '../models/die_face.dart';
import 'widgets/die_face_edit_widget.dart';
import 'widgets/figure_edit_widget.dart';
import 'widgets/yahtzee_slider_widget.dart';
import 'widgets/yahtzee_bonus_widget.dart';

class YahtzeePlayerEditView extends StatelessWidget{
  const YahtzeePlayerEditView({
    super.key,
    required this.controller,
    required this.name,
    });

  final YahtzeeController controller;
  final String name;
  
  @override
  Widget build(BuildContext context) {
    const divider = Divider(
            thickness: 2,        // Épaisseur de la ligne
            indent: 20,          // Marge à gauche
            endIndent: 20,       // Marge à droite
          );
    return Column(
      children: [
        Center(child: Text(name),),
        for(var face in DieFace.values)
          DieFaceEditWidget(
            dieFace: face,
            controller: controller,
          ),
          YahtzeeBonusWidget(controller: controller),
          divider,
          YahtzeeSliderWidget(controller: controller,type: SliderType.maximum,),
          YahtzeeSliderWidget(controller: controller,type: SliderType.minimum,),
          divider,
          for(var figure in controller.availableFigures)
            FigureEditWidget(controller: controller, figure: figure),
      ],
    );
  }

}