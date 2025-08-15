import 'yahtzee_model.dart';
import '../controllers/yahtzee_controller.dart';

class YahtzeePlayer {
  YahtzeePlayer({required String name, required YahtzeeModel model}) : _name = name, _model = model , _controller = YahtzeeController(model: model);

  final String _name;
  final YahtzeeModel _model;
  final YahtzeeController _controller;

  String get name => _name;
  YahtzeeController get controller => _controller;
  YahtzeeModel get model => _model;
}